require 'spec_helper'

describe PragmaticTokenizer do
  context 'Language: French (fr)' do
    it 'tokenizes a string #001' do
      text = "L'art de l'univers, c'est un art"
      pt = PragmaticTokenizer::Tokenizer.new(text,
                                             language: 'fr'
      )
      expect(pt.tokenize).to eq(["l'", "art", "de", "l'", "univers", ",", "c'est", "un", "art"])
    end
  end
end
