module PragmaticTokenizer
  class PostProcessor

    REGEX_SYMBOL         = /[♳ ♴ ♵ ♶ ♷ ♸ ♹ ♺ ⚀ ⚁ ⚂ ⚃ ⚄ ⚅ ☇ ☈ ☉ ☊ ☋ ☌ ☍ ☠ ☢ ☣ ☤ ☥ ☦ ☧ ☀ ☁ ☂ ☃ ☄ ☮ ♔ ♕ ♖ ♗ ♘ ♙ ♚ ⚘ ⚭]/
    REGEXP_COMMAS        = /^(,|‚)+/
    REGEXP_SINGLE_QUOTES = /(.+)(’|'|‘|`)$/
    REGEXP_SLASH         = /^(?!(https?:|www\.))(.*)\/(.*)/
    REGEXP_QUESTION_MARK = /^(?!(https?:|www\.))(.*)(\?)(.*)/
    REGEXP_PLUS_SIGN     = /(.+)\+(.+)/
    REGEXP_COLON         = /^(\:)(\S{2,})/
    REGEXP_EMOJI         = /(\u{2744}[\u{FE0E}|\u{FE0F}])/

    REGEX_UNIFIED1       = Regexp.union(REGEXP_SLASH,
                                        REGEXP_QUESTION_MARK,
                                        REGEXP_PLUS_SIGN,
                                        REGEXP_COLON,
                                        REGEXP_EMOJI,
                                        PragmaticTokenizer::Languages::Common::PREFIX_EMOJI_REGEX,
                                        PragmaticTokenizer::Languages::Common::POSTFIX_EMOJI_REGEX)

    REGEX_UNIFIED2       = Regexp.union(REGEXP_SINGLE_QUOTES,
                                        REGEXP_COMMAS)

    attr_reader :text, :abbreviations, :downcase

    def initialize(text:, abbreviations:, downcase:)
      @text          = text
      @abbreviations = abbreviations
      @downcase      = downcase
    end

    def post_process
      EndingPunctuationSeparator.new(tokens: method_name3).separate
    end

    private

      def method_name3
        separated = EndingPunctuationSeparator.new(tokens: full_stop_separated_tokens).separate
        procs     = [unified1, split_unknown_period1, split_unknown_period2, split_emoji]
        procs.reduce(separated) { |a, e| a.flat_map(&e) }
      end

      def unified1
        proc { |token| token.split(REGEX_UNIFIED1) }
      end

      def full_stop_separated_tokens
        FullStopSeparator.new(tokens: split_and_convert_commas_and_quotes, abbreviations: abbreviations, downcase: downcase).separate
      end

      def split_and_convert_commas_and_quotes
        text
            .split
            .flat_map { |token| token.split(REGEX_UNIFIED2) }
            .flat_map { |token| convert_sym_to_punct(token) }
      end

      def split_emoji
        proc { |token| (token =~ /(\A|\S)\u{2744}[^\u{FE0E}|\u{FE0F}]/) ? token.split(/(\u{2744})/) : token }
      end

      def split_unknown_period1
        proc { |token| unknown_period1?(token) ? token.split(/(.*\.)/) : token }
      end

      def split_unknown_period2
        proc { |token| unknown_period2?(token) ? token.split(/(\.)/) : token }
      end

      def unknown_period1?(token)
        token.include?(".") &&
            token !~ /(http|https|www)(\.|:)/ &&
            token.length > 1 &&
            token !~ /(\s+|\A)[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,6}(:[0-9]{1,5})?(\/.*)?/ix &&
            token !~ /\S+(＠|@)\S+/ &&
            abbreviations.include?(extract_abbreviation(token))
      end

      def unknown_period2?(token)
        token.include?(".") &&
            token !~ /(http|https|www)(\.|:)/ &&
            token !~ /\.(com|net|org|edu|gov|mil|int)/ &&
            token !~ /\.[a-zA-Z]{2}(\s|\z)/ &&
            token.length > 2 &&
            token !~ /\A[a-zA-Z]{1}\./ &&
            token.count(".") == 1 &&
            token !~ /\d+/ &&
            !abbreviations.include?(extract_abbreviation(token)) &&
            token !~ /\S+(＠|@)\S+/
      end

      def extract_abbreviation(token)
        if downcase
          token.split(/(\.)/)[0]
        else
          UnicodeCaseConverter::downcase(token.split(/(\.)/)[0])
        end
      end

      def convert_sym_to_punct(token)
        symbol_matches = REGEX_SYMBOL.match(token)
        if symbol_matches.nil?
          token
        else
          pattern     = symbol_matches[0]
          replacement = PragmaticTokenizer::Languages::Common::PUNCTUATION_MAP.key(pattern)
          token.gsub!(pattern, replacement)
        end
      end

  end
end
