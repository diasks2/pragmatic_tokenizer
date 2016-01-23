module PragmaticTokenizer
  class PreProcessor

    def initialize(language: Languages::Common)
      @language = language
    end

    def pre_process(text:)
      shift_comma(text)
      shift_multiple_dash(text)
      shift_upsidedown_question_mark(text)
      shift_upsidedown_exclamation(text)
      shift_exclamation(text)
      shift_ellipse(text)
      shift_no_space_mention(text)
      shift_not_equals(text)
      shift_special_quotes(text)
      shift_colon(text)
      shift_bracket(text)
      shift_semicolon(text)
      shift_percent(text)
      shift_caret(text)
      shift_hashtag(text)
      shift_ampersand(text)
      shift_vertical_bar(text)
      convert_dbl_quotes(text)
      convert_sgl_quotes(text)
      convert_apostrophe_s(text)
      shift_beginning_hyphen(text)
      shift_ending_hyphen(text)
      text.squeeze(' ')
    end

    private

      def shift_comma(text)
        # Shift commas off everything but numbers
        text.gsub!(/,(?!\d)/o, ' , ') || text
        text.gsub!(/(?<=\D),(?=\S+)/, ' , ') || text
      end

      def shift_multiple_dash(text)
        text.gsub!(/--+/o, ' - ') || text
      end

      def shift_upsidedown_question_mark(text)
        text.gsub!(/¿/, ' ¿ ') || text
      end

      def shift_upsidedown_exclamation(text)
        text.gsub!(/¡/, ' ¡ ') || text
      end

      def shift_exclamation(text)
        text.gsub!(/(?<=[a-zA-z])!(?=[a-zA-z])/, ' ! ') || text
      end

      def shift_ellipse(text)
        text.gsub!(/(\.\.\.+)/o) { ' ' + $1 + ' ' } || text
        text.gsub!(/(\.\.+)/o) { ' ' + $1 + ' ' } || text
        text.gsub!(/(…+)/o) { ' ' + $1 + ' ' } || text
      end

      def shift_no_space_mention(text)
        text.gsub!(/\.(?=(@|＠)[^\.]+(\s|\z))/, '. ') || text
      end

      def shift_not_equals(text)
        text.gsub!(/≠/, ' ≠ ') || text
      end

      def shift_special_quotes(text)
        text.gsub!(/«/, ' « ') || text
        text.gsub!(/»/, ' » ') || text
        text.gsub!(/„/, ' „ ') || text
        text.gsub!(/“/, ' “ ') || text
      end

      def shift_colon(text)
        return text unless text.include?(':') &&
          (text.partition(':').last[0] !~ /\A\d+/ ||
          text.partition(':').first[-1] !~ /\A\d+/)
        # Ignore web addresses
        text.gsub!(/(?<=[http|https]):(?=\/\/)/, PragmaticTokenizer::Languages::Common::PUNCTUATION_MAP[":"]) || text
        text.gsub!(/:/o, ' :') || text
        text.gsub!(/(?<=\s):(?=\#)/, ': ') || text
      end

      def shift_bracket(text)
        text.gsub!(/([\(\[\{\}\]\)])/o) { ' ' + $1 + ' ' } || text
      end

      def shift_semicolon(text)
        text.gsub!(/([;])/o) { ' ' + $1 + ' ' } || text
      end

      def shift_percent(text)
        text.gsub!(/(?<=\D)%(?=\d+)/, ' %') || text
      end

      def shift_caret(text)
        text.gsub!(/\^/, ' ^ ') || text
      end

      def shift_hashtag(text)
        text.gsub!(/(?<=\S)(#|＃)(?=\S)/, ' \1\2') || text
      end

      def shift_ampersand(text)
        text.gsub!(/\&/, ' & ') || text
      end

      def shift_vertical_bar(text)
        text.gsub!(/\|/, ' | ') || text
      end

      def convert_dbl_quotes(text)
        # Convert left double quotes to special character
        text.gsub!(/''(?=.*\w)/o, ' ' + PragmaticTokenizer::Languages::Common::PUNCTUATION_MAP['"'] + ' ') || text
        text.gsub!(/"(?=.*\w)/o, ' ' + PragmaticTokenizer::Languages::Common::PUNCTUATION_MAP['"'] + ' ') || text
        text.gsub!(/“(?=.*\w)/o, ' ' + PragmaticTokenizer::Languages::Common::PUNCTUATION_MAP['“'] + ' ') || text
        # Convert remaining quotes to special character
        text.gsub!(/"/, ' ' + PragmaticTokenizer::Languages::Common::PUNCTUATION_MAP['"'] + ' ') || text
        text.gsub!(/''/, ' ' + PragmaticTokenizer::Languages::Common::PUNCTUATION_MAP['"'] + ' ') || text
        text.gsub!(/”/, ' ' + PragmaticTokenizer::Languages::Common::PUNCTUATION_MAP['”'] + ' ') || text
      end

      def convert_sgl_quotes(text)
        if defined? @language::SingleQuotes
          @language::SingleQuotes.new.handle_single_quotes(text)
        else
          PragmaticTokenizer::Languages::Common::SingleQuotes.new.handle_single_quotes(text)
        end
      end

      def convert_apostrophe_s(text)
        text.gsub!(/\s\u{0301}(?=s(\s|\z))/, PragmaticTokenizer::Languages::Common::PUNCTUATION_MAP['`']) || text
      end

      def shift_beginning_hyphen(text)
        text.gsub!(/\s+-/, ' - ') || text
      end

      def shift_ending_hyphen(text)
        text.gsub!(/-\s+/, ' - ') || text
      end
  end
end
