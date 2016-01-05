# -*- encoding : utf-8 -*-
require 'pragmatic_tokenizer/languages'

module PragmaticTokenizer
  class Tokenizer

    attr_reader :text, :language, :punctuation, :remove_stop_words
    def initialize(text, language: 'en', punctuation: 'all', remove_stop_words: false)
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
    end

    def tokenize
      text.split.map { |t| t.downcase }
    end
  end
end