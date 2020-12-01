module PragmaticTokenizer
  module Languages
    module Greek
      include Languages::Common
      ABBREVIATIONS = Set.new([]).freeze
      STOP_WORDS = File.open("lib/pragmatic_tokenizer/stopwords/#{name.to_s.split('::').last.downcase}.txt").read.split("\n").freeze
      CONTRACTIONS  = {}.freeze
    end
  end
end
