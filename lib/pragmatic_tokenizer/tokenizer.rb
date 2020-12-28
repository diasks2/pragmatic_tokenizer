require 'set'
require 'cgi'
require 'pragmatic_tokenizer/regex'
require 'pragmatic_tokenizer/languages'
require 'pragmatic_tokenizer/pre_processor'
require 'pragmatic_tokenizer/post_processor'
require 'unicode'

module PragmaticTokenizer
  class Tokenizer

    PUNCTUATION_OPTIONS       = Set.new(%i[all semi none only]).freeze
    NUMBERS_OPTIONS           = Set.new(%i[all semi none only]).freeze
    MENTIONS_OPTIONS          = Set.new(%i[keep_original keep_and_clean remove]).freeze
    MAX_TOKEN_LENGTH          = 50
    NOTHING                   = ''.freeze
    DOT                       = '.'.freeze
    SPACE                     = ' '.freeze
    SINGLE_QUOTE              = "'".freeze

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
      @minimum_length      = opts[:minimum_length] || 1
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

      # Why do we treat stop words differently than abbreviations and contractions? (we don't use @language_module::STOP_WORDS when passing @filter_languages)
      @contractions.merge!(@language_module::CONTRACTIONS) if @contractions.empty?
      @abbreviations       += @language_module::ABBREVIATIONS if @abbreviations.empty?
      @stop_words          += @language_module::STOP_WORDS if @stop_words.empty?

      @filter_languages.each do |lang|
        language = Languages.get_language_by_code(lang)
        @contractions.merge!(language::CONTRACTIONS)
        @abbreviations += language::ABBREVIATIONS
        @stop_words    += language::STOP_WORDS
      end

      raise "Punctuation argument can be only be nil, :all, :semi, :none, or :only" unless PUNCTUATION_OPTIONS.include?(@punctuation)
      raise "Numbers argument can be only be nil, :all, :semi, :none, or :only" unless NUMBERS_OPTIONS.include?(@numbers)
      raise "Mentions argument can be only be nil, :keep_original, :keep_and_clean, or :remove" unless MENTIONS_OPTIONS.include?(@mentions)

      integer_class = Gem::Version.new(RUBY_VERSION) < Gem::Version.new('2.4.0') ? Fixnum : Integer

      raise "In Pragmatic Tokenizer minimum_length must be an Integer"  unless @minimum_length.class  == integer_class || @minimum_length.nil?
      raise "In Pragmatic Tokenizer long_word_split must be an Integer" unless @long_word_split.class == integer_class || @long_word_split.nil?
    end

    # @param [String] text to be tokenized

    def tokenize(text)
      return [] unless text
      raise "In PragmaticTokenizer text must be a String or subclass of String" unless text.class <= String
      CGI.unescapeHTML(" #{text} ")
          .scan(Regex::CHUNK_LONG_INPUT_TEXT)
          .flat_map { |segment| process_segment(segment) }
    end

    private

      def process_segment(segment)
        pre_processed = pre_process(segment)
        @tokens       = PostProcessor.new(text: pre_processed, abbreviations: @abbreviations, downcase: @downcase).call	        
        post_process_tokens
     end

      def pre_process(segment)
        suffix = " < "
        shift_segment = " #{segment}#{suffix}"
        shift_segment.gsub!(/<[^<>]*(?=<)/) { |m|  CGI.escapeHTML(m) }
        shift_segment.delete_suffix!(suffix)
        prune = CGI.unescapeHTML(Loofah.fragment(shift_segment).scrub!(:prune).text)
        prune
          .extend(PragmaticTokenizer::PreProcessor)
          .pre_process(language: @language_module)
      end

      def post_process_tokens
        remove_by_options!
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

      def expand_contractions!
        @tokens = @tokens.flat_map { |token| expand_token_contraction(token) }
      end

      def expand_token_contraction(token)
        normalized = inverse_case(token.gsub(Regex::CONTRACTIONS, SINGLE_QUOTE))
        return token unless @contractions.key?(normalized)
        result    = @contractions[normalized].split(SPACE)
        result[0] = Unicode.capitalize(result[0]) unless @downcase
        result
      end

      def clean!
        @tokens = @tokens
            .flat_map  { |token| split_underscores_asterisk(token) }
            .map!      { |token| remove_irrelevant_characters(token) }
            .delete_if { |token| many_dots?(token) }
      end

      def split_underscores_asterisk(token)
        return token if token =~ Regex::ONLY_HASHTAG_MENTION
        token.split(Regex::UNDERSCORES_ASTERISK)
      end

      def remove_irrelevant_characters(token)
        token.gsub!(Regex::IRRELEVANT_CHARACTERS, NOTHING)
        return token if token =~ Regex::ONLY_HASHTAG_MENTION
        # token.gsub!(Regex::ENDS_WITH_EXCITED_ONE, NOTHING)
        token
      end

      def many_dots?(token)
        token =~ Regex::MANY_PERIODS
      end

      def classic_filter!
        @tokens.map! do |token|
          token.delete!(DOT) if @abbreviations.include?(token.chomp(DOT))
          token.sub!(Regex::ENDS_WITH_APOSTROPHE_AND_S, NOTHING)
          token
        end
      end

      def process_numbers!
        case @numbers
        when :semi
          @tokens.delete_if { |token| token =~ Regex::ONLY_DECIMALS }
        when :none
          @tokens.delete_if { |token| token =~ Regex::NO_DECIMALS_NO_NUMERALS }
        when :only
          @tokens.delete_if { |token| token =~ Regex::NO_DECIMALS }
        end
      end

      def remove_short_tokens!
        @tokens.delete_if { |token| token.length < @minimum_length && !token.match(Regex::EMOJI)   }
      end

      def process_punctuation!
        case @punctuation
        when :semi
          @tokens.delete_if { |token| token =~ Regex::PUNCTUATION4 }
        when :none
          @tokens.delete_if { |token| token =~ Regex::ONLY_PUNCTUATION }
        when :only
          @tokens.keep_if   { |token| token =~ Regex::ONLY_PUNCTUATION }
        end
      end

      def remove_stop_words!
        @tokens.delete_if { |token| @stop_words.include?(inverse_case(token)) }
      end

      def mentions!
        case @mentions
        when :remove
          @tokens.delete_if { |token| token =~ Regex::ONLY_MENTION }
        when :keep_and_clean
          @tokens.map!      { |token| token =~ Regex::ONLY_MENTION ? token[1..-1] : token }
        end
      end

      def hashtags!
        case @hashtags
        when :remove
          @tokens.delete_if { |token| token =~ Regex::ONLY_HASHTAG }
        when :keep_and_clean
          @tokens.map!      { |token| token =~ Regex::ONLY_HASHTAG ? token[1..-1] : token }
        end
      end

      def remove_by_options!
        @tokens.delete_if { |token| token =~ regex_by_options }
      end

      def regex_by_options
        @regex_by_options ||= begin
          regex_array = []
          regex_array << Regex::EMOJI                   if @remove_emoji
          regex_array << Regex::ONLY_EMAIL              if @remove_emails
          regex_array << Regex::STARTS_WITH_HTTP        if @remove_urls
          regex_array << Regex::ONLY_DOMAIN2            if @remove_domains
          Regexp.union(regex_array)
        end
      end

      def split_long_words!
        @tokens = @tokens.flat_map { |token| split_long_word(token) }
      end

      def split_long_word(token)
        return token unless @long_word_split
        return token if token.length <= @long_word_split
        return token if token =~ Regex::ONLY_HASHTAG_MENTION
        return token if token =~ Regex::DOMAIN_OR_EMAIL
        token.split(Regex::HYPHEN_OR_UNDERSCORE)
      end

      def inverse_case(token)
        @downcase ? token : Unicode.downcase(token)
      end

  end
end
