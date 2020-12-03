module PragmaticTokenizer
  module Languages
    module Arabic
      include Languages::Common
      ABBREVIATIONS = Set.new(['ا', 'ا. د', 'ا.د', 'ا.ش.ا', 'ا.ش.ا', 'إلخ', 'ت.ب', 'ت.ب', 'ج.ب', 'جم', 'ج.ب', 'ج.م.ع', 'ج.م.ع', 'س.ت', 'س.ت', 'سم', 'ص.ب.', 'ص.ب', 'كج.', 'كلم.', 'م', 'م.ب', 'م.ب', 'ه', 'د‪']).freeze
      STOP_WORDS = File.open(File.expand_path("../../stopwords/#{name.to_s.split('::').last.downcase}.txt", __FILE__)).read.split("\n").freeze
      CONTRACTIONS  = {}.freeze
    end
  end
end
