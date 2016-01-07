require 'spec_helper'

describe PragmaticTokenizer do
  context 'Language: French (fr)' do
    it 'tokenizes a string #001' do
      text = "L'art de l'univers, c'est un art"
      expect(PragmaticTokenizer::Tokenizer.new(text, language: 'fr').tokenize).to eq(["l'", "art", "de", "l'", "univers", ",", "c'est", "un", "art"])
    end
  end
end
