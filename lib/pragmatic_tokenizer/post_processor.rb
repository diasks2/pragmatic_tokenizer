module PragmaticTokenizer
  class PostProcessor

    SYMBOL_REGEX = /[♳ ♴ ♵ ♶ ♷ ♸ ♹ ♺ ⚀ ⚁ ⚂ ⚃ ⚄ ⚅ ☇ ☈ ☉ ☊ ☋ ☌ ☍ ☠ ☢ ☣ ☤ ☥ ☦ ☧ ☀ ☁ ☂ ☃ ☄ ☮ ♔ ♕ ♖ ♗ ♘ ♙ ♚ ⚘ ⚭]/

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
        [split_slashes_unless_domain, split_question_marks_unless_domain, split_plus_signs,
         method_name7, method_name8, method_name9,
         method_name10, method_name11, method_name12, method_name13, method_name14, method_name15]
            .reduce(separated) { |a, fn| a.flat_map &fn }
      end

      def full_stop_separated_tokens
        FullStopSeparator.new(tokens: method_name16, abbreviations: abbreviations).separate
      end

      def method_name16
        [split_prefixed_commas, split_suffixed_single_quotes, convert_sym_to_punct]
            .reduce(text.split) { |a, fn| a.flat_map &fn }
      end

      def method_name15
        proc { |token| token.split(PragmaticTokenizer::Languages::Common::POSTFIX_EMOJI_REGEX) }
      end

      def method_name14
        proc { |token| token.split(PragmaticTokenizer::Languages::Common::PREFIX_EMOJI_REGEX) }
      end

      def method_name13
        proc { |token| (token =~ /(\A|\S)\u{2744}[^\u{FE0E}|\u{FE0F}]/) ? token.split(/(\u{2744})/) : token }
      end

      def method_name12
        proc { |token| token.split(/(\u{2744}\u{FE0E})/) }
      end

      def method_name11
        proc { |token| token.split(/(\u{2744}\u{FE0F})/) }
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

      def method_name8
        proc { |token| token.split(/\A(\:)(\S{2,})/) }
      end

      def method_name7
        proc { |token| token.split(/\A\.[^\.].+/) }
      end

      def split_plus_signs
        proc { |token| token.split(/\+/) }
      end

      def split_question_marks_unless_domain
        proc { |token| token.split(/^(?!(http|https|www)[\.|:])(.*)(\?)(.*)/) }
      end

      def split_slashes_unless_domain
        proc { |token| token.split(/^(?!(http|https|www)[\.|:])(.*)\/(.*)/) }
      end

      def split_suffixed_single_quotes
        proc { |token| token.split(/(.+)(’|'|‘|`)$/) }
      end

      def split_prefixed_commas
        proc { |token| token.split(/^(,|‚)+/) }
      end

      def convert_sym_to_punct
        proc do |token|
          symbol_matches = SYMBOL_REGEX.match(token)
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
end
