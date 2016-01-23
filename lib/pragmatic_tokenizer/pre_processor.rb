module PragmaticTokenizer
  class PreProcessor

    def initialize(language: Languages::Common)
      @language = language
    end

    def pre_process(text:)
      @text = text
      shift_comma!
      shift_multiple_dash!
      shift_inverted_question_mark!
      shift_inverted_exclamation!
      shift_exclamation!
      shift_ellipse!
      shift_no_space_mention!
      shift_not_equals!
      shift_special_quotes!
      shift_colon!
      shift_bracket!
      shift_semicolon!
      shift_percent!
      shift_caret!
      shift_hashtag!
      shift_ampersand!
      shift_vertical_bar!
      convert_dbl_quotes!
      convert_sgl_quotes!
      convert_apostrophe_s!
      shift_beginning_hyphen!
      shift_ending_hyphen!
      @text.squeeze(' ')
    end

    private

      # Shift commas off everything but numbers
      def shift_comma!
        @text.gsub!(/,(?!\d)/o, ' , ')
        @text.gsub!(/(?<=\D),(?=\S+)/, ' , ')
      end

      def shift_multiple_dash!
        @text.gsub!(/--+/o, ' - ')
      end

      def shift_inverted_question_mark!
        @text.gsub!(/¿/, ' ¿ ')
      end

      def shift_inverted_exclamation!
        @text.gsub!(/¡/, ' ¡ ')
      end

      def shift_exclamation!
        @text.gsub!(/(?<=[a-zA-z])!(?=[a-zA-z])/, ' ! ')
      end

      def shift_ellipse!
        @text.gsub!(/(\.\.\.+)/o) { ' ' + Regexp.last_match(1) + ' ' }
        @text.gsub!(/(\.\.+)/o) { ' ' + Regexp.last_match(1) + ' ' }
        @text.gsub!(/(…+)/o) { ' ' + Regexp.last_match(1) + ' ' }
      end

      def shift_no_space_mention!
        @text.gsub!(/\.(?=(@|＠)[^\.]+(\s|\z))/, '. ')
      end

      def shift_not_equals!
        @text.gsub!(/≠/, ' ≠ ')
      end

      def shift_special_quotes!
        @text.gsub!(/«/, ' « ')
        @text.gsub!(/»/, ' » ')
        @text.gsub!(/„/, ' „ ')
        @text.gsub!(/“/, ' “ ')
      end

      def shift_colon!
        return unless may_shift_colon?
        # Ignore web addresses
        @text.gsub!(/(?<=[http|https]):(?=\/\/)/, PragmaticTokenizer::Languages::Common::PUNCTUATION_MAP[":"])
        @text.gsub!(/:/o, ' :')
        @text.gsub!(/(?<=\s):(?=\#)/, ': ')
      end

      def may_shift_colon?
        return false unless @text.include?(':')
        partitions = @text.partition(':')
        partitions.last[0] !~ /\A\d+/ || partitions.first[-1] !~ /\A\d+/
      end

      def shift_bracket!
        @text.gsub!(/([\(\[\{\}\]\)])/o) { ' ' + Regexp.last_match(1) + ' ' }
      end

      def shift_semicolon!
        @text.gsub!(/([;])/o) { ' ' + Regexp.last_match(1) + ' ' }
      end

      def shift_percent!
        @text.gsub!(/(?<=\D)%(?=\d+)/, ' %')
      end

      def shift_caret!
        @text.gsub!(/\^/, ' ^ ')
      end

      def shift_hashtag!
        @text.gsub!(/(?<=\S)(#|＃)(?=\S)/, ' \1\2')
      end

      def shift_ampersand!
        @text.gsub!(/\&/, ' & ')
      end

      def shift_vertical_bar!
        @text.gsub!(/\|/, ' | ')
      end

      def convert_dbl_quotes!
        # Convert left double quotes to special character
        @text.gsub!(/''(?=.*\w)/o, ' ' + PragmaticTokenizer::Languages::Common::PUNCTUATION_MAP['"'] + ' ')
        @text.gsub!(/"(?=.*\w)/o, ' ' + PragmaticTokenizer::Languages::Common::PUNCTUATION_MAP['"'] + ' ')
        @text.gsub!(/“(?=.*\w)/o, ' ' + PragmaticTokenizer::Languages::Common::PUNCTUATION_MAP['“'] + ' ')
        # Convert remaining quotes to special character
        @text.gsub!(/"/, ' ' + PragmaticTokenizer::Languages::Common::PUNCTUATION_MAP['"'] + ' ')
        @text.gsub!(/''/, ' ' + PragmaticTokenizer::Languages::Common::PUNCTUATION_MAP['"'] + ' ')
        @text.gsub!(/”/, ' ' + PragmaticTokenizer::Languages::Common::PUNCTUATION_MAP['”'] + ' ')
      end

      def convert_sgl_quotes!
        if defined? @language::SingleQuotes
          @language::SingleQuotes.new.handle_single_quotes(@text)
        else
          PragmaticTokenizer::Languages::Common::SingleQuotes.new.handle_single_quotes(@text)
        end
      end

      def convert_apostrophe_s!
        @text.gsub!(/\s\u{0301}(?=s(\s|\z))/, PragmaticTokenizer::Languages::Common::PUNCTUATION_MAP['`'])
      end

      def shift_beginning_hyphen!
        @text.gsub!(/\s+-/, ' - ')
      end

      def shift_ending_hyphen!
        @text.gsub!(/-\s+/, ' - ')
      end
  end
end
