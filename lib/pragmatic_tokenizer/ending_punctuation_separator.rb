# -*- encoding : utf-8 -*-

module PragmaticTokenizer
  # This class separates ending punctuation from a token
  class EndingPunctuationSeparator
    attr_reader :tokens
    def initialize(tokens:)
      @tokens = tokens
    end

    def separate
      cleaned_tokens = []
      tokens.each do |a|
        split_punctuation = a.scan(/(?<=\S)[。．！!?？]+$/)
        if split_punctuation[0].nil?
          cleaned_tokens << a
        else
          cleaned_tokens << a.tr(split_punctuation[0], '')
          if split_punctuation[0].length.eql?(1)
            cleaned_tokens << split_punctuation[0]
          else
            split_punctuation[0].split("").each do |s|
              cleaned_tokens << s
            end
          end
        end
      end
      cleaned_tokens
    end
  end
end