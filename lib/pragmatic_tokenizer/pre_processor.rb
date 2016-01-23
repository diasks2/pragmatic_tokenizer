module PragmaticTokenizer
  module PreProcessor

    def pre_process(language: Languages::Common)
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
      convert_sgl_quotes!(language)
      convert_apostrophe_s!
      shift_beginning_hyphen!
      shift_ending_hyphen!
      squeeze(' '.freeze)
    end

    private

      # Shift commas off everything but numbers
      def shift_comma!
        gsub!(/,(?!\d)/o, ' , '.freeze)
        gsub!(/(?<=\D),(?=\S+)/, ' , '.freeze)
      end

      def shift_multiple_dash!
        gsub!(/--+/o, ' - '.freeze)
      end

      def shift_inverted_question_mark!
        gsub!(/¿/, ' ¿ '.freeze)
      end

      def shift_inverted_exclamation!
        gsub!(/¡/, ' ¡ '.freeze)
      end

      def shift_exclamation!
        gsub!(/(?<=[a-zA-z])!(?=[a-zA-z])/, ' ! '.freeze)
      end

      def shift_horizontal_ellipsis!
        gsub!(/(…+)/o) { ' '.freeze + Regexp.last_match(1) + ' '.freeze }
      end

      def shift_ellipse_two_dots!
        gsub!(/(\.\.+)/o) { ' '.freeze + Regexp.last_match(1) + ' '.freeze }
      end

      def shift_ellipse_three_dots!
        gsub!(/(\.\.\.+)/o) { ' '.freeze + Regexp.last_match(1) + ' '.freeze }
      end

      def shift_no_space_mention!
        gsub!(/\.(?=(@|＠)[^\.]+(\s|\z))/, '. '.freeze)
      end

      def shift_not_equals!
        gsub!(/≠/, ' ≠ '.freeze)
      end

      def shift_special_quotes!
        gsub!(/([«»„“])/, ' \1 ')
      end

      def shift_colon!
        return unless may_shift_colon?
        # Ignore web addresses
        replacement = replacement_for_key(':'.freeze)
        gsub!(%r{(?<=[(https?|ftp)]):(?=//)}, replacement)
        gsub!(/:/o, ' :'.freeze)
        gsub!(/(?<=\s):(?=\#)/, ': '.freeze)
      end

      def may_shift_colon?
        return false unless include?(':'.freeze)
        partitions = partition(':'.freeze)
        partitions.last[0] !~ /\A\d+/ || partitions.first[-1] !~ /\A\d+/
      end

      def shift_bracket!
        gsub!(/([\(\[\{\}\]\)])/o) { ' ' + Regexp.last_match(1) + ' '.freeze }
      end

      def shift_semicolon!
        gsub!(/([;])/o) { ' '.freeze + Regexp.last_match(1) + ' '.freeze }
      end

      def shift_percent!
        gsub!(/(?<=\D)%(?=\d+)/, ' %'.freeze)
      end

      def shift_caret!
        gsub!(/\^/, ' ^ '.freeze)
      end

      def shift_hashtag!
        gsub!(/(?<=\S)(#|＃)(?=\S)/, ' \1\2')
      end

      def shift_ampersand!
        gsub!(/\&/, ' & '.freeze)
      end

      def shift_vertical_bar!
        gsub!(/\|/, ' | '.freeze)
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
        gsub!(/#{style}(?=.*\w)/o, ' '.freeze + replacement + ' '.freeze)
      end

      def replace_remaining_double_quotes!
        replace_remaining_quotes!('"', '"'.freeze)
        replace_remaining_quotes!("''", '"'.freeze)
        replace_remaining_quotes!('”', '”'.freeze)
      end

      def replace_remaining_quotes!(style, replacement_key)
        replacement = replacement_for_key(replacement_key)
        gsub!(/#{style}/, ' '.freeze + replacement + ' '.freeze)
      end

      def convert_sgl_quotes!(language)
        replace(if defined?(language::SingleQuotes)
                  language::SingleQuotes.new
                      .handle_single_quotes(self)
                else
                  PragmaticTokenizer::Languages::Common::SingleQuotes.new
                      .handle_single_quotes(self)
                end)
      end

      def convert_apostrophe_s!
        replacement = replacement_for_key('`'.freeze)
        gsub!(/\s\u{0301}(?=s(\s|\z))/, replacement)
      end

      def shift_beginning_hyphen!
        gsub!(/\s+-/, ' - '.freeze)
      end

      def shift_ending_hyphen!
        gsub!(/-\s+/, ' - '.freeze)
      end

      def replacement_for_key(replacement_key)
        PragmaticTokenizer::Languages::Common::PUNCTUATION_MAP[replacement_key]
      end

  end
end
