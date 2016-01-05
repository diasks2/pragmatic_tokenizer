require 'spec_helper'

describe PragmaticTokenizer do
  it 'has a version number' do
    expect(PragmaticTokenizer::VERSION).not_to be nil
  end

  describe '#initialize' do
    it 'raises an error if the text argument is nil' do
      lambda { expect(Tokenizer::Text.new(nil, language: 'en').tokenize).to raise_error }
    end

    it 'raises an error if the text argument is empty' do
      lambda { expect(Tokenizer::Text.new('', language: 'en').tokenize).to raise_error }
    end

    it "raises an error if the punctuation argument is not nil, 'all', 'semi', or 'none'" do
      lambda { expect(Tokenizer::Text.new('', language: 'en', punctuation: 'world').tokenize).to raise_error }
    end
  end

  it 'tokenizes a string #001' do
    # https://www.ibm.com/developerworks/community/blogs/nlp/entry/tokenization?lang=en
    pt = PragmaticTokenizer::Tokenizer.new("\"I said, 'what're you? Crazy?'\" said Sandowsky. \"I can't afford to do that.\"")
    expect(pt.tokenize).to eq(['"', 'i', 'said', ',', "'", 'what', 'are', 'you', '?', 'crazy', '?', "'", 'said', 'sandowsky', '.', '"', 'i', 'can', 'not', 'afford', 'to', 'do', 'that', '.', "'"])
  end

  it 'tokenizes a string #002' do
    # http://nlp.stanford.edu/software/tokenizer.shtml
    pt = PragmaticTokenizer::Tokenizer.new("\"Oh, no,\" she's saying, \"our $400 blender can't handle something this hard!\"")
    expect(pt.tokenize).to eq(['"', 'oh', ',', 'no', ',', '"', 'she', 'is', 'saying', ',', '"', 'our', '$400', 'blender', 'can', 'not', 'handle', 'something', 'this', 'hard', '!', '"'])
  end
end


