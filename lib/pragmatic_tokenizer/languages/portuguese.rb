module PragmaticTokenizer
  module Languages
    module Portuguese
      include Languages::Common
      ABBREVIATIONS = Set.new([]).freeze
      STOP_WORDS = File.open(File.expand_path("../../stopwords/#{name.to_s.split('::').last.downcase}.txt", __FILE__)).read.split("\n").freeze
      CONTRACTIONS = {}.freeze
    end
  end
end
