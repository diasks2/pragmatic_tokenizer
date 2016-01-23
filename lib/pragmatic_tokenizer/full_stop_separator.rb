# -*- encoding : utf-8 -*-

module PragmaticTokenizer
  # This class separates true full stops while ignoring
  # periods that are part of an abbreviation
  class FullStopSeparator
    attr_reader :tokens, :abbreviations
    def initialize(tokens:, abbreviations:)
      @tokens = tokens
      @abbreviations = abbreviations
    end

    def separate
      abbr = {}
      abbreviations.each do |i|
        abbr[i] = true
      end
      cleaned_tokens = []
      tokens.each_with_index do |_t, i|
        if tokens[i + 1] && tokens[i] =~ /\A(.+)\.\z/
          w = $1
          unless abbr[Unicode.downcase(w)] || w =~ /\A[a-z]\z/i ||
            w =~ /[a-z](?:\.[a-z])+\z/i
            cleaned_tokens << w
            cleaned_tokens << '.'
            next
          end
        end
        cleaned_tokens << tokens[i]
      end
      if cleaned_tokens[-1] && cleaned_tokens[-1] =~ /\A(.*\w)\.\z/ && !abbreviations.include?(Unicode.downcase(cleaned_tokens[-1]).chomp("."))
        cleaned_tokens[-1] = $1
        cleaned_tokens.push '.'
      end
      cleaned_tokens
    end
  end
end
