require 'spec_helper'

describe PragmaticTokenizer do
  context 'Language: French (fr)' do
    it 'tokenizes a string #001' do
      text = "L'art de l'univers, c'est un art"
      pt = PragmaticTokenizer::Tokenizer.new(
          language: 'fr'
      )
      expect(pt.tokenize(text)).to eq(["l'", "art", "de", "l'", "univers", ",", "c'est", "un", "art"])
    end
  end
end
