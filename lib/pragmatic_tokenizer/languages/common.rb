module PragmaticTokenizer
  module Languages
    module Common
      PUNCTUATION = ['。', '．', '.', '！', '!', '?', '？', '、', '¡', '¿', '„', '“', '[', ']', '"', '#', '$', '%', '&', '(', ')', '*', '+', ',', ':', ';', '<', '=', '>', '@', '^', '_', '`', "'", '{', '|', '}', '~', '-', '«', '»', '/', '›', '‹', '^', '”']
      PUNCTUATION_MAP = { "。" => "♳", "．" => "♴", "." => "♵", "！" => "♶", "!" => "♷", "?" => "♸", "？" => "♹", "、" => "♺", "¡" => "⚀", "¿" => "⚁", "„" => "⚂", "“" => "⚃", "[" => "⚄", "]" => "⚅", "\"" => "☇", "#" => "☈", "$" => "☉", "%" => "☊", "&" => "☋", "(" => "☌", ")" => "☍", "*" => "☠", "+" => "☢", "," => "☣", ":" => "☤", ";" => "☥", "<" => "☦", "=" => "☧", ">" => "☀", "@" => "☁", "^" => "☂", "_" => "☃", "`" => "☄", "'" => "☮", "{" => "♔", "|" => "♕", "}" => "♖", "~" => "♗", "-" => "♘", "«" => "♙", "»" => "♚", "”" => "⚘" }
      SEMI_PUNCTUATION = ['。', '．', '.']
      ROMAN_NUMERALS = ['i', 'ii', 'iii', 'iv', 'v', 'vi', 'vii', 'viii', 'ix', 'x', 'xi', 'xii', 'xiii', 'xiv', 'xv', 'xvi', 'xvii', 'xviii', 'xix', 'xx', 'xxi', 'xxii', 'xxiii', 'xxiv', 'xxv', 'xxvi', 'xxvii', 'xxviii', 'xxix', 'xxx', 'xxxi', 'xxxii', 'xxxiii', 'xxxiv', 'xxxv', 'xxxvi', 'xxxvii', 'xxxviii', 'xxxix', 'xl', 'xli', 'xlii', 'xliii', 'xliv', 'xlv', 'xlvi', 'xlvii', 'xlviii', 'xlix', 'l', 'li', 'lii', 'liii', 'liv', 'lv', 'lvi', 'lvii', 'lviii', 'lix', 'lx', 'lxi', 'lxii', 'lxiii', 'lxiv', 'lxv', 'lxvi', 'lxvii', 'lxviii', 'lxix', 'lxx', 'lxxi', 'lxxii', 'lxxiii', 'lxxiv', 'lxxv', 'lxxvi', 'lxxvii', 'lxxviii', 'lxxix', 'lxxx', 'lxxxi', 'lxxxii', 'lxxxiii', 'lxxxiv', 'lxxxv', 'lxxxvi', 'lxxxvii', 'lxxxviii', 'lxxxix', 'xc', 'xci', 'xcii', 'xciii', 'xciv', 'xcv', 'xcvi', 'xcvii', 'xcviii', 'xcix']
      SPECIAL_CHARACTERS = ['®', '©', '™']
      ABBREVIATIONS = []
      STOP_WORDS = []
      CONTRACTIONS = {}

      class SingleQuotes
        def handle_single_quotes(text)
          text.gsub!(/`(?!`)(?=.*\w)/o, ' ' + PragmaticTokenizer::Languages::Common::PUNCTUATION_MAP["'"] + ' ') || text
          text.gsub!(/(\W|^)'(?=.*\w)/o, ' ' + PragmaticTokenizer::Languages::Common::PUNCTUATION_MAP["'"]) || text
          # Separate right single quotes
          text.gsub!(/(\w|\D)'(?!')(?=\W|$)/o) { $1 + ' ' + PragmaticTokenizer::Languages::Common::PUNCTUATION_MAP["'"] + ' ' } || text
        end
      end
    end
  end
end
