module PragmaticTokenizer
  class Processor
    attr_reader :text
    def initialize(language: Languages::Common)
      @language = language
    end

    def process(text:)
      shift_comma(text)
      shift_multiple_dash(text)
      shift_upsidedown_question_mark(text)
      shift_upsidedown_exclamation(text)
      shift_ellipse(text)
      shift_special_quotes(text)
      shift_colon(text)
      shift_bracket(text)
      convert_dbl_quotes(text)
      convert_sgl_quotes(text)
      tokens = separate_full_stop(text.squeeze(' ').split.map { |t| convert_sym_to_punct(t.downcase) })
      separate_other_ending_punc(tokens)
    end

    private

    def convert_dbl_quotes(text)
      # Convert left double quotes to special character
      text.gsub!(/"(?=.*\w)/o, ' ' + convert_punct_to_sym('"') + ' ') || text
      # Convert remaining quotes to special character
      text.gsub!(/"/, ' ' + convert_punct_to_sym('"') + ' ') || text
    end

    def convert_sgl_quotes(text)
      text.gsub!(/`(?!`)(?=.*\w)/o, ' ' + convert_punct_to_sym("'") + ' ') || text
      # Convert left quotes to special character except for 'Twas or 'twas
      text.gsub!(/(\W|^)'(?=.*\w)(?!twas)(?!Twas)/o) { $1 ? $1 + ' ' + convert_punct_to_sym("'") + ' ' : ' ' + convert_punct_to_sym("'") + ' ' } || text
      text.gsub!(/(\W|^)'(?=.*\w)/o, ' ' + convert_punct_to_sym("'")) || text
      # Separate right single quotes
      text.gsub!(/(\w|\D)'(?!')(?=\W|$)/o) { $1 + ' ' + convert_punct_to_sym("'") + ' ' } || text
    end

    def shift_multiple_dash(text)
      text.gsub!(/--+/o, ' - ') || text
    end

    def shift_comma(text)
      # Shift commas off everything but numbers
      text.gsub!(/,(?!\d)/o, ' , ') || text
    end

    def shift_upsidedown_question_mark(text)
      text.gsub!(/¿/, ' ¿ ') || text
    end

    def shift_upsidedown_exclamation(text)
      text.gsub!(/¡/, ' ¡ ') || text
    end

    def shift_special_quotes(text)
      text.gsub!(/«/, ' « ') || text
      text.gsub!(/»/, ' » ') || text
      text.gsub!(/„/, ' „ ') || text
      text.gsub!(/“/, ' “ ') || text
    end

    def shift_bracket(text)
      text.gsub!(/([\(\[\{\}\]\)])/o) { ' ' + $1 + ' ' } || text
    end

    def shift_colon(text)
      return text unless text.include?(':') &&
        !(/\A\d+/ == text.partition(':').last[0]) &&
        !(/\A\d+/ == text.partition(':').first[-1])
      # Ignore web addresses
      text.gsub!(/(?<=[http|https]):(?=\/\/)/, convert_punct_to_sym(":")) || text
      text.gsub!(/:/o, ' :') || text
    end

    def shift_ellipse(text)
      text.gsub!(/(\.\.\.+)/o) { ' ' + $1 + ' ' } || text
    end

    def separate_full_stop(tokens)
      abbr = {}
      @language::ABBREVIATIONS.each do |i|
        abbr[i] = true
      end
      cleaned_tokens = []
      tokens.each_with_index do |_t, i|
        if tokens[i + 1] && tokens[i] =~ /\A(.+)\.\z/
          w = $1
          unless abbr[w.downcase] || w =~ /\A[a-z]\z/i ||
            w =~ /[a-z](?:\.[a-z])+\z/i
            cleaned_tokens <<  w
            cleaned_tokens << '.'
            next
          end
        end
        cleaned_tokens << tokens[i]
      end
      if cleaned_tokens[-1] && cleaned_tokens[-1] =~ /\A(.*\w)\.\z/
        cleaned_tokens[-1] = $1
        cleaned_tokens.push '.'
      end
      cleaned_tokens
    end

    def separate_other_ending_punc(tokens)
      cleaned_tokens = []
      tokens.each do |a|
        split_punctuation = a.scan(/(?<=\S)[。．！!?？]+$/)
        if split_punctuation[0].nil?
          cleaned_tokens << a
        else
          cleaned_tokens << a.tr(split_punctuation[0],'')
          if split_punctuation[0].length.eql?(1)
            cleaned_tokens << split_punctuation[0]
          else
            split_punctuation[0].split("").each do |s|
              cleaned_tokens << s
            end
          end
        end
      end
      cleaned_tokens
    end

    def convert_punct_to_sym(p)
      index = PragmaticTokenizer::Languages::Common::PUNCTUATION.index(p)
      PragmaticTokenizer::Languages::Common::PUNCTUATION_MAP[index]
    end

    def convert_sym_to_punct(p)
      counter = 0
      PragmaticTokenizer::Languages::Common::PUNCTUATION_MAP.each_with_index do |m, i|
        if p.include?(m)
          counter+=1
          return p.gsub!(m, PragmaticTokenizer::Languages::Common::PUNCTUATION[i])
        end
      end
      if counter.eql?(0)
        p
      end
    end
  end
end