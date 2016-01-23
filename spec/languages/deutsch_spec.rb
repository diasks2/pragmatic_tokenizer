require 'spec_helper'

describe PragmaticTokenizer do
  context 'Language: German (de)' do
    it 'tokenizes a string #001' do
      text = 'Das steht auf S. 23, s. vorherige Anmerkung.'
      expect(PragmaticTokenizer::Tokenizer.new(text, language: 'de').tokenize).to eq(['das', 'steht', 'auf', 's.', '23', ',', 's.', 'vorherige', 'anmerkung', '.'])
    end

    it 'tokenizes a string #002' do
      text = 'Die größte Ausdehnung des Landes vom Westen nach Osten beträgt 650 km – von Nord nach Süd sind es 560 km. Unter den europäischen Staaten ist Weißrussland flächenmäßig an 13'
      expect(PragmaticTokenizer::Tokenizer.new(
          text,
                                               language:          'de',
                                               downcase:          false,
                                               remove_stop_words: true,
                                               punctuation:       'none',
                                               numbers:           :none
                                              ).tokenize).to eq(["größte", "Ausdehnung", "Landes", "Westen", "Osten", "beträgt", "Nord", "Süd", "europäischen", "Staaten", "Weißrussland", "flächenmäßig"])
    end

    it 'tokenizes a string #003' do
      text = 'Die weißrussischen offiziellen Stellen wie auch die deutsche Diplomatie verwenden in offiziellen deutschsprachigen Texten den Namen Belarus, um die Unterscheidung von Russland zu verdeutlichen.'
      expect(PragmaticTokenizer::Tokenizer.new(
          text,
                                               language: 'de',
                                               downcase: false
                                              ).tokenize).to eq(["Die", "weißrussischen", "offiziellen", "Stellen", "wie", "auch", "die", "deutsche", "Diplomatie", "verwenden", "in", "offiziellen", "deutschsprachigen", "Texten", "den", "Namen", "Belarus", ",", "um", "die", "Unterscheidung", "von", "Russland", "zu", "verdeutlichen", "."])
    end

    it 'tokenizes a string #004' do
      text = 'der Kaffee-Ersatz'
      expect(PragmaticTokenizer::Tokenizer.new(
          text,
                                               language: 'de',
                                               downcase: false
                                              ).tokenize).to eq(['der', 'Kaffee-Ersatz'])
    end

    it 'tokenizes a string #005' do
      text = "Charlie Hebdo backlash over 'racist' Alan Kurdi cartoon - https://t.co/J8N2ylVV3w"
      expect(PragmaticTokenizer::Tokenizer.new(
          text,
                                               language: 'de'
                                              ).tokenize).to eq(["charlie", "hebdo", "backlash", "over", "'", "racist", "'", "alan", "kurdi", "cartoon", "-", "https://t.co/j8n2ylvv3w"])
    end

    it 'handles words with a slash 1' do
      text = "We pay 3000 €/month"
      pt = PragmaticTokenizer::Tokenizer.new(
          text,
                                             punctuation: 'none',
                                             language:    'de'
                                            )
      expect(pt.tokenize).to eq(["we", "pay", "3000", "€", "month"])
    end

    it 'handles words with a slash 2' do
      text = "Ich frage mich, wieso er nicht Herr der Lage war/ist."
      pt = PragmaticTokenizer::Tokenizer.new(
          text,
                                             punctuation: 'none',
                                             language:    'de'
                                            )
      expect(pt.tokenize).to eq(["ich", "frage", "mich", "wieso", "er", "nicht", "herr", "der", "lage", "war", "ist"])
    end

    it 'handles words with a slash 3' do
      text = "Poison gas attack in Ghuta/Syria."
      pt = PragmaticTokenizer::Tokenizer.new(
          text,
                                             punctuation: 'none',
                                             language:    'de'
                                            )
      expect(pt.tokenize).to eq(["poison", "gas", "attack", "in", "ghuta", "syria"])
    end

    it 'handles words with a question mark' do
      text = "Essen á la carte?Man ist versucht…"
      pt = PragmaticTokenizer::Tokenizer.new(
          text,
                                             punctuation: 'none',
                                             language:    'de'
                                            )
      expect(pt.tokenize).to eq(["essen", "á", "la", "carte", "man", "ist", "versucht"])
    end

    it 'handles apostrophes and quotes 3' do
      text = "Die “Mitte der Gesellschaft” interessiert sich jetzt für “Feminismus”."
      pt = PragmaticTokenizer::Tokenizer.new(
          text,
                                             punctuation: 'none',
                                             language:    'de'
                                            )
      expect(pt.tokenize).to eq(["die", "mitte", "der", "gesellschaft", "interessiert", "sich", "jetzt", "für", "feminismus"])
    end

    it 'handles mentions 1' do
      text = "@RainerSteinke @_Sternchen_2015 1:0 für dich."
      pt = PragmaticTokenizer::Tokenizer.new(
          text,
                                             punctuation: 'none',
                                             language:    'de'
                                            )
      expect(pt.tokenize).to eq(["@rainersteinke", "@_sternchen_2015", "1:0", "für", "dich"])
    end

    it 'handles mentions 2' do
      text = "@LandauDaniel @AnthZeto @julianfranz @S_Beck19 Yep!"
      pt = PragmaticTokenizer::Tokenizer.new(
          text,
                                             punctuation: 'none',
                                             language:    'de'
                                            )
      expect(pt.tokenize).to eq(["@landaudaniel", "@anthzeto", "@julianfranz", "@s_beck19", "yep"])
    end

    it 'handles old school emoticons 1' do
      text = "du übertreibst maßlos :D"
      pt = PragmaticTokenizer::Tokenizer.new(
          text,
                                             punctuation: 'none',
                                             downcase:    false,
                                             language:    'de'
                                            )
      expect(pt.tokenize).to eq(["du", "übertreibst", "maßlos", ":D"])
    end

    it 'handles words with a symbol suffix' do
      text = "hier ist ein Whirlpool versteckt^^"
      pt = PragmaticTokenizer::Tokenizer.new(
          text,
                                             punctuation: 'none',
                                             language:    'de'
                                            )
      expect(pt.tokenize).to eq(["hier", "ist", "ein", "whirlpool", "versteckt"])
    end

    it 'handles hashtags 1' do
      text = "„Was wir tun wird in diesem Land Leben retten“:#Obama"
      pt = PragmaticTokenizer::Tokenizer.new(
          text,
                                             punctuation: 'none',
                                             language:    'de'
                                            )
      expect(pt.tokenize).to eq(["was", "wir", "tun", "wird", "in", "diesem", "land", "leben", "retten", "#obama"])
    end

    it 'handles numbers and words' do
      text = "Air Force Once ist 18.270-mal abgehoben."
      pt = PragmaticTokenizer::Tokenizer.new(
          text,
                                             punctuation: 'none',
                                             language:    'de'
                                            )
      expect(pt.tokenize).to eq(["air", "force", "once", "ist", "18.270-mal", "abgehoben"])
    end

    it 'maintains the german gender-neutrality form 2' do
      text = "der/die Lehrer_in und seine/ihre Schüler_innen"
      pt = PragmaticTokenizer::Tokenizer.new(
          text,
                                             punctuation: 'none',
                                             language:    'de'
                                            )
      expect(pt.tokenize).to eq(["der", "die", "lehrer_in", "und", "seine", "ihre", "schüler_innen"])
    end

    it 'handles contractions 1' do
      text = "gibt's"
      pt = PragmaticTokenizer::Tokenizer.new(
          text,
                                             expand_contractions: true,
                                             language:            'de'
                                            )
      expect(pt.tokenize).to eq(["gibt", "es"])
    end

    it 'handles contractions 2' do
      text = "gibt‘s schaut’s wenn＇s g›spür find´s"
      pt = PragmaticTokenizer::Tokenizer.new(
          text,
                                             expand_contractions: true,
                                             language:            'de'
                                            )
      expect(pt.tokenize).to eq(["gibt", "es", "schaut", "es", "wenn", "es", "gespür", "finde", "es"])
    end

    it 'removes English stopwords' do
      text = "der/die Lehrer_in und seine/ihre Schüler_innen. This has some English."
      pt = PragmaticTokenizer::Tokenizer.new(
          text,
                                             filter_languages:  [:en],
                                             remove_stop_words: true,
                                             language:          'de'
                                            )
      expect(pt.tokenize).to eq(["der", "die", "lehrer_in", "und", "seine", "ihre", "schüler_innen", ".", "english", "."])
    end

    it 'removes English and German stopwords' do
      text = "der/die Lehrer_in und seine/ihre Schüler_innen. This has some English."
      pt = PragmaticTokenizer::Tokenizer.new(
          text,
                                             filter_languages:  [:en, :de],
                                             remove_stop_words: true,
                                             language:          'de'
                                            )
      expect(pt.tokenize).to eq(["lehrer_in", "schüler_innen", ".", "english", "."])
    end

    it 'does not remove English stopwords' do
      text = "der/die Lehrer_in und seine/ihre Schüler_innen. This has some English."
      pt = PragmaticTokenizer::Tokenizer.new(
          text,
                                             language: 'de'
                                            )
      expect(pt.tokenize).to eq(["der", "die", "lehrer_in", "und", "seine", "ihre", "schüler_innen", ".", "this", "has", "some", "english", "."])
    end

    # I don't know how to easily treat these forms, especially the most frequent form
    # that attaches "Innen" (plural) or "In" (singular) (with a capital I) to a word.
    it 'maintains the german gender-neutrality form 1' do
      skip "NOT IMPLEMENTED"
      text = "Wir brauchen eine/n erfahrene/n Informatiker/in."
      pt = PragmaticTokenizer::Tokenizer.new(
          text,
                                             punctuation: 'none',
                                             language:    'de'
                                            )
      expect(pt.tokenize).to eq(["wir", "brauchen", "eine/n", "erfahrene/n", "informatiker/in"])
    end

    it 'handles apostrophes and quotes 4' do
      skip "NOT IMPLEMENTED"
      text = "Endlich regnet es ihm nicht mehr auf ́s Haupt!"
      pt = PragmaticTokenizer::Tokenizer.new(
          text,
                                             punctuation: 'none',
                                             language:    'de'
                                            )
      expect(pt.tokenize).to eq(["endlich", "regnet", "es", "ihm", "nicht", "mehr", "auf́s", "haupt"])
    end

    it 'handles abrreviations for languages other than English' do
      text = "Adj. Smith how are ü. today."
      pt = PragmaticTokenizer::Tokenizer.new(
          text,
                                             language: :de
                                            )
      expect(pt.tokenize).to eq(["adj", ".", "smith", "how", "are", "ü.", "today", "."])
    end
  end
end
