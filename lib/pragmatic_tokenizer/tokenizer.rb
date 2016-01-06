# -*- encoding : utf-8 -*-
require 'pragmatic_tokenizer/languages'

module PragmaticTokenizer
  class Tokenizer

    attr_reader :text, :language, :punctuation, :remove_stop_words, :expand_contractions, :language_module
    def initialize(text, language: 'en', punctuation: 'all', remove_stop_words: false, expand_contractions: false)
      unless punctuation.eql?('all') ||
        punctuation.eql?('semi') ||
        punctuation.eql?('none') ||
        punctuation.eql?('only')
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
      @text = text
      @language = language
      @language_module = Languages.get_language_by_code(language)
      @punctuation = punctuation
      @remove_stop_words = remove_stop_words
      @expand_contractions = expand_contractions
    end

    def tokenize
      return [] unless text
      delete_stop_words(find_contractions(remove_punctuation(processor.new(language: language_module).process(text: text))))
    end

    private

    def processor
      language_module::Processor
    rescue
      Processor
    end

    def remove_punctuation(tokens)
      case punctuation
      when 'all'
        tokens
      when 'semi'
        tokens - PragmaticTokenizer::Languages::Common::SEMI_PUNCTUATION
      when 'none'
        tokens - PragmaticTokenizer::Languages::Common::PUNCTUATION
      when 'only'
        only_punctuation(tokens)
      end
    end

    def only_punctuation(tokens)
      tokens.delete_if do |t|
        t.squeeze!
        true unless PragmaticTokenizer::Languages::Common::PUNCTUATION.include?(t)
      end
    end

    def delete_stop_words(tokens)
      return tokens unless remove_stop_words && language_module::STOP_WORDS
      tokens - language_module::STOP_WORDS
    end

    def find_contractions(tokens)
      return tokens unless expand_contractions && language_module::CONTRACTIONS
      tokens.flat_map { |t| language_module::CONTRACTIONS.has_key?(t) ? language_module::CONTRACTIONS[t].split(' ').flatten : t }
    end
  end
end