module PragmaticTokenizer
  class PostProcessor

    DOT                       = '.'.freeze
    RANGE_DINGBATS            = '[\u2701-\u27BE]'.freeze # e.g. ✁✎✳❄➾
    RANGE_VARIATION_SELECTORS = '[\uFE00-\uFE0F]'.freeze # alter the previous character
    RANGE_FULLWIDTH           = '[\uFF01-\ufF1F]'.freeze # e.g. ！＂＃＇？

    REGEXP_COMMAS        = /^([,‚])+/
    REGEXP_SINGLE_QUOTES = /(.+)([’'‘`])$/
    REGEXP_SLASH         = /^(?!(https?:|www\.))(.*)\//
    REGEXP_QUESTION_MARK = /^(?!(https?:|www\.))(.*)(\?)/
    REGEXP_PLUS_SIGN     = /(.+)\+(.+)/
    REGEXP_COLON         = /^(:)(\S{2,})/
    REGEXP_DINGBATS      = /(#{RANGE_DINGBATS}#{RANGE_VARIATION_SELECTORS}*)/
    REGEXP_ENDING_PUNCT  = /(?<=\S)([#{RANGE_FULLWIDTH}!?]+)$/
    REGEXP_DOMAIN        = /^((https?:\/\/|)?[a-z0-9]+([\-\.][a-z0-9]+)*\.[a-z]{2,6}(:[0-9]{1,5})?(\/.*)?)$/ix
    REGEXP_EMAIL         = /\S+[＠@]\S+/
    REGEXP_DOMAIN_START  = /^(https?:|www\.|[[:alpha:]]\.)/
    REGEXP_DOMAIN_END    = /\.(com|net|org|edu|gov|mil|int|[[:alpha:]]{2})$/
    REGEXP_DIGIT         = /[[:digit:]]+/
    REGEXP_PERIOD1       = /(.*\.)/
    REGEXP_PERIOD2       = /(\.)/

    REGEX_UNIFIED1       = Regexp.union(REGEXP_SLASH,
                                        REGEXP_QUESTION_MARK,
                                        REGEXP_PLUS_SIGN,
                                        REGEXP_COLON,
                                        REGEXP_DINGBATS,
                                        PragmaticTokenizer::Languages::Common::PREFIX_EMOJI_REGEX,
                                        PragmaticTokenizer::Languages::Common::POSTFIX_EMOJI_REGEX)

    REGEX_UNIFIED2       = Regexp.union(REGEXP_SINGLE_QUOTES,
                                        REGEXP_COMMAS)

    REGEX_DOMAIN_EMAIL   = Regexp.union(REGEXP_DOMAIN,
                                        REGEXP_EMAIL)

    REGEX_DOMAIN         = Regexp.union(REGEXP_DOMAIN_START,
                                        REGEXP_DOMAIN_END)

    attr_reader :text, :abbreviations, :downcase

    def initialize(text:, abbreviations:, downcase:)
      @text          = text
      @abbreviations = abbreviations
      @downcase      = downcase
    end

    def post_process
      procs.reduce(full_stop_separated_tokens) { |a, e| a.flat_map(&e) }
    end

    private

      # note: we need to run #separate_ending_punctuation twice. maybe there's a better solution?
      def procs
        [
            separate_ending_punctuation,
            unified1,
            split_unknown_period1,
            split_unknown_period2,
            separate_ending_punctuation
        ]
      end

      def separate_ending_punctuation
        proc { |token| token.split(REGEXP_ENDING_PUNCT) }
      end

      def unified1
        proc { |token| token.split(REGEX_UNIFIED1) }
      end

      def full_stop_separated_tokens
        FullStopSeparator.new(tokens: split_convert_commas_quotes, abbreviations: abbreviations, downcase: downcase).separate
      end

      def split_convert_commas_quotes
        text
            .split
            .flat_map { |token| token.split(REGEX_UNIFIED2) }
            .flat_map { |token| convert_sym_to_punct(token) }
      end

      def split_unknown_period1
        proc { |token| unknown_period1?(token) ? token.split(REGEXP_PERIOD1) : token }
      end

      def split_unknown_period2
        proc { |token| unknown_period2?(token) ? token.split(REGEXP_PERIOD2) : token }
      end

      def unknown_period1?(token)
        token.include?(DOT) &&
            token.length > 1 &&
            token !~ REGEX_DOMAIN_EMAIL &&
            abbreviations.include?(extract_abbreviation(token))
      end

      def unknown_period2?(token)
        token.include?(DOT) &&
            token !~ REGEX_DOMAIN &&
            token !~ REGEXP_DIGIT &&
            token.count(DOT) == 1 &&
            !abbreviations.include?(extract_abbreviation(token))
      end

      def extract_abbreviation(token)
        before_first_dot = token[0, token.index(DOT)]
        downcase ? before_first_dot : Unicode.downcase(before_first_dot)
      end

      def convert_sym_to_punct(token)
        PragmaticTokenizer::Languages::Common::PUNCTUATION_MAP
            .each { |pattern, replacement| break if token.sub!(replacement, pattern) }
        token
      end

  end
end
