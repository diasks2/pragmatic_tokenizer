require 'spec_helper'

describe PragmaticTokenizer do
  context 'Language: Bulgarian (bg)' do
    it 'tokenizes a string #001' do
      text = 'Стойностни, вкл. български и руски'
      pt = PragmaticTokenizer::Tokenizer.new(
          text,
          language: 'bg'
      )
      expect(pt.tokenize).to eq(["стойностни", ",", "вкл.", "български", "и", "руски"])
    end

    it 'tokenizes a string #002' do
      text = 'Той поставя началото на могъща династия, която управлява в продължение на 150 г. Саргон надделява в двубой с владетеля на град Ур и разширява териториите на държавата си по долното течение на Тигър и Ефрат.'
      pt = PragmaticTokenizer::Tokenizer.new(
          text,
          language:          'bg',
          remove_stop_words: true
      )
      expect(pt.tokenize).to eq(["поставя", "началото", "могъща", "династия", ",", "управлява", "продължение", "150", "саргон", "надделява", "двубой", "владетеля", "град", "ур", "разширява", "териториите", "държавата", "долното", "течение", "тигър", "ефрат", "."])
    end

    it 'tokenizes a string #003' do
      text = 'Без български жертви в Париж.'
      pt = PragmaticTokenizer::Tokenizer.new(
          text,
          language:          'bg',
          remove_stop_words: true
      )
      expect(pt.tokenize).to eq(["български", "жертви", "париж", "."])
    end

    it 'tokenizes a string #004' do
      text = 'Без български жертви в Париж.'
      pt = PragmaticTokenizer::Tokenizer.new(
          text,
          language:          'bg',
          remove_stop_words: true,
          downcase:          false
      )
      expect(pt.tokenize).to eq(["български", "жертви", "Париж", "."])
    end
  end
end
