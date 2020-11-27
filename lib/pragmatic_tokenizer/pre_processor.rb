module PragmaticTokenizer
  module PreProcessor

    def pre_process(language: Languages::Common)
      remove_non_breaking_space!
      shift_various_characters!
      replace_colon_in_url!
      shift_remaining_colons!
      shift_hashtag!
      convert_double_quotes!
      convert_single_quotes!(language)
      convert_acute_accent_s!
      shift_hyphens!
      squeeze(' '.freeze)
    end

    private
      def remove_non_breaking_space!
        gsub!(Regex::NO_BREAK_SPACE, ''.freeze)
      end

      def shift_various_characters!
        gsub!(Regex::PRE_PROCESS, ' \1 \2 \3 \4 \5 \6 \7 \8 \9 ')
      end

      def replace_colon_in_url!
        gsub!(Regex::COLON_IN_URL, replacement_for_key(':'.freeze))
      end

      def shift_remaining_colons!
        gsub!(':'.freeze, ' :'.freeze) if self !~ Regex::TIME_WITH_COLON
      end

      def shift_hashtag!
        gsub!('#'.freeze, ' #'.freeze)
      end

      def convert_double_quotes!
        gsub!(Regex::QUOTE, replacements_for_quotes)
      end

      def replacements_for_quotes
        @replacements_for_quotes ||= {
            "''" => ' ' << replacement_for_key('"'.freeze) << ' ',
            '"'  => ' ' << replacement_for_key('"'.freeze) << ' ',
            '“'  => ' ' << replacement_for_key('“'.freeze) << ' '
        }.freeze
      end

      def convert_single_quotes!(language)
        replace(class_for_single_quotes(language).new.handle_single_quotes(self))
      end

      def class_for_single_quotes(language)
        defined?(language::SingleQuotes) ? language::SingleQuotes : PragmaticTokenizer::Languages::Common::SingleQuotes
      end

      def convert_acute_accent_s!
        gsub!(Regex::ACUTE_ACCENT_S, replacement_for_key('`'.freeze))
      end

      # can these two regular expressions be merged somehow?
      def shift_hyphens!
        gsub!(Regex::HYPHEN_AFTER_NON_WORD,  ' - '.freeze)
        gsub!(Regex::HYPHEN_BEFORE_NON_WORD, ' - '.freeze)
      end

      def replacement_for_key(replacement_key)
        PragmaticTokenizer::Languages::Common::PUNCTUATION_MAP[replacement_key]
      end

  end
end
