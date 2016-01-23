# -*- encoding : utf-8 -*-
require 'pragmatic_tokenizer/languages'
require 'pragmatic_tokenizer/pre_processor'
require 'pragmatic_tokenizer/post_processor'
require 'pragmatic_tokenizer/full_stop_separator'
require 'pragmatic_tokenizer/ending_punctuation_separator'
require 'unicode'

module PragmaticTokenizer
  class Tokenizer

    attr_reader :text, :punctuation, :language_module, :expand_contractions, :numbers, :minimum_length, :downcase, :classic_filter, :filter_languages, :abbreviations, :contractions, :clean, :remove_stop_words, :stop_words, :remove_emoji, :remove_emails, :mentions, :hashtags, :remove_urls, :remove_domains, :long_word_split

    # @param [String] text to be tokenized
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
    # @option opts [Boolean] :classic_filter - removes dots from acronyms and 's from the end of tokens - (default: false)
    # @option opts [Boolean] :remove_emoji - (default: false)
    # @option opts [Boolean] :remove_emails - (default: false)
    # @option opts [Boolean] :remove_urls - (default: false)
    # @option opts [Boolean] :remove_domains - (default: false)

    def initialize(text, opts = {})
      @text                     = CGI.unescapeHTML(text)
      @filter_languages         = opts[:filter_languages] || []
      @language                 = opts[:language] || 'en'
      @language_module          = Languages.get_language_by_code(@language.to_s)
      @expand_contractions      = opts[:expand_contractions] || false
      @remove_stop_words        = opts[:remove_stop_words] || false
      if @filter_languages.empty?
        @abbreviations          = opts[:abbreviations] || @language_module::ABBREVIATIONS
        @contractions           = opts[:contractions] || @language_module::CONTRACTIONS
        @stop_words             = opts[:stop_words] || @language_module::STOP_WORDS
      else
        merged_abbreviations = []
        @filter_languages.map { |l| merged_abbreviations << Languages.get_language_by_code(l.to_s)::ABBREVIATIONS.flatten }
        merged_abbreviations << opts[:abbreviations].flatten unless opts[:abbreviations].nil?
        @abbreviations          =  merged_abbreviations.flatten

        merged_contractions = {}
        @filter_languages.map { |l| merged_contractions = merged_contractions.merge(Languages.get_language_by_code(l.to_s)::CONTRACTIONS) }
        merged_contractions = merged_contractions.merge(opts[:contractions]) unless opts[:contractions].nil?
        @contractions           =  merged_contractions

        merged_stop_words = []
        @filter_languages.map { |l| merged_stop_words << Languages.get_language_by_code(l.to_s)::STOP_WORDS.flatten }
        merged_stop_words << opts[:stop_words].flatten unless opts[:stop_words].nil?
        @stop_words             =  merged_stop_words.flatten
      end
      @punctuation              = opts[:punctuation] || 'all'
      @numbers                  = opts[:numbers] || 'all'
      @minimum_length           = opts[:minimum_length] || 0
      @long_word_split          = opts[:long_word_split]
      @mentions                 = opts[:mentions] || 'keep_original'
      @hashtags                 = opts[:hashtags] || 'keep_original'
      @downcase                 = opts[:downcase].nil? ? true : opts[:downcase]
      @clean                    = opts[:clean] || false
      @classic_filter           = opts[:classic_filter] || false
      @remove_emoji             = opts[:remove_emoji] || false
      @remove_emails            = opts[:remove_emails] || false
      @remove_urls              = opts[:remove_urls] || false
      @remove_domains           = opts[:remove_domains] || false

      unless punctuation.to_s.eql?('all') ||
        punctuation.to_s.eql?('semi') ||
        punctuation.to_s.eql?('none') ||
        punctuation.to_s.eql?('only')
        raise "Punctuation argument can be only be nil, 'all', 'semi', 'none', or 'only'"
      end
      unless numbers.to_s.eql?('all') ||
        numbers.to_s.eql?('semi') ||
        numbers.to_s.eql?('none') ||
        numbers.to_s.eql?('only')
        raise "Numbers argument can be only be nil, 'all', 'semi', 'none', or 'only'"
      end
      unless mentions.to_s.eql?('keep_original') ||
        mentions.to_s.eql?('keep_and_clean') ||
        mentions.to_s.eql?('remove')
        raise "Mentions argument can be only be nil, 'keep_original', 'keep_and_clean', or 'remove'"
      end
      raise "In Pragmatic Tokenizer text must be a String" unless text.class == String
      raise "In Pragmatic Tokenizer minimum_length must be an Integer" unless minimum_length.class == Fixnum || minimum_length.nil?
      raise "In Pragmatic Tokenizer long_word_split must be an Integer" unless long_word_split.class == Fixnum || long_word_split.nil?
    end

    def tokenize
      return [] unless text
      tokens = []
      text.scan(/.{,10000}(?=\s|\z)/m).each do |segment|
        tokens << post_process(PreProcessor.new(language: language_module).pre_process(text: segment))
      end
      tokens.flatten
    end

    private

    def post_process(text)
      @tokens = PostProcessor.new(text: text, abbreviations: abbreviations).post_process
      downcase! if downcase
      expand_contractions!(contractions) if expand_contractions
      clean! if clean
      classic_filter! if classic_filter
      process_numbers!
      remove_short_tokens! if minimum_length > 0
      process_punctuation!
      remove_stop_words!(stop_words) if remove_stop_words
      remove_emoji! if remove_emoji
      remove_emails! if remove_emails
      mentions! if mentions
      hashtags! if hashtags
      remove_urls! if remove_urls
      remove_domains! if remove_domains
      split_long_words! if long_word_split
      @tokens.reject { |t| t.empty? }
    end

    def downcase!
      @tokens.map! { |t| Unicode.downcase(t) }
    end

    def expand_contractions!(contractions)
      @tokens = if downcase
        @tokens.flat_map { |t| contractions.has_key?(Unicode.downcase(t.gsub(/[‘’‚‛‹›＇´`]/, "'"))) ? contractions[Unicode.downcase(t.gsub(/[‘’‚‛‹›＇´`]/, "'"))].split(' ').flatten : t }
      else
        @tokens.flat_map { |t| contractions.has_key?(Unicode.downcase(t.gsub(/[‘’‚‛‹›＇´`]/, "'"))) ? contractions[Unicode.downcase(t.gsub(/[‘’‚‛‹›＇´`]/, "'"))].split(' ').each_with_index.map { |t, i| i.eql?(0) ? Unicode.capitalize(t) : t }.flatten : t }
      end
    end

    def clean!
      @tokens = @tokens.flat_map { |t| (t !~ /[＠@#|＃]/ && t =~ /(?<=\s)\_+/) ? t.gsub!(/(?<=\s)\_+/, ' \1').split(' ').flatten : t }
        .flat_map { |t| (t !~ /[＠@#|＃]/ && t =~ /\_+(?=\s)/) ? t.gsub!(/\_+(?=\s)/, ' \1').split(' ').flatten : t }
        .flat_map { |t| (t !~ /[＠@#|＃]/ && t =~ /(?<=\A)\_+/) ? t.gsub!(/(?<=\A)\_+/, '\1 ').split(' ').flatten : t }
        .flat_map { |t| (t !~ /[＠@#|＃]/ && t =~ /\_+(?=\z)/) ? t.gsub!(/\_+(?=\z)/, ' \1').split(' ').flatten : t }
        .flat_map { |t| (t !~ /[＠@#|＃]/ && t =~ /\*+/) ? t.gsub!(/\*+/, '\1 ').split(' ').flatten : t }
        .map { |t| t.gsub(/[[:cntrl:]]/, '') }
        .map { |t| t.gsub(/(?<=\A)\:(?=.+)/, '') }
        .map { |t| t.gsub(/\:(?=\z)/, '') }
        .map { |t| t.gsub(/(?<=\A)!+(?=.+)/, '') }
        .map { |t| t !~ /[＠@#|＃]/ ? t.gsub(/(?<=\D)1+(?=\z)/, '') : t }
        .map { |t| t.gsub(/!+(?=\z)/, '') }
        .map { |t| t.gsub(/!+(1*!*)*(?=\z)/, '') }
        .map { |t| t.gsub(/\u{00AD}/, '') }
        .map { |t| t.gsub(/\A(-|–)/, '') }
        .map { |t| t.gsub(/[®©]/, '') }
        .map { |t| t.gsub(/[\u{1F100}-\u{1F1FF}]/, '') }
        .delete_if do |t| t =~ /\A-+\z/ ||
        PragmaticTokenizer::Languages::Common::SPECIAL_CHARACTERS.include?(t) ||
        t =~ /\A\.{2,}\z/ || t.include?("\\") ||
        t.length > 50 ||
        (t.length > 1 && t =~ /[&*+<=>^|~]/i) ||
        (t.length == 1 && t =~ /\:/)
      end
    end

    def classic_filter!
      @tokens.map! { |t| abbreviations.include?(t.chomp(".")) ? t.delete('.').chomp("'s").chomp("’s").chomp("`s").chomp("́s") : t.chomp("'s").chomp("’s").chomp("`s").chomp("́s") }
    end

    def process_numbers!
      case numbers.to_s
      when 'semi'
        @tokens.delete_if { |t| t =~ /\A\d+\z/ }
      when 'none'
        @tokens.delete_if { |t| t =~ /\D*\d+\d*/ || PragmaticTokenizer::Languages::Common::ROMAN_NUMERALS.include?(Unicode.downcase(t)) || PragmaticTokenizer::Languages::Common::ROMAN_NUMERALS.include?("#{Unicode.downcase(t)}.") }
      when 'only'
        @tokens.delete_if { |t| t =~ /\A\D+\z/ }
      end
    end

    def remove_short_tokens!
      @tokens.delete_if { |t| t.length < minimum_length }
    end

    def process_punctuation!
      case punctuation.to_s
      when 'semi'
        @tokens = @tokens - PragmaticTokenizer::Languages::Common::SEMI_PUNCTUATION
      when 'none'
        @tokens =  @tokens.delete_if { |t| t =~ /\A[[:punct:]]+\z/ || t =~ /\A(‹+|\^+|›+|\++)\z/ } - PragmaticTokenizer::Languages::Common::PUNCTUATION
      when 'only'
        @tokens.delete_if { |t| !PragmaticTokenizer::Languages::Common::PUNCTUATION.include?(t) }
      end
    end

    def remove_stop_words!(stop_words)
      if downcase
        @tokens = @tokens - stop_words
      else
        @tokens.delete_if { |t| stop_words.include?(Unicode.downcase(t)) }
      end
    end

    def remove_emoji!
      @tokens.delete_if do |t| t =~ PragmaticTokenizer::Languages::Common::EMOJI_REGEX ||
        t =~ /\u{2744}\u{FE0F}/ ||
        t =~ /\u{2744}\u{FE0E}/ ||
        t =~ /\u{2744}/
      end
    end

    def remove_emails!
      @tokens.delete_if { |t| t =~ /\S+(＠|@)\S+\.\S+/ }.map { |t| t.chomp('.') }
    end

    def mentions!
      case mentions.to_s
      when 'remove'
        @tokens.delete_if { |t| t =~ /\A(@|＠)/ }
      when 'keep_and_clean'
        @tokens.map! { |t| t =~ /\A(@|＠)/ ? t.gsub!(/(?<=\A)(@|＠)/, '') : t }
      end
    end

    def hashtags!
      case hashtags.to_s
      when 'remove'
        @tokens.delete_if { |t| t =~ /\A(#|＃)/ }
      when 'keep_and_clean'
        @tokens = @tokens.flat_map { |t| t =~ /\A(#|＃)\S+-/ ? t.gsub(/\-/, '\1 \2').split(' ').flatten : t }
        @tokens.map! { |t| t =~ /\A(#|＃)/ ? t.gsub!(/(?<=\A)(#|＃)/, '') : t }
      end
    end

    def remove_urls!
      @tokens.delete_if { |t| t =~ /(http|https)(\.|:)/ }
    end

    def remove_domains!
      @tokens.delete_if { |t| t =~ /(\s+|\A)[a-z0-9]{2,}([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,6}(:[0-9]{1,5})?(\/.*)?/ix }
    end

    def split_long_words!
      @tokens.map! { |t| t.length > long_word_split ? t.gsub(/\-/, '\1 \2').split(' ').flatten : t }
        .map! { |t| t.length > long_word_split ? t.gsub(/\_/, '\1 \2').split(' ').flatten : t }
    end
  end
end
