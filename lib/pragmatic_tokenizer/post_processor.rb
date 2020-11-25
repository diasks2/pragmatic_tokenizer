module PragmaticTokenizer
  class PostProcessor

    DOT = '.'.freeze

    attr_reader :text, :abbreviations, :downcase

    def initialize(text:, abbreviations:, downcase:)
      @text            = text
      @abbreviations   = abbreviations
      @downcase        = downcase
    end

    # Every #flat_map will increase memory usage, we should try to merge whatever can be merged
    # We need to run #split(Regex::ENDS_WITH_PUNCTUATION2) before AND after #split(Regex::VARIOUS), can this be fixed?
    def call
      text
          .split
          .map      { |token| convert_sym_to_punct(token) }
          .flat_map { |token| !token.include?("://") && @downcase ? Unicode.downcase(token) : token }
          .flat_map { |token| token.split(Regex::COMMAS_OR_PUNCTUATION) }
          .flat_map { |token| token.split(Regex::VARIOUS) }
          .flat_map { |token| token.split(Regex::ENDS_WITH_PUNCTUATION2) }
          .flat_map { |token| split_dotted_email_or_digit(token) }
          .flat_map { |token| split_abbreviations(token) }
          .flat_map { |token| split_period_after_last_word(token) }
    end

    private

      def convert_sym_to_punct(token)
        PragmaticTokenizer::Languages::Common::PUNCTUATION_MAP
            .each { |pattern, replacement| break if token.sub!(replacement, pattern) }
        token
      end

      # Per specs, "16.1. day one,17.2. day two" will result in ["16.1", ".",…]. Do we really want that?
      def split_dotted_email_or_digit(token)
        return token unless token.end_with?(DOT) && token.length > 1
        shortened = token.chomp(DOT)
        return [shortened, DOT] if shortened =~ Regex::DOMAIN_OR_EMAIL
        return [shortened, DOT] if shortened =~ Regex::ENDS_WITH_DIGIT
        token
      end

      def split_abbreviations(token)
        return token unless token.include?(DOT) && token.length > 1
        return token if token =~ Regex::DOMAIN_OR_EMAIL
        abbreviation = extract_abbreviation(token)
        return token.split(Regex::PERIOD_AND_PRIOR) if abbreviations.include?(abbreviation)
        token
      end

      def split_period_after_last_word(token)
        return token unless token.include?(DOT) && token.length > 1
        return token if token.count(DOT) > 1
        return token if token =~ Regex::ONLY_DOMAIN3
        return token if token =~ Regex::DIGIT
        abbreviation = extract_abbreviation(token)
        return token.split(Regex::PERIOD_ONLY) unless abbreviations.include?(abbreviation)
        token
      end

      def extract_abbreviation(token)
        before_first_dot = token[0, token.index(DOT)]
        downcase ? before_first_dot : Unicode.downcase(before_first_dot)
      end

  end
end
