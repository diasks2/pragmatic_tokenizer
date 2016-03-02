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
      create_cleaned_tokens
      replace_last_token unless @cleaned_tokens.empty?
      @cleaned_tokens
    end

    private

      def create_cleaned_tokens
        @cleaned_tokens = []
        @tokens.each_with_index do |token, position|
          if @tokens[position + 1] && token =~ REGEXP_ENDS_WITH_DOT
            match = Regexp.last_match(1)
            if abbreviation?(match)
              @cleaned_tokens += [match, DOT]
              next
            end
          end
          @cleaned_tokens << token
        end
      end

      def abbreviation?(token)
        !defined_abbreviation?(token) && token !~ REGEXP_ONLY_LETTERS && token !~ REGEXP_ABBREVIATION
      end

      def defined_abbreviation?(token)
        @abbreviations.include?(inverse_case(token))
      end

      def inverse_case(token)
        @downcase ? token : Unicode.downcase(token)
      end

      def replace_last_token
        last_token = @cleaned_tokens[-1]
        return if defined_abbreviation?(last_token.chomp(DOT)) || last_token !~ REGEXP_ENDS_WITH_DOT
        @cleaned_tokens[-1] = Regexp.last_match(1)
        @cleaned_tokens << DOT
      end

  end

end
