# -*- encoding : utf-8 -*-
require 'pragmatic_tokenizer/languages'
require 'unicode'

module PragmaticTokenizer
  class Tokenizer

    attr_reader :text, :language, :punctuation, :remove_stop_words, :expand_contractions, :language_module, :clean, :remove_numbers, :minimum_length, :remove_roman_numerals, :downcase, :remove_en_stop_words, :classic_filter
    def initialize(text, language: 'en', punctuation: 'all', remove_stop_words: false, expand_contractions: false, clean: false, remove_numbers: false, minimum_length: 0, remove_roman_numerals: false, downcase: true, remove_en_stop_words: false, classic_filter: false)
      unless punctuation.to_s.eql?('all') ||
        punctuation.to_s.eql?('semi') ||
        punctuation.to_s.eql?('none') ||
        punctuation.to_s.eql?('only')
        raise "Punctuation argument can be only be nil, 'all', 'semi', 'none', or 'only'"
        # Punctuation 'all': Does not remove any punctuation from the result

        # Punctuation 'semi': Removes common punctuation (such as full stops)
        # and does not remove less common punctuation (such as questions marks)
        # This is useful for text alignment as less common punctuation can help
        # identify a sentence (like a fingerprint) while common punctuation
        # (like stop words) should be removed.

        # Punctuation 'none': Removes all punctuation from the result

        # Punctuation 'only': Removes everything except punctuation. The
        # returned result is an array of only the punctuation.
      end
      raise "In Pragmatic Tokenizer text must be a String" unless text.class == String
      @text = CGI.unescapeHTML(text)
      @language = language.to_s
      @language_module = Languages.get_language_by_code(language.to_s)
      @punctuation = punctuation.to_s
      @remove_stop_words = remove_stop_words
      @expand_contractions = expand_contractions
      @clean = clean
      @remove_numbers = remove_numbers
      @minimum_length = minimum_length
      @remove_roman_numerals = remove_roman_numerals
      @downcase = downcase
      @remove_en_stop_words = remove_en_stop_words
      @classic_filter = classic_filter
    end

    def tokenize
      return [] unless text
      tokens = []
      text.scan(/.{,10000}(?=\s|\z)/m).each do |segment|
        tokens << run_classic_filter(
          delete_en_stop_words(
          delete_stop_words(
          downcase_tokens(
          cleaner(
          remove_short_tokens(
          delete_numbers(
          delete_roman_numerals(
          find_contractions(
          remove_punctuation(
          split_at_middle_period_1(
          split_at_middle_period_2(
          split_beginning_period(
          split_at_plus_sign(
          shift_no_spaces_between_sentences(
          split_at_forward_slash(
            processor.new(language: language_module).process(text: segment)
          )))))))))))))))).reject { |t| t.empty? }
      end
      tokens.flatten
    end

    def domains
      text.split(' ').delete_if { |t| t !~ /(\s+|\A)[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,6}(:[0-9]{1,5})?(\/.*)?/ix }.map { |t| t.chomp('.').chomp(',').chomp(';').chomp(':') }
    end

    def urls
      text.split(' ').delete_if { |t| t !~ /(http|https|www)(\.|:)/ }.map { |t| t.chomp('.') }
    end

    def emails
      text.split(' ').delete_if { |t| t !~ /\S+(＠|@)\S+/ }.map { |t| t.chomp('.') }
    end

    def hashtags
      text.split(' ').delete_if { |t| t !~ /(#|＃)/ }.map { |t| t.chomp('.') }
    end

    def mentions
      text.split(' ').delete_if { |t| t !~ /(@|＠)/ }.map { |t| t.chomp('.') }
    end

    def emoticons
      text.scan(/(?::|;|=)(?:-)?(?:\)|D|P)/)
    end

    def emoji
      # https://github.com/franklsf95/ruby-emoji-regex
      text.scan(/[\u{203C}\u{2049}\u{20E3}\u{2122}\u{2139}\u{2194}-\u{2199}\u{21A9}-\u{21AA}\u{231A}-\u{231B}\u{23E9}-\u{23EC}\u{23F0}\u{23F3}\u{24C2}\u{25AA}-\u{25AB}\u{25B6}\u{25C0}\u{25FB}-\u{25FE}\u{2600}-\u{2601}\u{260E}\u{2611}\u{2614}-\u{2615}\u{261D}\u{263A}\u{2648}-\u{2653}\u{2660}\u{2663}\u{2665}-\u{2666}\u{2668}\u{267B}\u{267F}\u{2693}\u{26A0}-\u{26A1}\u{26AA}-\u{26AB}\u{26BD}-\u{26BE}\u{26C4}-\u{26C5}\u{26CE}\u{26D4}\u{26EA}\u{26F2}-\u{26F3}\u{26F5}\u{26FA}\u{26FD}\u{2702}\u{2705}\u{2708}-\u{270C}\u{270F}\u{2712}\u{2714}\u{2716}\u{2728}\u{2733}-\u{2734}\u{2744}\u{2747}\u{274C}\u{274E}\u{2753}-\u{2755}\u{2757}\u{2764}\u{2795}-\u{2797}\u{27A1}\u{27B0}\u{2934}-\u{2935}\u{2B05}-\u{2B07}\u{2B1B}-\u{2B1C}\u{2B50}\u{2B55}\u{3030}\u{303D}\u{3297}\u{3299}\u{1F004}\u{1F0CF}\u{1F170}-\u{1F171}\u{1F17E}-\u{1F17F}\u{1F18E}\u{1F191}-\u{1F19A}\u{1F1E7}-\u{1F1EC}\u{1F1EE}-\u{1F1F0}\u{1F1F3}\u{1F1F5}\u{1F1F7}-\u{1F1FA}\u{1F201}-\u{1F202}\u{1F21A}\u{1F22F}\u{1F232}-\u{1F23A}\u{1F250}-\u{1F251}\u{1F300}-\u{1F320}\u{1F330}-\u{1F335}\u{1F337}-\u{1F37C}\u{1F380}-\u{1F393}\u{1F3A0}-\u{1F3C4}\u{1F3C6}-\u{1F3CA}\u{1F3E0}-\u{1F3F0}\u{1F400}-\u{1F43E}\u{1F440}\u{1F442}-\u{1F4F7}\u{1F4F9}-\u{1F4FC}\u{1F500}-\u{1F507}\u{1F509}-\u{1F53D}\u{1F550}-\u{1F567}\u{1F5FB}-\u{1F640}\u{1F645}-\u{1F64F}\u{1F680}-\u{1F68A}]/)
    end

    private

    def processor
      language_module::Processor
    rescue
      Processor
    end

    def run_classic_filter(tokens)
      return tokens unless classic_filter
      tokens.map { |t| t.gsub('.', '').chomp("'s").chomp("’s").chomp("`s") }
    end

    def split_at_middle_period_1(tokens)
      tokens.flat_map { |t| t.include?(".") &&
        t !~ /(http|https|www)(\.|:)/ &&
        t.length > 1 &&
        t !~ /(\s+|\A)[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,6}(:[0-9]{1,5})?(\/.*)?/ix &&
        t !~ /\S+(＠|@)\S+/ &&
        language_module::ABBREVIATIONS.include?(Unicode::downcase(t.split(".")[0] == nil ? '' : t.split(".")[0])) ? t.gsub!(/\./, '\1. \2').split(' ').flatten : t }
    end

    def split_at_middle_period_2(tokens)
      tokens.flat_map { |t| t.include?(".") &&
        t !~ /(http|https|www)(\.|:)/ &&
        t !~ /\.(com|net|org|edu|gov|mil|int)/ &&
        t !~ /\.[a-z]{2}/ &&
        t.length > 2 &&
        t.count(".") == 1 &&
        t !~ /\d+/ &&
        !language_module::ABBREVIATIONS.include?(Unicode::downcase(t.split(".")[0] == nil ? '' : t.split(".")[0])) &&
        t !~ /\S+(＠|@)\S+/ ? t.gsub!(/\./, '\1 . \2').split(' ').flatten : t }
    end

    def split_beginning_period(tokens)
      tokens.flat_map { |t| t =~ /\A\.[^\.]/ && t.length > 1 ? t.gsub!(/\./, '\1 ').split(' ').flatten : t }
    end

    def shift_no_spaces_between_sentences(tokens)
      tokens.flat_map { |t| t.include?("?") && t !~ /(http|https|www)(\.|:)/ && t.length > 1 ? t.gsub!(/\?/, '\1 \2').split(' ').flatten : t }
    end

    def downcase_tokens(tokens)
      return tokens unless downcase
      tokens.map { |t| Unicode::downcase(t) }
    end

    def remove_short_tokens(tokens)
      tokens.delete_if { |t| t.length < minimum_length }
    end

    def delete_numbers(tokens)
      return tokens unless remove_numbers
      tokens.delete_if { |t| t =~ /\D*\d+\d*/ }
    end

    def delete_roman_numerals(tokens)
      return tokens unless remove_roman_numerals
      tokens.delete_if { |t| PragmaticTokenizer::Languages::Common::ROMAN_NUMERALS.include?(Unicode::downcase(t)) || PragmaticTokenizer::Languages::Common::ROMAN_NUMERALS.include?("#{Unicode::downcase(t)}.") } if remove_roman_numerals
    end

    def cleaner(tokens)
      return tokens unless clean
      tokens.flat_map { |t| t =~ /(\A|\s)\@/ ? t.gsub!(/\@/, '\1 ').split(' ').flatten : t }
        .flat_map { |t| t =~ /(?<=\s)\_+/ ? t.gsub!(/(?<=\s)\_+/, ' \1').split(' ').flatten : t }
        .flat_map { |t| t =~ /\_+(?=\s)/ ? t.gsub!(/\_+(?=\s)/, ' \1').split(' ').flatten : t }
        .flat_map { |t| t =~ /(?<=\A)\_+/ ? t.gsub!(/(?<=\A)\_+/, '\1 ').split(' ').flatten : t }
        .flat_map { |t| t =~ /\_+(?=\z)/ ? t.gsub!(/\_+(?=\z)/, ' \1').split(' ').flatten : t }
        .flat_map { |t| t =~ /\*+/ ? t.gsub!(/\*+/, '\1 ').split(' ').flatten : t }
        .map { |t| t.gsub(/[[:cntrl:]]/, '') }
        .delete_if { |t| t =~ /\A-+\z/ ||
        PragmaticTokenizer::Languages::Common::SPECIAL_CHARACTERS.include?(t) ||
        t =~ /\A\.{2,}\z/ || t.include?("\\") ||
        t.length > 50 ||
        (t.length > 1 && t =~ /[#&*+<=>@^|~]/i)
      }
    end

    def remove_punctuation(tokens)
      case punctuation
      when 'all'
        tokens
      when 'semi'
        tokens - PragmaticTokenizer::Languages::Common::SEMI_PUNCTUATION
      when 'none'
        tokens.delete_if { |t| t =~ /\A[[:punct:]]+\z/ || t =~ /\A(‹+|\^+|›+|\++)\z/ } - PragmaticTokenizer::Languages::Common::PUNCTUATION
      when 'only'
        only_punctuation(tokens)
      end
    end

    def only_punctuation(tokens)
      tokens.delete_if { |t| !PragmaticTokenizer::Languages::Common::PUNCTUATION.include?(t) }
    end

    def delete_stop_words(tokens)
      return tokens unless remove_stop_words && language_module::STOP_WORDS
      if downcase
        tokens.map { |t| Unicode::downcase(t) } - language_module::STOP_WORDS
      else
        tokens.delete_if { |t| language_module::STOP_WORDS.include?(Unicode::downcase(t)) }
      end
    end

    def delete_en_stop_words(tokens)
      return tokens unless remove_en_stop_words
      if downcase
        tokens.map { |t| Unicode::downcase(t) } - PragmaticTokenizer::Languages::English::STOP_WORDS
      else
        tokens.delete_if { |t| PragmaticTokenizer::Languages::English::STOP_WORDS.include?(Unicode::downcase(t)) }
      end
    end

    def split_at_forward_slash(tokens)
      tokens.flat_map { |t| t.include?("/") && t !~ /(http|https|www)(\.|:)/ ? t.gsub!(/\//, '\1 \2').split(' ').flatten : t }
    end

    def split_at_plus_sign(tokens)
      tokens.flat_map { |t| t.include?("+") ? t.gsub!(/\+/, '\1 \2').split(' ').flatten : t }
    end

    def find_contractions(tokens)
      return tokens unless expand_contractions && language_module::CONTRACTIONS
      if downcase
        tokens.flat_map { |t| language_module::CONTRACTIONS.has_key?(Unicode::downcase(t.gsub(/[‘’‚‛‹›＇´`]/, "'"))) ? language_module::CONTRACTIONS[Unicode::downcase(t.gsub(/[‘’‚‛‹›＇´`]/, "'"))].split(' ').flatten : t }
      else
        tokens.flat_map { |t| language_module::CONTRACTIONS.has_key?(Unicode::downcase(t.gsub(/[‘’‚‛‹›＇´`]/, "'"))) ? language_module::CONTRACTIONS[Unicode::downcase(t.gsub(/[‘’‚‛‹›＇´`]/, "'"))].split(' ').each_with_index.map { |t, i| i.eql?(0) ? Unicode::capitalize(t) : t }.flatten : t }
      end
    end
  end
end