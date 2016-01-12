require 'spec_helper'

describe PragmaticTokenizer do
  context 'Language: German (de)' do
    it 'tokenizes a string #001' do
      text = 'Das steht auf S. 23, s. vorherige Anmerkung.'
      expect(PragmaticTokenizer::Tokenizer.new(text, language: 'de').tokenize).to eq(['das', 'steht', 'auf', 's.', '23', ',', 's.', 'vorherige', 'anmerkung', '.'])
    end

    it 'tokenizes a string #002' do
      text = 'Die größte Ausdehnung des Landes vom Westen nach Osten beträgt 650 km – von Nord nach Süd sind es 560 km. Unter den europäischen Staaten ist Weißrussland flächenmäßig an 13'
      expect(PragmaticTokenizer::Tokenizer.new(text,
        language: 'de',
        downcase: false,
        remove_stop_words: true,
        punctuation: 'none',
        remove_numbers: true
      ).tokenize).to eq(["größte", "Ausdehnung", "Landes", "Westen", "Osten", "beträgt", "Nord", "Süd", "europäischen", "Staaten", "Weißrussland", "flächenmäßig"])
    end

    it 'tokenizes a string #003' do
      text = 'Die weißrussischen offiziellen Stellen wie auch die deutsche Diplomatie verwenden in offiziellen deutschsprachigen Texten den Namen Belarus, um die Unterscheidung von Russland zu verdeutlichen.'
      expect(PragmaticTokenizer::Tokenizer.new(text,
        language: 'de',
        downcase: false
      ).tokenize).to eq(["Die", "weißrussischen", "offiziellen", "Stellen", "wie", "auch", "die", "deutsche", "Diplomatie", "verwenden", "in", "offiziellen", "deutschsprachigen", "Texten", "den", "Namen", "Belarus", ",", "um", "die", "Unterscheidung", "von", "Russland", "zu", "verdeutlichen", "."])
    end

    it 'tokenizes a string #004' do
      text = 'der Kaffee-Ersatz'
      expect(PragmaticTokenizer::Tokenizer.new(text,
        language: 'de',
        downcase: false
      ).tokenize).to eq(['der', 'Kaffee-Ersatz'])
    end
  end
end
