require 'spec_helper'

describe PragmaticTokenizer do
  context 'Language: German (de)' do
    it 'handles common German abbreviations' do
      text = 'Das steht auf S. 23, s. vorherige Anmerkung.'
      expect(PragmaticTokenizer::Tokenizer.new(text, language: 'de').tokenize).to eq(['das', 'steht', 'auf', 's.', '23', ',', 's.', 'vorherige', 'anmerkung', '.'])
    end
  end
end
