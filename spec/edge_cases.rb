require 'spec_helper'

TOKENIZER = PragmaticTokenizer::Tokenizer.new(
  remove_stop_words: false,
  punctuation: :none,
  minimum_length: 1,
  remove_emoji: false,
  downcase: false,
  clean: false)

  EDGE_CASES = [
    ['@BonaFried Tier 1/2 1/2/3 a/b a/b/c a/1 a/1/2 a/1/b 1/a 1/a/2 1/a/b ./. Nurse', ["@BonaFried", "Tier", "1/2", "1/2/3", "a/b", "a/b/c", "a/1", "a/1/2", "a/1/b", "1/a", "1/a/2", "1/a/b", "Nurse"]],
    ['http://www.pippo.it/page1/page2', ["http://www.pippo.it/page1/page2"]],
    ['https://t.co/sBxuC8iS34', ['https://t.co/sBxuC8iS34']],
    ['/testword', ['testword']],
    ['testword/', ['testword']],
    ['test/word', ['test/word']],
    ['cnn.com/europe', ['cnn.com/europe']], #EDGE_CASE_7
    ['Video: If you\'re in Tier 2 this is the rule about mixing outdoors https://t.co/GZqNwEJifu', ["Video", "If", "you're", "in", "Tier", "2", "this", "is", "the", "rule", "about", "mixing", "outdoors", "https://t.co/GZqNwEJifu"]],
    ['(Lost Media Iceberg, credit: /u/lostmediamike) https://t.co/twNhpiCIQs', ["Lost", "Media", "Iceberg", "credit", "ulostmediamike", "https://t.co/twNhpiCIQs"]],
    ['https://t.co/sBxuC8iS34', ['https://t.co/sBxuC8iS34']],
    ['62.The position', ['62', 'position']],
    ['62.3', ['62.3']],
    ['pippo.pluto', ['pippo', 'pluto']],
    ['his Tier-1 resource competes for capital right away', ["his", "Tier-1", "resource", "competes", "for", "capital", "right", "away"]],
    ['https://t.co/LGOG7oqvu1', ['https://t.co/LGOG7oqvu1']],
    ['The seven-day rolling rate per 100,000 population is 266.1 –   46.3 per 100,000 population a week ago.', ["The", "seven-day", "rolling", "rate", "per", "100,000", "population", "is", "266.1", "46.3", "per", "100,000", "population", "a", "week", "ago"]]
  ].freeze

describe PragmaticTokenizer do
  EDGE_CASES.each do |text, expected|
    it "#{text}" do
      tokenized = TOKENIZER.tokenize(text)
      expect(tokenized).to eq(expected)
    end
  end
end
