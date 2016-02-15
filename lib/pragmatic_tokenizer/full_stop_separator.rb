# -*- encoding : utf-8 -*-

module PragmaticTokenizer
  # This class separates true full stops while ignoring
  # periods that are part of an abbreviation
  class FullStopSeparator
    attr_reader :tokens, :abbreviations, :downcase
    def initialize(tokens:, abbreviations:, downcase:)
      @tokens = tokens
      @abbreviations = abbreviations
      @downcase = downcase
    end

    def separate
      abbr = {}
      abbreviations.each do |i|
        abbr[i] = true
      end
      cleaned_tokens = []
      tokens.each_with_index do |_t, i|
        if tokens[i + 1] && tokens[i] =~ /\A(.+)\.\z/
          w = Regexp.last_match(1)
          if downcase
            abbreviation = abbr[w]
          else
            abbreviation = abbr[UnicodeCaseConverter::downcase(w)]
          end
          unless abbreviation || w =~ /\A[a-z]\z/i ||
                 w =~ /[a-z](?:\.[a-z])+\z/i
            cleaned_tokens << w
            cleaned_tokens << '.'
            next
          end
        end
        cleaned_tokens << tokens[i]
      end
      if downcase
        abbr_included = abbreviations.include?(cleaned_tokens[-1].chomp(".")) unless cleaned_tokens[-1].nil?
      else
        abbr_included = abbreviations.include?(UnicodeCaseConverter::downcase(cleaned_tokens[-1]).chomp(".")) unless cleaned_tokens[-1].nil?
      end
      if cleaned_tokens[-1] && cleaned_tokens[-1] =~ /\A(.*\w)\.\z/ && !abbr_included
        cleaned_tokens[-1] = Regexp.last_match(1)
        cleaned_tokens.push '.'
      end
      cleaned_tokens
    end
  end
end
