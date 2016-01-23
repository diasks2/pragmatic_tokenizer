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
      shift_ellipse_three_dots!
      shift_ellipse_two_dots!
      shift_horizontal_ellipsis!
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
      @text.squeeze(' '.freeze)
    end

    private

      # Shift commas off everything but numbers
      def shift_comma!
        @text.gsub!(/,(?!\d)/o, ' , '.freeze)
        @text.gsub!(/(?<=\D),(?=\S+)/, ' , '.freeze)
      end

      def shift_multiple_dash!
        @text.gsub!(/--+/o, ' - '.freeze)
      end

      def shift_inverted_question_mark!
        @text.gsub!(/¿/, ' ¿ '.freeze)
      end

      def shift_inverted_exclamation!
        @text.gsub!(/¡/, ' ¡ '.freeze)
      end

      def shift_exclamation!
        @text.gsub!(/(?<=[a-zA-z])!(?=[a-zA-z])/, ' ! '.freeze)
      end

      def shift_horizontal_ellipsis!
        @text.gsub!(/(…+)/o) { ' '.freeze + Regexp.last_match(1) + ' '.freeze }
      end

      def shift_ellipse_two_dots!
        @text.gsub!(/(\.\.+)/o) { ' '.freeze + Regexp.last_match(1) + ' '.freeze }
      end

      def shift_ellipse_three_dots!
        @text.gsub!(/(\.\.\.+)/o) { ' '.freeze + Regexp.last_match(1) + ' '.freeze }
      end

      def shift_no_space_mention!
        @text.gsub!(/\.(?=(@|＠)[^\.]+(\s|\z))/, '. '.freeze)
      end

      def shift_not_equals!
        @text.gsub!(/≠/, ' ≠ '.freeze)
      end

      def shift_special_quotes!
        @text.gsub!(/«/, ' « '.freeze)
        @text.gsub!(/»/, ' » '.freeze)
        @text.gsub!(/„/, ' „ '.freeze)
        @text.gsub!(/“/, ' “ '.freeze)
      end

      def shift_colon!
        return unless may_shift_colon?
        # Ignore web addresses
        replacement = replacement_for_key(':'.freeze)
        @text.gsub!(%r{(?<=[(https?|ftp)]):(?=//)}, replacement)
        @text.gsub!(/:/o, ' :'.freeze)
        @text.gsub!(/(?<=\s):(?=\#)/, ': '.freeze)
      end

      def may_shift_colon?
        return false unless @text.include?(':'.freeze)
        partitions = @text.partition(':'.freeze)
        partitions.last[0] !~ /\A\d+/ || partitions.first[-1] !~ /\A\d+/
      end

      def shift_bracket!
        @text.gsub!(/([\(\[\{\}\]\)])/o) { ' ' + Regexp.last_match(1) + ' '.freeze }
      end

      def shift_semicolon!
        @text.gsub!(/([;])/o) { ' '.freeze + Regexp.last_match(1) + ' '.freeze }
      end

      def shift_percent!
        @text.gsub!(/(?<=\D)%(?=\d+)/, ' %'.freeze)
      end

      def shift_caret!
        @text.gsub!(/\^/, ' ^ '.freeze)
      end

      def shift_hashtag!
        @text.gsub!(/(?<=\S)(#|＃)(?=\S)/, ' \1\2')
      end

      def shift_ampersand!
        @text.gsub!(/\&/, ' & '.freeze)
      end

      def shift_vertical_bar!
        @text.gsub!(/\|/, ' | '.freeze)
      end

      def convert_dbl_quotes!
        replace_left_double_quotes!
        replace_remaining_double_quotes!
      end

      def replace_left_double_quotes!
        replace_left_quotes!("''", '"'.freeze)
        replace_left_quotes!('"', '"'.freeze)
        replace_left_quotes!('“', '“'.freeze)
      end

      def replace_left_quotes!(style, replacement_key)
        replacement = replacement_for_key(replacement_key)
        @text.gsub!(/#{style}(?=.*\w)/o, ' '.freeze + replacement + ' '.freeze)
      end

      def replace_remaining_double_quotes!
        replace_remaining_quotes!('"', '"'.freeze)
        replace_remaining_quotes!("''", '"'.freeze)
        replace_remaining_quotes!('”', '”'.freeze)
      end

      def replace_remaining_quotes!(style, replacement_key)
        replacement = replacement_for_key(replacement_key)
        @text.gsub!(/#{style}/, ' '.freeze + replacement + ' '.freeze)
      end

      def convert_sgl_quotes!
        @text = if defined?(@language::SingleQuotes)
                  @language::SingleQuotes.new.handle_single_quotes(@text)
                else
                  PragmaticTokenizer::Languages::Common::SingleQuotes.new.handle_single_quotes(@text)
                end
      end

      def convert_apostrophe_s!
        replacement = replacement_for_key('`'.freeze)
        @text.gsub!(/\s\u{0301}(?=s(\s|\z))/, replacement)
      end

      def shift_beginning_hyphen!
        @text.gsub!(/\s+-/, ' - '.freeze)
      end

      def shift_ending_hyphen!
        @text.gsub!(/-\s+/, ' - '.freeze)
      end

      def replacement_for_key(replacement_key)
        PragmaticTokenizer::Languages::Common::PUNCTUATION_MAP[replacement_key]
      end

  end
end
