module PragmaticTokenizer
  class PostProcessor

    REGEX_SYMBOL         = /[♳ ♴ ♵ ♶ ♷ ♸ ♹ ♺ ⚀ ⚁ ⚂ ⚃ ⚄ ⚅ ☇ ☈ ☉ ☊ ☋ ☌ ☍ ☠ ☢ ☣ ☤ ☥ ☦ ☧ ☀ ☁ ☂ ☃ ☄ ☮ ♔ ♕ ♖ ♗ ♘ ♙ ♚ ⚘ ⚭]/.freeze
    REGEXP_COMMAS        = /^(,|‚)+/.freeze
    REGEXP_SINGLE_QUOTES = /(.+)(’|'|‘|`)$/.freeze
    REGEXP_SLASH         = /^(?!(https?:|www\.))(.*)\/(.*)/.freeze
    REGEXP_QUESTION_MARK = /^(?!(https?:|www\.))(.*)(\?)(.*)/.freeze
    REGEXP_PLUS_SIGN     = /(.+)\+(.+)/.freeze
    REGEXP_UNKNOWN7      = /^(\.{1,})/.freeze
    REGEXP_UNKNOWN8      = /^(\:)(\S{2,})/.freeze
    REGEXP_UNKNOWN11     = /(\u{2744}[\u{FE0E}|\u{FE0F}])/.freeze

    REGEX_UNIFIED1       = Regexp.union(REGEXP_SLASH,
                                        REGEXP_QUESTION_MARK,
                                        REGEXP_PLUS_SIGN,
                                        REGEXP_UNKNOWN7,
                                        REGEXP_UNKNOWN8,
                                        REGEXP_UNKNOWN11,
                                        PragmaticTokenizer::Languages::Common::PREFIX_EMOJI_REGEX,
                                        PragmaticTokenizer::Languages::Common::POSTFIX_EMOJI_REGEX
    ).freeze

    REGEX_UNIFIED2       = Regexp.union(REGEXP_SINGLE_QUOTES,
                                        REGEXP_COMMAS
    ).freeze

    attr_reader :text, :abbreviations

    def initialize(text:, abbreviations:)
      @text          = text
      @abbreviations = abbreviations
    end

    def post_process
      EndingPunctuationSeparator.new(tokens: method_name3).separate
    end

    private

      def method_name3
        separated = EndingPunctuationSeparator.new(tokens: full_stop_separated_tokens).separate
        procs     = [unified1, method_name9, method_name10, method_name13]
        procs.reduce(separated) { |a, e| a.flat_map(&e) }
      end

      def unified1
        proc { |token| token.split(REGEX_UNIFIED1) }
      end

      def full_stop_separated_tokens
        FullStopSeparator.new(tokens: method_name16, abbreviations: abbreviations).separate
      end

      def method_name16
        text
            .split
            .flat_map { |token| token.split(REGEX_UNIFIED2) }
            .flat_map { |token| convert_sym_to_punct(token) }
      end

      def method_name13
        proc { |token| (token =~ /(\A|\S)\u{2744}[^\u{FE0E}|\u{FE0F}]/) ? token.split(/(\u{2744})/) : token }
      end

      def method_name10
        proc { |token| method_name19(token) ? token.split(/(.*\.)/) : token }
      end

      def method_name19(token)
        token.include?(".") &&
            token !~ /(http|https|www)(\.|:)/ &&
            token.length > 1 &&
            token !~ /(\s+|\A)[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,6}(:[0-9]{1,5})?(\/.*)?/ix &&
            token !~ /\S+(＠|@)\S+/ &&
            abbreviations.include?(method_name17(token))
      end

      def method_name9
        proc { |token| method_name18(token) ? token.split(/(\.)/) : token }
      end

      def method_name18(token)
        token.include?(".") &&
            token !~ /(http|https|www)(\.|:)/ &&
            token !~ /\.(com|net|org|edu|gov|mil|int)/ &&
            token !~ /\.[a-z]{2}/ &&
            token.length > 2 &&
            token !~ /\A[a-zA-Z]{1}\./ &&
            token.count(".") == 1 &&
            token !~ /\d+/ &&
            !abbreviations.include?(method_name17(token)) &&
            token !~ /\S+(＠|@)\S+/
      end

      def method_name17(token)
        abbreviation = token.split(/(\.)/)[0]
        Unicode.downcase(abbreviation)
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
