# -*- encoding : utf-8 -*-

module PragmaticTokenizer
  # This class separates true full stops while ignoring
  # periods that are part of an abbreviation
  class FullStopSeparator

    REGEXP_ENDS_WITH_DOT   = /\A(.*\w)\.\z/
    REGEXP_ONLY_LETTERS    = /\A[a-z]\z/i
    REGEXP_ABBREVIATION    = /[a-z](?:\.[a-z])+\z/i
    DOT                    = '.'.freeze

    def initialize(tokens:, abbreviations:, downcase:)
      @tokens        = tokens
      @abbreviations = abbreviations
      @downcase      = downcase
    end

    def separate
      @cleaned_tokens = create_cleaned_tokens
      replace_last_token unless @cleaned_tokens.empty?
      @cleaned_tokens
    end

    private

      def create_cleaned_tokens
        @tokens[0..-2]
            .flat_map { |token| abbreviation?(token) ? [token[0..-2], DOT] : token }
            .push(@tokens.last)
      end

      def abbreviation?(token)
        return false unless token.end_with?(DOT) && token.length > 1
        shortened = token.chomp(DOT)
        !defined_abbreviation?(shortened) && shortened !~ REGEXP_ONLY_LETTERS && shortened !~ REGEXP_ABBREVIATION
      end

      def defined_abbreviation?(token)
        @abbreviations.include?(inverse_case(token))
      end

      def inverse_case(token)
        @downcase ? token : Unicode.downcase(token)
      end

      def replace_last_token
        last_token = @cleaned_tokens[-1]
        return unless last_token.end_with?(DOT) && last_token.length > 1
        shortened = last_token.chomp(DOT)
        return if defined_abbreviation?(shortened) || last_token !~ REGEXP_ENDS_WITH_DOT
        @cleaned_tokens[-1] = Regexp.last_match(1)
        @cleaned_tokens << DOT
      end

  end

end
