require 'spec_helper'

describe PragmaticTokenizer do
  it 'has a version number' do
    expect(PragmaticTokenizer::VERSION).not_to be nil
  end

  describe '#initialize' do
    it 'raises an error if the text argument is nil' do
      lambda { expect(PragmaticTokenizer::Tokenizer.new(nil, language: 'en').tokenize).to raise_error }
    end

    it 'raises an error if the text argument is empty' do
      lambda { expect(PragmaticTokenizer::Tokenizer.new('', language: 'en').tokenize).to raise_error }
    end

    it 'converts type to string' do
      pt = PragmaticTokenizer::Tokenizer.new(5)
      expect(pt.tokenize).to eq(['5'])
    end

    it "raises an error if the punctuation argument is not nil, 'all', 'semi', or 'none'" do
      lambda { expect(PragmaticTokenizer::Tokenizer.new('', language: 'en', punctuation: 'world').tokenize).to raise_error }
    end
  end
end
