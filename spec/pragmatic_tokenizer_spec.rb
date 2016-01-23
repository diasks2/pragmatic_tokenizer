require 'spec_helper'

describe PragmaticTokenizer do
  it 'has a version number' do
    expect(PragmaticTokenizer::VERSION).not_to be nil
  end

  describe '#initialize' do
    it 'raises an error if the text argument is nil' do
      -> { expect(PragmaticTokenizer::Tokenizer.new(nil, language: 'en').tokenize).to raise_error }
    end

    it 'raises an error if the text argument is empty' do
      -> { expect(PragmaticTokenizer::Tokenizer.new('', language: 'en').tokenize).to raise_error }
    end

    it 'raises an error if minimum_length is not an Integer' do
      -> { expect(PragmaticTokenizer::Tokenizer.new("heelo", minimum_length: "strawberry").tokenize).to raise_error }
    end

    it 'raises an error if long_word_split is not an Integer' do
      -> { expect(PragmaticTokenizer::Tokenizer.new("heeloo", long_word_split: "yes!").tokenize).to raise_error }
    end

    it 'raises an error if the text is not a String' do
      -> { expect(PragmaticTokenizer::Tokenizer.new(5).tokenize).to raise_error }
    end

    it "raises an error if the punctuation argument is not nil, 'all', 'semi', or 'none'" do
      -> { expect(PragmaticTokenizer::Tokenizer.new('', language: 'en', punctuation: 'world').tokenize).to raise_error }
    end

    it "raises an error if the numbers argument is not nil, 'all', 'semi', or 'none'" do
      -> { expect(PragmaticTokenizer::Tokenizer.new('', language: 'en', numbers: 'world').tokenize).to raise_error }
    end

    it "raises an error if the mentions argument is not nil, 'all', 'semi', or 'none'" do
      -> { expect(PragmaticTokenizer::Tokenizer.new('', language: 'en', mentions: 'world').tokenize).to raise_error }
    end
  end
end
