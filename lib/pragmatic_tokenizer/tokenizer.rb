# -*- encoding : utf-8 -*-
require 'pragmatic_tokenizer/languages'
require 'pragmatic_tokenizer/pre_processor'
require 'pragmatic_tokenizer/post_processor'
require 'pragmatic_tokenizer/full_stop_separator'
require 'pragmatic_tokenizer/ending_punctuation_separator'
require 'unicode'

module PragmaticTokenizer
  class Tokenizer

    PUNCTIATION_OPTIONS      = Set.new([:all, :semi, :none, :only]).freeze
    NUMBERS_OPTIONS          = Set.new([:all, :semi, :none, :only]).freeze
    MENTIONS_OPTIONS         = Set.new([:keep_original, :keep_and_clean, :remove]).freeze
    MAX_TOKEN_LENGTH         = 50
    EMPTY_STRING             = ''.freeze
    DOT_STRING               = '.'.freeze
    SPACE_STRING             = ' '.freeze
    REGEX_DOMAIN             = /(\s+|\A)[a-z0-9]{2,}([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,6}(:[0-9]{1,5})?(\/.*)?/ix
    REGEX_URL                = /(http|https)(\.|:)/
    REGEX_HYPHEN             = /\-/
    REGEX_UNDERSCORE         = /\_/
    REGEX_CONTRACTIONS       = /[‘’‚‛‹›＇´`]/
    REGEX_APOSTROPHE_S       = /['’`́]s$/
    REGEX_EMAIL              = /\S+(＠|@)\S+\.\S+/
    REGEX_HASHTAG_OR_MENTION = /[＠@#|＃]/
    REGEX_UNKNOWN1           = /(?<=\s)\_+/
    REGEX_UNKNOWN2           = /\_+(?=\s)/
    REGEX_UNKNOWN3           = /(?<=\A)\_+/
    REGEX_UNKNOWN4           = /\_+(?=\z)/
    REGEX_UNKNOWN5           = /\*+/
    REGEX_UNIFIED1           = Regexp.union(REGEX_UNKNOWN1,
                                            REGEX_UNKNOWN2,
                                            REGEX_UNKNOWN3,
                                            REGEX_UNKNOWN4,
                                            REGEX_UNKNOWN5)
    # https://en.wikipedia.org/wiki/Control_character
    # matches any character with hexadecimal value 00 through 1F or 7F.
    # Rubular: http://rubular.com/r/E83fpBoDjI
    REGEXP_CONTROL                  = /[[:cntrl:]]/
    REGEXP_ENDING_COLON             = /\:(?=\z)/
    REGEXP_EXCLAMATION_AT_START     = /(?<=\A)!+(?=.+)/
    REGEXP_EXCLAMATION_AT_END       = /!+(1*!*)*(?=\z)/
    REGEXP_HYPHEN_AT_START          = /\A(-|–|\u{00AD})/
    REGEXP_SPECIAL_SYMBOL           = /[®©]/
    REGEXP_PERCENT_AT_START         = /\A\%/
    # https://codepoints.net/enclosed_alphanumeric_supplement
    REGEXP_ALPHANUMERIC_SUPPLEMENT  = /[\u{1F100}-\u{1F1FF}]/
    REGEX_UNIFIED2                  = Regexp.union(REGEXP_CONTROL,
                                                   REGEXP_ENDING_COLON,
                                                   REGEXP_EXCLAMATION_AT_START,
                                                   REGEXP_EXCLAMATION_AT_END,
                                                   REGEXP_HYPHEN_AT_START,
                                                   REGEXP_SPECIAL_SYMBOL,
                                                   REGEXP_PERCENT_AT_START,
                                                   REGEXP_ALPHANUMERIC_SUPPLEMENT)
    REGEXP_UNKNOWN17         = /(?<=\D)1+(?=\z)/
    REGEXP_HASHTAG_AT_START  = /\A(#|＃)/
    REGEXP_AT_SIGN_AT_START  = /\A(@|＠)/
    REGEXP_UNKNOWN18         = /(?<=\A)(#|＃)/
    REGEXP_UNKNOWN19         = /(?<=\A)(@|＠)/
    REGEXP_UNKNOWN20         = /\A(#|＃)\S+-/
    REGEXP_UNKNOWN21         = /\u{2744}[\u{FE0F}|\u{FE0E}]?/
    REGEX_UNIFIED3           = Regexp.union(REGEXP_UNKNOWN21,
                                            PragmaticTokenizer::Languages::Common::EMOJI_REGEX)
    REGEXP_UNKNOWN22         = /\A[[:punct:]]+\z/
    REGEXP_UNKNOWN23         = /\A(‹+|\^+|›+|\++)\z/
    REGEX_UNIFIED4           = Regexp.union(REGEXP_UNKNOWN22,
                                            REGEXP_UNKNOWN23)
    REGEXP_UNKNOWN24         = /\A\d+\z/
    REGEXP_UNKNOWN25         = /\A\D+\z/
    REGEXP_UNKNOWN26         = /\D*\d+\d*/
    REGEXP_UNKNOWN27         = /\A-+\z/
    REGEXP_UNKNOWN28         = /\A\.{2,}\z/
    REGEXP_UNKNOWN29         = /[&*+<=>^|~]/i
    REGEX_UNIFIED5           = Regexp.union(REGEXP_UNKNOWN27,
                                            REGEXP_UNKNOWN28,
                                            REGEXP_UNKNOWN29)
    REGEXP_UNKNOWN30         = /\:/
    REGEXP_UNKNOWN31         = /.{,10000}(?=\s|\z)/m


    # @param [Hash] opts optional arguments

    # @option opts [Array] :filter_languages - user-supplied array of languages from which that language's stop words, abbreviations and contractions should be used when calculating the resulting tokens - array elements should be of the String class or can be symbols
    # @option opts [String] :language - two character ISO 639-1 code - can be a String or symbol (i.e. :en or 'en')
    # @option opts [Boolean] :expand_contractions - (default: false)
    # @option opts [Boolean] :remove_stop_words - (default: false)
    # @option opts [Array] :abbreviations - user-supplied array of abbreviations (each element should be downcased with final period removed) - array elements should be of the String class
    # @option opts [Array] :stop_words - user-supplied array of stop words - array elements should be of the String class
    # @option opts [Hash]  :contractions - user-supplied hash of contractions (key is the contracted form; value is the expanded form - both the key and value should be downcased)
    # @option opts [String] :punctuation - see description below - can be a String or symbol (i.e. :none or 'none')
      # Punctuation 'all': Does not remove any punctuation from the result
      # Punctuation 'semi': Removes common punctuation (such as full stops)
      # and does not remove less common punctuation (such as questions marks)
      # This is useful for text alignment as less common punctuation can help
      # identify a sentence (like a fingerprint) while common punctuation
      # (like stop words) should be removed.
      # Punctuation 'none': Removes all punctuation from the result
      # Punctuation 'only': Removes everything except punctuation. The
      # returned result is an array of only the punctuation.
    # @option opts [String] :numbers - see description below - can be a String or symbol (i.e. :none or 'none')
      # Numbers 'all': Does not remove any numbers from the result
      # Numbers 'semi': Removes tokens that include only digits
      # Numbers 'none': Removes all tokens that include a number from the result (including Roman numerals)
      # Numbers 'only': Removes everything except tokens that include a number
    # @option opts [Integer] :minimum_length - minimum length of the token in characters
    # @option opts [Integer] :long_word_split - the specified length to split long words at any hyphen or underscore.
    # @option opts [String] :mentions - :remove (will completely remove it), :keep_and_clean (will prefix) and :keep_original (don't alter the token at all). - can be a String or symbol (i.e. :keep_and_clean or 'keep_and_clean')
    # @option opts [String] :hashtags - :remove (will completely remove it), :keep_and_clean (will prefix) and :keep_original (don't alter the token at all). - can be a String or symbol (i.e. :keep_and_clean or 'keep_and_clean')
    # @option opts [Boolean] :downcase - (default: true)
    # @option opts [Boolean] :clean - (default: false)
    # @option opts [Boolean] :classic_filter - removes dots from acronyms and 's from the end of tokens - (default: false)
    # @option opts [Boolean] :remove_emoji - (default: false)
    # @option opts [Boolean] :remove_emails - (default: false)
    # @option opts [Boolean] :remove_urls - (default: false)
    # @option opts [Boolean] :remove_domains - (default: false)

    def initialize(opts={})
      @filter_languages    = opts[:filter_languages] || []
      @language_module     = Languages.get_language_by_code(opts[:language])
      @expand_contractions = opts[:expand_contractions]
      @remove_stop_words   = opts[:remove_stop_words]
      @punctuation         = opts[:punctuation] ? opts[:punctuation].to_sym : :all
      @numbers             = opts[:numbers] ? opts[:numbers].to_sym : :all
      @minimum_length      = opts[:minimum_length] || 0
      @long_word_split     = opts[:long_word_split]
      @mentions            = opts[:mentions] ? opts[:mentions].to_sym : :keep_original
      @hashtags            = opts[:hashtags] ? opts[:hashtags].to_sym : :keep_original
      @downcase            = opts[:downcase].nil? ? true : opts[:downcase]
      @clean               = opts[:clean]
      @classic_filter      = opts[:classic_filter]
      @remove_emoji        = opts[:remove_emoji]
      @remove_emails       = opts[:remove_emails]
      @remove_urls         = opts[:remove_urls]
      @remove_domains      = opts[:remove_domains]
      @contractions        = opts[:contractions] || {}
      @abbreviations       = Set.new(opts[:abbreviations])
      @stop_words          = Set.new(opts[:stop_words])

      # TODO: why do we treat stop words differently than abbreviations and contractions? (we don't use @language_module::STOP_WORDS when passing @filter_languages)
      @contractions.merge!(@language_module::CONTRACTIONS) if @contractions.empty?
      @abbreviations       += @language_module::ABBREVIATIONS if @abbreviations.empty?
      @stop_words          += @language_module::STOP_WORDS if @stop_words.empty? && @filter_languages.empty?

      @filter_languages.each do |lang|
        language = Languages.get_language_by_code(lang)
        @contractions.merge!(language::CONTRACTIONS)
        @abbreviations += language::ABBREVIATIONS
        @stop_words    += language::STOP_WORDS
      end

      raise "Punctuation argument can be only be nil, :all, :semi, :none, or :only" unless PUNCTIATION_OPTIONS.include?(@punctuation)
      raise "Numbers argument can be only be nil, :all, :semi, :none, or :only" unless NUMBERS_OPTIONS.include?(@numbers)
      raise "Mentions argument can be only be nil, :keep_original, :keep_and_clean, or :remove" unless MENTIONS_OPTIONS.include?(@mentions)
      raise "In Pragmatic Tokenizer minimum_length must be an Integer" unless @minimum_length.class == Fixnum || @minimum_length.nil?
      raise "In Pragmatic Tokenizer long_word_split must be an Integer" unless @long_word_split.class == Fixnum || @long_word_split.nil?
    end

    # @param [String] text to be tokenized

    def tokenize(text)
      return [] unless text
      raise "In Pragmatic Tokenizer text must be a String" unless text.class == String
      CGI.unescapeHTML(text)
          .scan(REGEXP_UNKNOWN31)
          .flat_map { |segment| post_process(pre_process(segment)) }
    end

    private

      def pre_process(text)
        text
            .extend(PragmaticTokenizer::PreProcessor)
            .pre_process(language: @language_module)
      end

      def post_process(text)
        @tokens = run_post_processor(text)
        remove_various!
        process_numbers!
        process_punctuation!
        expand_contractions! if @expand_contractions
        clean!               if @clean
        classic_filter!      if @classic_filter
        remove_short_tokens! if @minimum_length > 0
        remove_stop_words!   if @remove_stop_words
        mentions!            if @mentions
        hashtags!            if @hashtags
        split_long_words!    if @long_word_split
        @tokens.reject(&:empty?)
      end

      def run_post_processor(text)
        PostProcessor.new(
            text:          chosen_case(text),
            abbreviations: @abbreviations,
            downcase:      @downcase
        ).post_process
      end

      def expand_contractions!
        @tokens = @tokens.flat_map { |t| expand_token_contraction(t) }
      end

      def expand_token_contraction(token)
        normalized = inverse_case(token.gsub(REGEX_CONTRACTIONS, "'".freeze))
        return token unless @contractions.key?(normalized)
        result    = @contractions[normalized].split(SPACE_STRING)
        result[0] = Unicode.capitalize(result[0]) unless @downcase
        result
      end

      def clean!
        @tokens = @tokens
            .flat_map { |t| t !~ REGEX_HASHTAG_OR_MENTION ? t.split(REGEX_UNIFIED1) : t }
            .map! { |t| t !~ REGEX_HASHTAG_OR_MENTION ? t.gsub(REGEXP_UNKNOWN17, EMPTY_STRING) : t }
            .map! { |t| t.gsub(REGEX_UNIFIED2, EMPTY_STRING) }
            .delete_if { |t| unknown_method1(t) }
      end

      def unknown_method1(token)
        return true if PragmaticTokenizer::Languages::Common::SPECIAL_CHARACTERS.include?(token)
        return true if token.length > MAX_TOKEN_LENGTH
        return true if token.include?('\\'.freeze)
        token =~ ((token.length == 1) ? REGEXP_UNKNOWN30 : REGEX_UNIFIED5)
      end

      def classic_filter!
        @tokens.map! do |token|
          token.delete!(DOT_STRING) if @abbreviations.include?(token.chomp(DOT_STRING))
          token.sub!(REGEX_APOSTROPHE_S, EMPTY_STRING)
          token
        end
      end

      def process_numbers!
        case @numbers
        when :semi
          @tokens.delete_if { |t| t =~ REGEXP_UNKNOWN24 }
        when :none
          @tokens.delete_if { |t| t =~ REGEXP_UNKNOWN26 || PragmaticTokenizer::Languages::Common::ROMAN_NUMERALS.include?(inverse_case(t)) }
        when :only
          @tokens.delete_if { |t| t =~ REGEXP_UNKNOWN25 }
        end
      end

      def remove_short_tokens!
        @tokens.delete_if { |t| t.length < @minimum_length }
      end

      def process_punctuation!
        case @punctuation
        when :semi
          @tokens.delete_if { |t| PragmaticTokenizer::Languages::Common::SEMI_PUNCTUATION.include?(t) }
        when :none
          @tokens.delete_if { |t| PragmaticTokenizer::Languages::Common::PUNCTUATION.include?(t) || t =~ REGEX_UNIFIED4 }
        when :only
          @tokens.keep_if { |t| PragmaticTokenizer::Languages::Common::PUNCTUATION.include?(t) }
        end
      end

      def remove_stop_words!
        @tokens.delete_if { |token| @stop_words.include?(inverse_case(token)) }
      end

      def mentions!
        case @mentions
        when :remove
          @tokens.delete_if { |t| t =~ REGEXP_AT_SIGN_AT_START }
        when :keep_and_clean
          @tokens.map! { |t| t =~ REGEXP_AT_SIGN_AT_START ? t.gsub!(REGEXP_UNKNOWN19, EMPTY_STRING) : t }
        end
      end

      def hashtags!
        case @hashtags
        when :remove
          @tokens.delete_if { |t| t =~ REGEXP_HASHTAG_AT_START }
        when :keep_and_clean
          @tokens = @tokens
                        .flat_map { |t| t =~ REGEXP_UNKNOWN20 ? t.split(REGEX_HYPHEN) : t }
                        .map { |t| t =~ REGEXP_HASHTAG_AT_START ? t.gsub!(REGEXP_UNKNOWN18, EMPTY_STRING) : t }
        end
      end

      def remove_various!
        @tokens.delete_if { |t| t =~ regex_various }
      end

      def regex_various
        @regex_various ||= begin
          regex_array = []
          regex_array << REGEX_UNIFIED3 if @remove_emoji
          regex_array << REGEX_EMAIL    if @remove_emails
          regex_array << REGEX_URL      if @remove_urls
          regex_array << REGEX_DOMAIN   if @remove_domains
          Regexp.union(regex_array)
        end
      end

      def split_long_words!
        @tokens = @tokens
                      .flat_map { |t| t.length > @long_word_split ? t.split(REGEX_HYPHEN) : t }
                      .flat_map { |t| t.length > @long_word_split ? t.split(REGEX_UNDERSCORE) : t }
      end

      def chosen_case(token)
        @downcase ? Unicode.downcase(token) : token
      end

      def inverse_case(token)
        @downcase ? token : Unicode.downcase(token)
      end

  end
end
