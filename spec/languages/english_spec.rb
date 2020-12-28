require 'spec_helper'

describe PragmaticTokenizer do
  context 'Language: English (en)' do
    context '#tokenize (example strings)' do
      context 'no options selected' do
        
        it "do" do
          stop_words_file_name = "ro_stopwords.txt"
          classe = "Romanian"
          old = File.open("lib/pragmatic_tokenizer/stopwords/#{stop_words_file_name}").read.split("\n") rescue []
          newer = eval("PragmaticTokenizer::Languages::#{classe}::STOP_WORDS").to_a
          
          File.open("lib/pragmatic_tokenizer/stopwords/#{classe.downcase}.txt", "w:UTF-8") do |f|
            (old + newer).uniq.sort.each do |token|
              f.puts(token)
            end
          end
        end

        it 'tokenizes a string #001' do
          text = "Hello world."
          pt = PragmaticTokenizer::Tokenizer.new
          expect(pt.tokenize(text)).to eq(["hello", "world", "."])
        end

        it 'tokenizes a string #002' do
          text = "Hello Dr. Death."
          pt = PragmaticTokenizer::Tokenizer.new
          expect(pt.tokenize(text)).to eq(["hello", "dr.", "death", "."])
        end

        it 'tokenizes a string #003' do
          text = "Hello ____________________ ."
          pt = PragmaticTokenizer::Tokenizer.new
          expect(pt.tokenize(text)).to eq(["hello", "____________________", "."])
        end

        it 'tokenizes a string #004' do
          text = "It has a state-of-the-art design."
          pt = PragmaticTokenizer::Tokenizer.new
          expect(pt.tokenize(text)).to eq(["it", "has", "a", "state-of-the-art", "design", "."])
        end

        it 'tokenizes a string #005' do
          text = "Jan. 2015 was 20% colder than now. But not in inter- and outer-space."
          pt = PragmaticTokenizer::Tokenizer.new
          expect(pt.tokenize(text)).to eq(["jan.", "2015", "was", "20%", "colder", "than", "now", ".", "but", "not", "in", "inter", "-", "and", "outer-space", "."])
        end

        it 'tokenizes a string #006' do
          text = 'Go to http://www.example.com.'
          pt = PragmaticTokenizer::Tokenizer.new
          expect(pt.tokenize(text)).to eq(["go", "to", "http://www.example.com", "."])
        end

        it 'tokenizes a string #007' do
          text = 'One of the lawyers from ‚Making a Murderer’ admitted a mistake'
          pt = PragmaticTokenizer::Tokenizer.new
          expect(pt.tokenize(text)).to eq(["one", "of", "the", "lawyers", "from", "‚", "making", "a", "murderer", "’", "admitted", "a", "mistake"])
        end

        it 'tokenizes a string #008' do
          text = "One of the lawyers from 'Making a Murderer' admitted a mistake"
          pt = PragmaticTokenizer::Tokenizer.new
          expect(pt.tokenize(text)).to eq(["one", "of", "the", "lawyers", "from", "'", "making", "a", "murderer", "'", "admitted", "a", "mistake"])
        end

        it 'tokenizes a string #009' do
          text = "hello ;-) yes"
          pt = PragmaticTokenizer::Tokenizer.new
          expect(pt.tokenize(text)).to eq(["hello", ";", "-", ")", "yes"])
        end

        it 'tokenizes a string #010' do
          text = "hello ;)"
          pt = PragmaticTokenizer::Tokenizer.new
          expect(pt.tokenize(text)).to eq(["hello", ";", ")"])
        end

        it 'tokenizes a string #011' do
          text = "area &lt;0.8 cm2"
          pt = PragmaticTokenizer::Tokenizer.new
          expect(pt.tokenize(text)).to eq(["area", "<0.8", "cm2"])
        end

        it 'tokenizes a string #012' do
          text = "area <0.8 cm2"
          pt = PragmaticTokenizer::Tokenizer.new
          expect(pt.tokenize(text)).to eq(["area", "<0.8", "cm2"])
        end

        it 'tokenizes a string #013' do
          text = "the “Star-Trek“-Inventor"
          pt = PragmaticTokenizer::Tokenizer.new
          expect(pt.tokenize(text)).to eq(["the", "“", "star-trek", "“", "-", "inventor"])
        end

        it 'tokenizes a string #014' do
          text = "#ab-cd"
          pt = PragmaticTokenizer::Tokenizer.new
          expect(pt.tokenize(text)).to eq(["#ab-cd"])
        end

        it 'handles numbers with symbols 2' do
          text = "Pittsburgh Steelers won 18:16 against Cincinnati Bengals!"
          pt = PragmaticTokenizer::Tokenizer.new
          expect(pt.tokenize(text)).to eq(["pittsburgh", "steelers", "won", "18:16", "against", "cincinnati", "bengals", "!"])
        end

        it 'handles numbers with symbols 3' do
          text = "Hello, that will be $5 dollars. You can pay at 5:00, after it is 500."
          pt = PragmaticTokenizer::Tokenizer.new
          expect(pt.tokenize(text)).to eq(["hello", ",", "that", "will", "be", "$5", "dollars", ".", "you", "can", "pay", "at", "5:00", ",", "after", "it", "is", "500", "."])
        end

        it 'splits at a comma' do
          text = "16.1. day one,17.2. day two"
          pt = PragmaticTokenizer::Tokenizer.new
          expect(pt.tokenize(text)).to eq(["16.1", ".", "day", "one", ",", "17.2", ".", "day", "two"])
        end

        it 'identifies single quotes' do
          text = "Sean Penn Sat for Secret Interview With ‘El Chapo,’ Mexican Drug"
          pt = PragmaticTokenizer::Tokenizer.new
          expect(pt.tokenize(text)).to eq(["sean", "penn", "sat", "for", "secret", "interview", "with", "‘", "el", "chapo", ",", "’", "mexican", "drug"])
        end

        it 'identifies prefixed symbols' do
          text = "look:the sky is blue"
          pt = PragmaticTokenizer::Tokenizer.new
          expect(pt.tokenize(text)).to eq(["look", ":", "the", "sky", "is", "blue"])
        end

        it 'identifies hashtags with numbers too' do
          text = "this is a sentence.#yay this too.#withnumbers123"
          pt = PragmaticTokenizer::Tokenizer.new
          expect(pt.tokenize(text)).to eq(["this", "is", "a", "sentence", ".", "#yay", "this", "too", ".", "#withnumbers123"])
        end

        it 'splits emojis' do
          text = "🤔🙄"
          pt = PragmaticTokenizer::Tokenizer.new
          expect(pt.tokenize(text)).to eq(["🤔", "🙄"])
        end

        it 'handles snowflakes 1' do
          pt = PragmaticTokenizer::Tokenizer.new
          text = "❄️❄️❄️" # "\uFEFF\u2744\uFE0F\u2744\uFE0F\u2744\uFE0F"
          expect(pt.tokenize(text)).to eq(["❄️", "❄️", "❄️"])
        end

        it 'handles snowflakes 2' do
          text = "\u2744\uFE0E\u2744\uFE0E\u2744\uFE0E"
          pt = PragmaticTokenizer::Tokenizer.new
          expect(pt.tokenize(text)).to eq(["❄︎", "❄︎", "❄︎"])
        end

        it 'handles snowflakes 3' do
          text = "\u2744\u2744\u2744"
          pt = PragmaticTokenizer::Tokenizer.new
          expect(pt.tokenize(text)).to eq(["\u2744", "\u2744", "\u2744"])
        end

        it 'handles snowflakes 4' do
          pt = PragmaticTokenizer::Tokenizer.new
          text = "❄❄❄" # "\uFEFF\u2744\u2744\u2744"
          expect(pt.tokenize(text)).to eq(["❄", "❄", "❄"])
        end

        it 'separates tokens' do
          text = "football≠soccer"
          pt = PragmaticTokenizer::Tokenizer.new
          expect(pt.tokenize(text)).to eq(["football", "≠", "soccer"])
        end

        it 'deals with missing whitespaces' do
          text = "this is sentence one!this is sentence two.@someone"
          pt = PragmaticTokenizer::Tokenizer.new
          expect(pt.tokenize(text)).to eq(["this", "is", "sentence", "one", "!", "this", "is", "sentence", "two", ".", "@someone"])
        end

        it 'handles weird apostrophes' do
          text = [116, 104, 101, 114, 101, 32, 769, 115, 32, 115, 111, 109, 101, 116, 104, 105, 110, 103].pack("U*")
          pt = PragmaticTokenizer::Tokenizer.new
          expect(pt.tokenize(text)).to eq(["there`s", "something"])
        end

        it 'treats abbreviations always the same' do
          text = "U.S.A. U.S.A. U.S.A."
          pt = PragmaticTokenizer::Tokenizer.new
          expect(pt.tokenize(text)).to eq(
              ["u.s.a.", "u.s.a.", "u.s.a."]
          )
        end
      end

      context 'user-supplied abbreviations' do
        it 'tokenizes a regular string with an abbreviation' do
          text = "Mr. Smith, hello world."
          pt = PragmaticTokenizer::Tokenizer.new
          expect(pt.tokenize(text)).to eq(["mr.", "smith", ",", "hello", "world", "."])
        end

        it 'fails to recognize an English abbreviation if the user supplies an abbreviations array without it' do
          text = "Mr. Smith, hello world."
          abbreviations = ['mrs']
          pt = PragmaticTokenizer::Tokenizer.new(
              abbreviations: abbreviations
          )
          expect(pt.tokenize(text)).to eq(["mr", ".", "smith", ",", "hello", "world", "."])
        end

        it 'recognizes a user-supplied abbreviation' do
          text = "thisisnotanormalabbreviation. hello world."
          abbreviations = ['thisisnotanormalabbreviation']
          pt = PragmaticTokenizer::Tokenizer.new(
              abbreviations: abbreviations
          )
          expect(pt.tokenize(text)).to eq(["thisisnotanormalabbreviation.", "hello", "world", "."])
        end

        it 'handles an empty user-supplied abbreviation array' do
          text = "thisisnotanormalabbreviation. hello world."
          abbreviations = []
          pt = PragmaticTokenizer::Tokenizer.new(
              abbreviations: abbreviations
          )
          expect(pt.tokenize(text)).to eq(["thisisnotanormalabbreviation", ".", "hello", "world", "."])
        end

        it 'handles abrreviations across multiple languages' do
          text = "Mr. Smith how are ü. today."
          pt = PragmaticTokenizer::Tokenizer.new(
              filter_languages: [:en, :de]
          )
          expect(pt.tokenize(text)).to eq(["mr.", "smith", "how", "are", "ü.", "today", "."])
        end

        it 'handles abrreviations across multiple languages and user-supplied abbreviations' do
          text = "Adj. Smith how are ü. today. thisisnotanormalabbreviation. is it?"
          abbreviations = ['thisisnotanormalabbreviation']
          pt = PragmaticTokenizer::Tokenizer.new(
              filter_languages: [:en, :de],
              abbreviations:    abbreviations
          )
          expect(pt.tokenize(text)).to eq(["adj.", "smith", "how", "are", "ü.", "today", ".", "thisisnotanormalabbreviation.", "is", "it", "?"])
        end
      end

      context 'option (expand_contractions)' do
        it 'does not expand the contractions' do
          # https://www.ibm.com/developerworks/community/blogs/nlp/entry/tokenization?lang=en
          text = "\"I said, 'what're you? Crazy?'\" said Sandowsky. \"I can't afford to do that.\""
          pt = PragmaticTokenizer::Tokenizer.new
          expect(pt.tokenize(text)).to eq(['"', 'i', 'said', ',', "'", "what're", 'you', '?', 'crazy', '?', "'", '"', 'said', 'sandowsky', '.', '"', 'i', "can't", 'afford', 'to', 'do', 'that', '.', '"'])
        end

        it 'expands user-supplied contractions' do
          text = "Hello supa'soo guy."
          contractions = { "supa'soo" => "super smooth" }
          pt = PragmaticTokenizer::Tokenizer.new(
              contractions:        contractions,
              expand_contractions: true
          )
          expect(pt.tokenize(text)).to eq(["hello", "super", "smooth", "guy", "."])
        end

        it 'does not expands user-supplied contractions' do
          text = "Hello supa'soo guy."
          contractions = { "supa'soo" => "super smooth" }
          pt = PragmaticTokenizer::Tokenizer.new(
              contractions:        contractions,
              expand_contractions: false
          )
          expect(pt.tokenize(text)).to eq(["hello", "supa'soo", "guy", "."])
        end

        it 'expands user-supplied contractions and language contractions' do
          text = "Hello supa'soo guy. auf's wasn't it?"
          contractions = { "supa'soo" => "super smooth" }
          pt = PragmaticTokenizer::Tokenizer.new(
              contractions:        contractions,
              expand_contractions: true,
              filter_languages:    [:en, :de]
          )
          expect(pt.tokenize(text)).to eq(["hello", "super", "smooth", "guy", ".", "auf", "das", "was", "not", "it", "?"])
        end

        it 'expands language contractions' do
          text = "Hello supa'soo guy. auf's wasn't it?"
          pt = PragmaticTokenizer::Tokenizer.new(
              expand_contractions: true,
              filter_languages:    [:en, :de]
          )
          expect(pt.tokenize(text)).to eq(["hello", "supa'soo", "guy", ".", "auf", "das", "was", "not", "it", "?"])
        end

        it 'tokenizes a string #001' do
          # https://www.ibm.com/developerworks/community/blogs/nlp/entry/tokenization?lang=en
          text = "\"I said, 'what're you? Crazy?'\" said Sandowsky. \"I can't afford to do that.\""
          pt = PragmaticTokenizer::Tokenizer.new(
              expand_contractions: true
          )
          expect(pt.tokenize(text)).to eq(['"', 'i', 'said', ',', "'", 'what', 'are', 'you', '?', 'crazy', '?', "'", '"', 'said', 'sandowsky', '.', '"', 'i', 'cannot', 'afford', 'to', 'do', 'that', '.', '"'])
        end

        it 'tokenizes a string #002' do
          # http://nlp.stanford.edu/software/tokenizer.shtml
          text = "\"Oh, no,\" she's saying, \"our $400 blender can't handle something this hard!\""
          pt = PragmaticTokenizer::Tokenizer.new(
              expand_contractions: true
          )
          expect(pt.tokenize(text)).to eq(['"', 'oh', ',', 'no', ',', '"', 'she', 'is', 'saying', ',', '"', 'our', '$400', 'blender', 'cannot', 'handle', 'something', 'this', 'hard', '!', '"'])
        end

        it 'tokenizes a string #003' do
          text = "Look for his/her account."
          pt = PragmaticTokenizer::Tokenizer.new(
              expand_contractions: true
          )
          expect(pt.tokenize(text)).to eq(["look", "for", "his/her", "account", "."])
        end

        it 'tokenizes a string #004' do
          text = "I like apples and/or oranges."
          pt = PragmaticTokenizer::Tokenizer.new(
              expand_contractions: true
          )
          expect(pt.tokenize(text)).to eq(["i", "like", "apples", "and/or", "oranges", "."])
        end
      end

      context 'option (emojis)' do
        it 'removes emoji' do
          text = "Return the emoji 👿😍😱🐔🌚. 🌚"
          pt = PragmaticTokenizer::Tokenizer.new(
              remove_emoji: true
          )
          expect(pt.tokenize(text)).to eq(["return", "the", "emoji", "."])
        end

        it 'does not remove emoji' do
          text = "Return the emoji 👿😍😱🐔🌚. 🌚"
          pt = PragmaticTokenizer::Tokenizer.new
          expect(pt.tokenize(text)).to eq(["return", "the", "emoji", "👿", "😍", "😱", "🐔", "🌚", ".", "🌚"])
        end

        it 'removes snowflakes 1' do
          text = "hello❄️❄️❄️"
          pt = PragmaticTokenizer::Tokenizer.new(
              remove_emoji: true
          )
          expect(pt.tokenize(text)).to eq(["hello"])
        end

        it 'removes snowflakes 2' do
          text = "hello\u2744\uFE0E\u2744\uFE0E\u2744\uFE0E"
          pt = PragmaticTokenizer::Tokenizer.new(
              remove_emoji: true
          )
          expect(pt.tokenize(text)).to eq(["hello"])
        end

        it 'removes snowflakes 3' do
          text = "hello\u2744\u2744\u2744"
          pt = PragmaticTokenizer::Tokenizer.new(
              remove_emoji: true
          )
          expect(pt.tokenize(text)).to eq(["hello"])
        end
      end

      context 'option (hashtags)' do
        it 'tokenizes a string #001' do
          text = "This is a #hashtag yay!"
          pt = PragmaticTokenizer::Tokenizer.new(
              hashtags: :remove
          )
          expect(pt.tokenize(text)).to eq(["this", "is", "a", "yay", "!"])
        end

        it 'tokenizes a string #002' do
          text = "This is a #hashtag yay!"
          pt = PragmaticTokenizer::Tokenizer.new(
              hashtags: :keep_and_clean
          )
          expect(pt.tokenize(text)).to eq(["this", "is", "a", "hashtag", "yay", "!"])
        end

        it 'tokenizes a string #003' do
          text = "This is a #hashtag yay!"
          pt = PragmaticTokenizer::Tokenizer.new(
              hashtags: :keep_original
          )
          expect(pt.tokenize(text)).to eq(["this", "is", "a", "#hashtag", "yay", "!"])
        end
      end

      context 'option (mentions)' do
        it 'tokenizes a string #001' do
          text = "This is a @mention ＠mention2 yay!"
          pt = PragmaticTokenizer::Tokenizer.new(
              mentions: :remove
          )
          expect(pt.tokenize(text)).to eq(["this", "is", "a", "yay", "!"])
        end

        it 'tokenizes a string #002' do
          text = "This is a @mention ＠mention2 yay!"
          pt = PragmaticTokenizer::Tokenizer.new(
              mentions: :keep_and_clean
          )
          expect(pt.tokenize(text)).to eq(["this", "is", "a", "mention", "mention2", "yay", "!"])
        end

        it 'tokenizes a string #003' do
          text = "This is a @mention ＠mention2 yay!"
          pt = PragmaticTokenizer::Tokenizer.new(
              mentions: :keep_original
          )
          expect(pt.tokenize(text)).to eq(["this", "is", "a", "@mention", "＠mention2", "yay", "!"])
        end
      end

      context 'option (email addresses)' do
        it 'tokenizes a string #001' do
          text = "Here are some emails jon@hotmail.com ben123＠gmail.com."
          pt = PragmaticTokenizer::Tokenizer.new(
              remove_emails: :true
          )
          expect(pt.tokenize(text)).to eq(["here", "are", "some", "emails", "."])
        end

        it 'tokenizes a string #002' do
          text = "Here are some emails jon@hotmail.com ben123＠gmail.com."
          pt = PragmaticTokenizer::Tokenizer.new
          expect(pt.tokenize(text)).to eq(["here", "are", "some", "emails", "jon@hotmail.com", "ben123＠gmail.com", "."])
        end

        it 'knows what is not an email address' do
          text = "the great cook.@someone something else@whoever"
          pt = PragmaticTokenizer::Tokenizer.new(
              remove_emails: true
          )
          expect(pt.tokenize(text)).to eq(["the", "great", "cook", ".", "@someone", "something", "else@whoever"])
        end
      end

      context 'option (urls)' do
        it 'tokenizes a string #001' do
          text = "Here are some domains and urls google.com https://www.google.com www.google.com."
          pt = PragmaticTokenizer::Tokenizer.new(
              remove_urls: :true
          )
          expect(pt.tokenize(text)).to eq(["here", "are", "some", "domains", "and", "urls", "google.com", "www.google.com", "."])
        end

        it 'tokenizes a string #002' do
          text = "Here are some domains and urls google.com https://www.google.com www.google.com."
          pt = PragmaticTokenizer::Tokenizer.new
          expect(pt.tokenize(text)).to eq(["here", "are", "some", "domains", "and", "urls", "google.com", "https://www.google.com", "www.google.com", "."])
        end
      end

      context 'option (downcase)' do
        it 'does not downcase URLs' do
          skip "NOT IMPLEMENTED"
          text = "Here are some domains and urls GOOGLE.com http://test.com/UPPERCASE."
          pt = PragmaticTokenizer::Tokenizer.new(
              downcase: :true
          )
          expect(pt.tokenize(text)).to eq(["here", "are", "some", "domains", "and", "urls", "GOOGLE.com", "http://test.com/UPPERCASE", "."])
        end
      end

      context 'option (domains)' do
        it 'tokenizes a string #001' do
          text = "Here are some domains and urls google.com https://www.google.com www.google.com."
          pt = PragmaticTokenizer::Tokenizer.new(
              remove_domains: :true
          )
          expect(pt.tokenize(text)).to eq(["here", "are", "some", "domains", "and", "urls", "https://www.google.com", "."])
        end

        it 'tokenizes a string #002' do
          text = "Here are some domains and urls google.com https://www.google.com www.google.com."
          pt = PragmaticTokenizer::Tokenizer.new
          expect(pt.tokenize(text)).to eq(["here", "are", "some", "domains", "and", "urls", "google.com", "https://www.google.com", "www.google.com", "."])
        end

        it 'knows what is not a domain 1' do
          skip "NOT IMPLEMENTED"
          text = "this is a sentence.and no domain."
          pt = PragmaticTokenizer::Tokenizer.new(
              remove_domains: true
          )
          expect(pt.tokenize(text)).to eq(["this", "is", "a", "sentence", ".", "and", "no", "domain", "."])
        end

        it 'knows what is not a domain 2' do
          text = "former president g.w.bush was..."
          pt = PragmaticTokenizer::Tokenizer.new(
              remove_domains: true
          )
          expect(pt.tokenize(text)).to eq(["former", "president", "g.w.bush", "was", "..."])
        end

        it 'knows what is not a domain 3' do
          text = "2.something-times"
          pt = PragmaticTokenizer::Tokenizer.new(
              remove_domains: true
          )
          expect(pt.tokenize(text)).to eq(["2.something-times"])
        end
      end

      context 'option (long_word_split)' do
        it 'should not split twitter handles' do
          text = "@john_doe"
          pt = PragmaticTokenizer::Tokenizer.new(
              long_word_split: 5
          )
          expect(pt.tokenize(text)).to eq(["@john_doe"])
        end

        it 'should not split emails' do
          text = "john_doe@something.com"
          pt = PragmaticTokenizer::Tokenizer.new(
              long_word_split: 5
          )
          expect(pt.tokenize(text)).to eq(["john_doe@something.com"])
        end

        it 'should not split emails 2' do
          text = "john_doe＠something.com"
          pt = PragmaticTokenizer::Tokenizer.new(
              long_word_split: 5
          )
          expect(pt.tokenize(text)).to eq(["john_doe＠something.com"])
        end

        it 'should not split urls' do
          text = "http://test.com/some_path"
          pt = PragmaticTokenizer::Tokenizer.new(
              long_word_split: 5
          )
          expect(pt.tokenize(text)).to eq(["http://test.com/some_path"])
        end

        it 'tokenizes a string #001' do
          text = "Some main-categories of the mathematics-test have sub-examples that most 14-year olds can't answer, therefor the implementation-instruction made in the 1990-years needs to be revised."
          pt = PragmaticTokenizer::Tokenizer.new(
              long_word_split: 10
          )
          expect(pt.tokenize(text)).to eq(["some", "main", "categories", "of", "the", "mathematics", "test", "have", "sub", "examples", "that", "most", "14-year", "olds", "can't", "answer", ",", "therefor", "the", "implementation", "instruction", "made", "in", "the", "1990-years", "needs", "to", "be", "revised", "."])
        end

        it 'tokenizes a string #002' do
          text = "Some main-categories of the mathematics-test have sub-examples that most 14-year olds can't answer, therefor the implementation-instruction made in the 1990-years needs to be revised."
          pt = PragmaticTokenizer::Tokenizer.new(
              long_word_split: 4
          )
          expect(pt.tokenize(text)).to eq(["some", "main", "categories", "of", "the", "mathematics", "test", "have", "sub", "examples", "that", "most", "14", "year", "olds", "can't", "answer", ",", "therefor", "the", "implementation", "instruction", "made", "in", "the", "1990", "years", "needs", "to", "be", "revised", "."])
        end
      end

      context 'option (clean)' do
        it 'tokenizes a string #001' do
          text = "Hello ---------------."
          pt = PragmaticTokenizer::Tokenizer.new(
              clean: true
          )
          expect(pt.tokenize(text)).to eq(["hello", "."])
        end

        it 'tokenizes a string #002' do
          text = "Hello ____________________ ."
          pt = PragmaticTokenizer::Tokenizer.new(
              clean: true
          )
          expect(pt.tokenize(text)).to eq(["hello", "."])
        end

        it 'tokenizes a string #003' do
          text = "© ABC Company 1994"
          pt = PragmaticTokenizer::Tokenizer.new(
              clean: true
          )
          expect(pt.tokenize(text)).to eq(%w(abc company 1994))
        end

        it 'tokenizes a string #004' do
          text = "This sentence has a long string of dots ......................."
          pt = PragmaticTokenizer::Tokenizer.new(
              clean: true
          )
          expect(pt.tokenize(text)).to eq(%w(this sentence has a long string of dots))
        end

        it 'tokenizes a string #005' do
          text = "cnn.com mentions this *funny* #hashtag used by @obama http://cnn.com/something"
          pt = PragmaticTokenizer::Tokenizer.new(
              clean: true
          )
          expect(pt.tokenize(text)).to eq(["cnn.com", "mentions", "this", "funny", "#hashtag", "used", "by", "@obama", "http://cnn.com/something"])
        end

        it 'does not remove a valid hashtag' do
          text = "This #sentence has a long string of dots ......................."
          pt = PragmaticTokenizer::Tokenizer.new(
              clean: true
          )
          expect(pt.tokenize(text)).to eq(["this", "#sentence", "has", "a", "long", "string", "of", "dots"])
        end

        it 'does not remove a valid mention' do
          text = "This @sentence has a long string of dots ......................."
          pt = PragmaticTokenizer::Tokenizer.new(
              clean: true
          )
          expect(pt.tokenize(text)).to eq(["this", "@sentence", "has", "a", "long", "string", "of", "dots"])
        end

        it 'cleans words with symbols 1' do
          text = "something.com:article title !!wow look!!1"
          pt = PragmaticTokenizer::Tokenizer.new(
              clean: true
          )
          expect(pt.tokenize(text)).to eq(["something.com", "article", "title", "wow", "look"])
        end

        it 'cleans words with symbols 2' do
          text = "something.com:article title !!wow look!!1!1!11!"
          pt = PragmaticTokenizer::Tokenizer.new(
              clean: true
          )
          expect(pt.tokenize(text)).to eq(["something.com", "article", "title", "wow", "look"])
        end

        it 'identifies prefixed symbols' do
          text = "look:the sky is blue"
          pt = PragmaticTokenizer::Tokenizer.new(
              clean: true
          )
          expect(pt.tokenize(text)).to eq(%w(look the sky is blue))
        end

        it 'keeps numbers at the end of mentions and hashtags' do
          text = "#le1101 #artistQ21 @someone12 @someoneelse1 and @somebody1980"
          pt = PragmaticTokenizer::Tokenizer.new(
              clean: true
          )
          expect(pt.tokenize(text)).to eq(["#le1101", "#artistQ21", "@someone12", "@someoneelse1", "and", "@somebody1980"])
        end

        it 'cleans a prefixed weird hyphen' do
          text = [104, 105, 103, 104, 32, 173, 116, 101, 109, 112, 101, 114, 97, 116, 117, 114, 101, 32, 97, 110, 100, 32, 173, 119, 105, 110, 100].pack("U*")
          pt = PragmaticTokenizer::Tokenizer.new(
              clean: true
          )
          expect(pt.tokenize(text)).to eq(%w(high temperature and wind))
        end

        it 'cleans (r) and (c) and (tm)' do
          text = "the oscar® night ©companyname is a trademark™"
          pt = PragmaticTokenizer::Tokenizer.new(
              clean: true
          )
          expect(pt.tokenize(text)).to eq(%w(the oscar night companyname is a trademark))
        end

        it 'cleans letters in boxes 1' do
          text = "making🇦🇹postcards"
          pt = PragmaticTokenizer::Tokenizer.new(
              clean: true
          )
          expect(pt.tokenize(text)).to eq(%w(making 🇦🇹 postcards))
        end

        it 'removes colons' do
          text = "At 19:30 o'clock: Mad Max: Fury Road"
          pt = PragmaticTokenizer::Tokenizer.new(
              clean: true
          )
          expect(pt.tokenize(text)).to eq(["at", "19:30", "o'clock", "mad", "max", "fury", "road"])
        end

        it 'removes a hyphen prefix 3' do
          text = "women's clothes and –shoes needed"
          pt = PragmaticTokenizer::Tokenizer.new(
              clean: true
          )
          expect(pt.tokenize(text)).to eq(["women's", "clothes", "and", "shoes", "needed"])
        end

        it 'does not remove tokens with ampersands' do
          text = "you&amp;me"
          pt = PragmaticTokenizer::Tokenizer.new(
              clean: true
          )
          expect(pt.tokenize(text)).to eq(["you&me"])
        end
      end

      context 'option (classic_filter)' do
        it 'tokenizes a string #001' do
          # http://wiki.apache.org/solr/AnalyzersTokenizersTokenFilters#solr.ClassicFilterFactory
          text = "I.B.M. cat's can't"
          pt = PragmaticTokenizer::Tokenizer.new(
              classic_filter: true
          )
          expect(pt.tokenize(text)).to eq(["ibm", "cat", "can't"])
        end

        it 'tokenizes a string #002' do
          # http://wiki.apache.org/solr/AnalyzersTokenizersTokenFilters#solr.ClassicFilterFactory
          text = "St.Veit, which usually would be written St. Veit was not visited by B.Obama reported CNN.com"
          pt = PragmaticTokenizer::Tokenizer.new(
              classic_filter: true
          )
          expect(pt.tokenize(text)).to eq(["st.veit", ",", "which", "usually", "would", "be", "written", "st", "veit", "was", "not", "visited", "by", "b.obama", "reported", "cnn.com"])
        end

        it 'optimizes the classic filter' do
          text = "therés something"
          pt = PragmaticTokenizer::Tokenizer.new(
              classic_filter: true
          )
          expect(pt.tokenize(text)).to eq(%w(there something))
        end

        it 'optimizes the classic filter' do
          text = [116, 104, 101, 114, 101, 32, 769, 115, 32, 115, 111, 109, 101, 116, 104, 105, 110, 103].pack("U*")
          pt = PragmaticTokenizer::Tokenizer.new(
              classic_filter: true
          )
          expect(pt.tokenize(text)).to eq(%w(there something))
        end
      end

      context 'option (language)' do
        it 'tokenizes a string #001' do
          text = "Hello Ms. Piggy, this is John. We are selling a new fridge for $5,000. That is a 20% discount over the Nev. retailers. It is a 'MUST BUY', so don't hesistate."
          pt = PragmaticTokenizer::Tokenizer.new(
              language: 'en'
          )
          expect(pt.tokenize(text)).to eq(["hello", "ms.", "piggy", ",", "this", "is", "john", ".", "we", "are", "selling", "a", "new", "fridge", "for", "$5,000", ".", "that", "is", "a", "20%", "discount", "over", "the", "nev.", "retailers", ".", "it", "is", "a", "'", "must", "buy", "'", ",", "so", "don't", "hesistate", "."])
        end

        it 'tokenizes a string #002' do
          text = "Lisa Raines, a lawyer and director of government relations
            for the Industrial Biotechnical Association, contends that a judge
            well-versed in patent law and the concerns of research-based industries
            would have ruled otherwise. And Judge Newman, a former patent lawyer,
            wrote in her dissent when the court denied a motion for a rehearing of
            the case by the full court, \'The panel's judicial legislation has
            affected an important high-technological industry, without regard
            to the consequences for research and innovation or the public interest.\'
            Says Ms. Raines, \'[The judgement] confirms our concern that the absence of
            patent lawyers on the court could prove troublesome.\'"
          pt = PragmaticTokenizer::Tokenizer.new(
              language: 'en'
          )
          expect(pt.tokenize(text)).to eq(['lisa', 'raines', ',', 'a', 'lawyer', 'and', 'director', 'of', 'government', 'relations', 'for', 'the', 'industrial', 'biotechnical', 'association', ',', 'contends', 'that', 'a', 'judge', 'well-versed', 'in', 'patent', 'law', 'and', 'the', 'concerns', 'of', 'research-based', 'industries', 'would', 'have', 'ruled', 'otherwise', '.', 'and', 'judge', 'newman', ',', 'a', 'former', 'patent', 'lawyer', ',', 'wrote', 'in', 'her', 'dissent', 'when', 'the', 'court', 'denied', 'a', 'motion', 'for', 'a', 'rehearing', 'of', 'the', 'case', 'by', 'the', 'full', 'court', ',', "\'", 'the', "panel's", 'judicial', 'legislation', 'has', 'affected', 'an', 'important', 'high-technological', 'industry', ',', 'without', 'regard', 'to', 'the', 'consequences', 'for', 'research', 'and', 'innovation', 'or', 'the', 'public', 'interest', '.', '\'', 'says', 'ms.', 'raines', ',', '\'', '[', 'the', 'judgement', ']', 'confirms', 'our', 'concern', 'that', 'the', 'absence', 'of', 'patent', 'lawyers', 'on', 'the', 'court', 'could', 'prove', 'troublesome', '.', "\'"])
        end
      end

      context 'option (numbers)' do
        it 'tokenizes a string #001' do
          text = "Hello, that will be $5 dollars. You can pay at 5:00, after it is 500."
          pt = PragmaticTokenizer::Tokenizer.new(
              numbers: :all
          )
          expect(pt.tokenize(text)).to eq(["hello", ",", "that", "will", "be", "$5", "dollars", ".", "you", "can", "pay", "at", "5:00", ",", "after", "it", "is", "500", "."])
        end

        it 'tokenizes a string #002' do
          text = "Hello, that will be $5 dollars. You can pay at 5:00, after it is 500."
          pt = PragmaticTokenizer::Tokenizer.new(
              numbers: :none
          )
          expect(pt.tokenize(text)).to eq(["hello", ",", "that", "will", "be", "dollars", ".", "you", "can", "pay", "at", ",", "after", "it", "is", "."])
        end

        it 'tokenizes a string #003' do
          text = "2pac U2 50cent blink-182 $500 zero7 M83 B-52s 500"
          pt = PragmaticTokenizer::Tokenizer.new(
              numbers: :semi
          )
          expect(pt.tokenize(text)).to eq(["2pac", "u2", "50cent", "blink-182", "$500", "zero7", "m83", "b-52s"])
        end

        it 'tokenizes a string #004' do
          text = "2pac U2 50cent blink-182 zero7 M83 B-52s 500 Hello"
          pt = PragmaticTokenizer::Tokenizer.new(
              numbers: :only
          )
          expect(pt.tokenize(text)).to eq(["2pac", "u2", "50cent", "blink-182", "zero7", "m83", "b-52s", "500"])
        end

        it 'tokenizes a string #005' do
          text = "2pac U2 50cent blink-182 $500 zero7 M83 B-52s 500"
          pt = PragmaticTokenizer::Tokenizer.new(
              numbers: :none
          )
          expect(pt.tokenize(text)).to eq([])
        end

        it 'tokenizes a string #005' do
          text = "2pac U2 50cent blink-182 $500 zero7 M83 B-52s 500 number iv VI"
          pt = PragmaticTokenizer::Tokenizer.new(
              numbers: :none
          )
          expect(pt.tokenize(text)).to eq(["number"])
        end

        it 'tokenizes a string #006' do
          text = "Remove III Roman Numerals and IX. with a period."
          pt = PragmaticTokenizer::Tokenizer.new(
              numbers: :none
          )
          expect(pt.tokenize(text)).to eq(["remove", "roman", "numerals", "and", ".", "with", "a", "period", "."])
        end
      end

      context 'option (minimum_length)' do
        it 'tokenizes a string #001' do
          text = "Let's test the minimum length of fiver."
          pt = PragmaticTokenizer::Tokenizer.new(
              minimum_length: 5
          )
          expect(pt.tokenize(text)).to eq(["let's", "minimum", "length", "fiver"])
        end
      end

      context 'option (punctuation)' do
        it 'tokenizes a string #001' do
          text = "kath. / evang"
          pt = PragmaticTokenizer::Tokenizer.new(
              punctuation: 'none'
          )
          expect(pt.tokenize(text)).to eq(%w(kath evang))
        end

        it 'tokenizes a string #002' do
          text = "derStandard.at › Sport"
          pt = PragmaticTokenizer::Tokenizer.new(
              punctuation: 'none'
          )
          expect(pt.tokenize(text)).to eq(["derstandard.at", "sport"])
        end

        it 'tokenizes a string #003' do
          text = "hello ^^"
          pt = PragmaticTokenizer::Tokenizer.new(
              punctuation: 'none'
          )
          expect(pt.tokenize(text)).to eq(["hello"])
        end

        it 'tokenizes a string #004' do
          text = "This hyphen – is not...or is it? ... It's a - dash... And a horizontal ellipsis…"
          pt = PragmaticTokenizer::Tokenizer.new(
              punctuation: 'none'
          )
          expect(pt.tokenize(text)).to eq(["this", "hyphen", "is", "not", "or", "is", "it", "it's", "a", "dash", "and", "a", "horizontal", "ellipsis"])
        end

        it 'tokenizes a string #005' do
          text = "A sentence. One with two dots.. And with three... Or horizontal ellipsis… which are three dots too."
          pt = PragmaticTokenizer::Tokenizer.new(
              punctuation: 'none'
          )
          expect(pt.tokenize(text)).to eq(%w(a sentence one with two dots and with three or horizontal ellipsis which are three dots too))
        end

        it 'tokenizes a string #006' do
          text = "+++ BREAKING +++ something happened; is it interesting?"
          pt = PragmaticTokenizer::Tokenizer.new(
              punctuation: 'none'
          )
          expect(pt.tokenize(text)).to eq(%w(breaking something happened is it interesting))
        end

        it 'tokenizes a string #007' do
          text = "Some *interesting stuff* is __happening here__"
          pt = PragmaticTokenizer::Tokenizer.new(
              punctuation: 'none'
          )
          expect(pt.tokenize(text)).to eq(["some", "*interesting", "stuff*", "is", "__happening", "here__"])
        end

        it 'tokenizes a string #008' do
          text = "Hello; what is your: name @username **delete**"
          pt = PragmaticTokenizer::Tokenizer.new(
              punctuation: 'none'
          )
          expect(pt.tokenize(text)).to eq(["hello", "what", "is", "your", "name", "@username", "**delete**"])
        end

        it 'tokenizes a string #009' do
          text = "hello ;-) yes"
          pt = PragmaticTokenizer::Tokenizer.new(
              punctuation: :none
          )
          expect(pt.tokenize(text)).to eq(%w(hello yes))
        end

        it 'tokenizes a string #010' do
          text = "hello ;)"
          pt = PragmaticTokenizer::Tokenizer.new(
              punctuation: 'none'
          )
          expect(pt.tokenize(text)).to eq(["hello"])
        end

        it 'tokenizes a string #011' do
          text = "Hello ____________________ ."
          pt = PragmaticTokenizer::Tokenizer.new(
              punctuation: :none
          )
          expect(pt.tokenize(text)).to eq(["hello"])
        end

        it 'handles non-domain words with a dot 1' do
          text = "They were being helped.This is solidarity."
          pt = PragmaticTokenizer::Tokenizer.new(
              punctuation: 'none'
          )
          expect(pt.tokenize(text)).to eq(%w(they were being helped this is solidarity))
        end

        it 'handles non-domain words with a dot 2' do
          text = "picture was taken in sept.2015"
          pt = PragmaticTokenizer::Tokenizer.new(
              punctuation: 'none'
          )
          expect(pt.tokenize(text)).to eq(["picture", "was", "taken", "in", "sept.", "2015"])
        end

        it 'handles non-domain words with a dot 3' do
          text = "They were being helped.This is solidarity. See the breaking news stories about X on cnn.com/europe and english.alarabiya.net, here’s a screenshot: https://t.co/s83k28f29d31s83"
          pt = PragmaticTokenizer::Tokenizer.new(
              punctuation: 'none'
          )
          expect(pt.tokenize(text)).to eq(["they", "were", "being", "helped", "this", "is", "solidarity", "see", "the", "breaking", "news", "stories", "about", "x", "on", "cnn.com/europe", "and", "english.alarabiya.net", "here’s", "a", "screenshot", "https://t.co/s83k28f29d31s83"])
        end

        it 'handles numbers with symbols 1' do
          text = "Pittsburgh Steelers won 18:16 against Cincinnati Bengals!"
          pt = PragmaticTokenizer::Tokenizer.new(
              punctuation: 'none'
          )
          expect(pt.tokenize(text)).to eq(["pittsburgh", "steelers", "won", "18:16", "against", "cincinnati", "bengals"])
        end

        it 'handles numbers with symbols 2' do
          text = "Pittsburgh Steelers won 18:16 against Cincinnati Bengals!"
          pt = PragmaticTokenizer::Tokenizer.new(
              punctuation: 'none'
          )
          expect(pt.tokenize(text)).to eq(["pittsburgh", "steelers", "won", "18:16", "against", "cincinnati", "bengals"])
        end

        it 'handles apostrophes and quotes' do
          text = "“Data Visualization: How to Tell Stories with Data — Jeff Korhan” by @AINewsletter"
          pt = PragmaticTokenizer::Tokenizer.new(
              punctuation: 'none'
          )
          expect(pt.tokenize(text)).to eq(["data", "visualization", "how", "to", "tell", "stories", "with", "data", "jeff", "korhan", "by", "@AINewsletter"])
        end

        it 'handles mentions' do
          text = ".@someone I disagree"
          pt = PragmaticTokenizer::Tokenizer.new(
              punctuation: 'none'
          )
          expect(pt.tokenize(text)).to eq(["@someone", "i", "disagree"])
        end

        it 'handles old school emoticons 2' do
          text = "oooh! <3"
          pt = PragmaticTokenizer::Tokenizer.new(
              punctuation: 'none'
          )
          expect(pt.tokenize(text)).to eq(["oooh", "<3"])
        end

        it 'handles old school emoticons 3' do
          text = "@someone &lt;33"
          pt = PragmaticTokenizer::Tokenizer.new(
              punctuation: 'none'
          )
          expect(pt.tokenize(text)).to eq(["@someone", "<33"])
        end

        it 'handles words with a symbol prefix 1' do
          text = "Yes! /cc @someone"
          pt = PragmaticTokenizer::Tokenizer.new(
              punctuation: 'none'
          )
          expect(pt.tokenize(text)).to eq(["yes", "cc", "@someone"])
        end

        it 'handles words with a emoji suffix' do
          text = "Let's meet there.😝 ok?"
          pt = PragmaticTokenizer::Tokenizer.new(
              punctuation: 'none'
          )
          expect(pt.tokenize(text)).to eq(["let's", "meet", "there", "😝", "ok"])
        end

        it 'handles words with a symbol prefix 2' do
          text = "blah blah |photo by @someone"
          pt = PragmaticTokenizer::Tokenizer.new(
              punctuation: 'none'
          )
          expect(pt.tokenize(text)).to eq(["blah", "blah", "photo", "by", "@someone"])
        end

        it 'handles pseudo-contractions' do
          text = "I suggest to buy stocks that are low value+have momentum"
          pt = PragmaticTokenizer::Tokenizer.new(
              punctuation: 'none'
          )
          expect(pt.tokenize(text)).to eq(%w(i suggest to buy stocks that are low value have momentum))
        end

        it 'handles apostrophes and quotes 1' do
          text = "Watch the video of @amandapalmer's song “Killing Type” here"
          pt = PragmaticTokenizer::Tokenizer.new(
              punctuation: 'none'
          )
          expect(pt.tokenize(text)).to eq(["watch", "the", "video", "of", "@amandapalmer's", "song", "killing", "type", "here"])
        end

        it 'handles apostrophes and quotes 2' do
          text = "Watch the video of @amandapalmer`s song “Killing Type” here"
          pt = PragmaticTokenizer::Tokenizer.new(
              punctuation: 'none'
          )
          expect(pt.tokenize(text)).to eq(["watch", "the", "video", "of", "@amandapalmer`s", "song", "killing", "type", "here"])
        end

        it 'handles numbers suffixed with a symbol' do
          text = "4 Things Marketers Must Do Better in 2016: blah"
          pt = PragmaticTokenizer::Tokenizer.new(
              punctuation: 'none'
          )
          expect(pt.tokenize(text)).to eq(%w(4 things marketers must do better in 2016 blah))
        end

        it 'handles words with a emoticon suffix' do
          skip "NOT IMPLEMENTED"
          text = "look, a dog with shoes☺ !!"
          pt = PragmaticTokenizer::Tokenizer.new(
              punctuation: 'none'
          )
          expect(pt.tokenize(text)).to eq(["look", "a", "dog", "with", "shoes", "☺"])
        end

        it 'handles emoji 1' do
          text = "How bad!😝"
          pt = PragmaticTokenizer::Tokenizer.new(
              punctuation: 'none'
          )
          expect(pt.tokenize(text)).to eq(["how", "bad", "😝"])
        end

        it 'handles emoji 2' do
          text = "😝😝How bad!"
          pt = PragmaticTokenizer::Tokenizer.new(
              punctuation: 'none'
          )
          expect(pt.tokenize(text)).to eq(["😝", "😝", "how", "bad"])
        end

        it 'identifies old school emoticons' do
          skip "NOT IMPLEMENTED"
          text = 'looking forward to the new kodak super8 camera \o/'
          pt = PragmaticTokenizer::Tokenizer.new(
              punctuation: 'none'
          )
          expect(pt.tokenize(text)).to eq(["looking", "forward", "to", "the", "new", "kodak", "super8", "camera", '\o/'])
        end

        it 'splits at hashtags' do
          text = "some sentence#RT ... i like u2.#bono"
          pt = PragmaticTokenizer::Tokenizer.new(
              punctuation: :none
          )
          expect(pt.tokenize(text)).to eq(["some", "sentence", "#RT", "i", "like", "u2", "#bono"])
        end
      end

      context 'option (remove_stop_words)' do
        it 'removes stop words' do
          text = 'This is a short sentence with explanations and stop words.'
          pt = PragmaticTokenizer::Tokenizer.new(
              language:          'en',
              remove_stop_words: true
          )
          expect(pt.tokenize(text)).to eq(["short", "sentence", "explanations", "."])
        end

        it 'removes stop words 2' do
          text = 'This is a short sentence with explanations and stop words i.e. is a stop word as so is e.g. I think.'
          pt = PragmaticTokenizer::Tokenizer.new(
              language:          'en',
              remove_stop_words: true
          )
          expect(pt.tokenize(text)).to eq(["short", "sentence", "explanations", "."])
        end

        it 'removes user-supplied stop words' do
          text = 'This is a short sentence with explanations and stop words.'
          pt = PragmaticTokenizer::Tokenizer.new(
              language:          'en',
              remove_stop_words: true,
              stop_words:        %w(and a)
          )
          expect(pt.tokenize(text)).to eq(["this", "is", "short", "sentence", "with", "explanations", "stop", "words", "."])
        end

        it 'removes user-supplied stop words and default stop words' do
          text = 'This is a short sentence with explanations and stop words.'
          pt = PragmaticTokenizer::Tokenizer.new(
              language:          'en',
              remove_stop_words: true,
              stop_words:        ["sentence"],
              filter_languages:  [:en]
          )
          expect(pt.tokenize(text)).to eq(["short", "explanations", "."])
        end

        it 'removes user-supplied stop words and default stop words across multiple languages' do
          text = 'This is a short sentence with explanations and stop words. And achte German words.'
          pt = PragmaticTokenizer::Tokenizer.new(
              language:          'en',
              remove_stop_words: true,
              stop_words:        ["sentence"],
              filter_languages:  [:en, :de]
          )
          expect(pt.tokenize(text)).to eq(["short", "explanations", ".", "german", "."])
        end
      end

      context 'multiple options selected' do
        it 'tokenizes a string #001' do
          text = 'His name is Mr. Smith.'
          pt = PragmaticTokenizer::Tokenizer.new(
              language:    'en',
              punctuation: 'none'
          )
          expect(pt.tokenize(text)).to eq(['his', 'name', 'is', 'mr.', 'smith'])
        end

        it 'tokenizes a string #002' do
          text = "Hello Ms. Piggy, this is John. We are selling a new fridge for $5,000. That is a 20% discount over the Nev. retailers. It is a 'MUST BUY', so don't hesistate."
          pt = PragmaticTokenizer::Tokenizer.new(
              language:    'en',
              punctuation: 'only'
          )
          expect(pt.tokenize(text)).to eq([",", ".", ".", ".", "'", "'", ",", "."])
        end

        it 'tokenizes a string #003' do
          text = "Hello the a it experiment one fine."
          pt = PragmaticTokenizer::Tokenizer.new(
              language:          'en',
              remove_stop_words: true
          )
          expect(pt.tokenize(text)).to eq(["experiment", "fine", "."])
        end

        it 'tokenizes a string #004' do
          # https://www.ibm.com/developerworks/community/blogs/nlp/entry/tokenization?lang=en
          text = "\"I said, 'what're you? Crazy?'\" said Sandowsky. \"I can't afford to do that.\""
          pt = PragmaticTokenizer::Tokenizer.new(
              expand_contractions: true,
              remove_stop_words:   true,
              punctuation:         'none'
          )
          expect(pt.tokenize(text)).to eq(%w(crazy sandowsky afford))
        end

        it 'tokenizes a string #005' do
          text = "Hello world with a stop word experiment."
          pt = PragmaticTokenizer::Tokenizer.new(
              language:            'en',
              clean:               true,
              numbers:             :none,
              minimum_length:      3,
              expand_contractions: true,
              remove_stop_words:   true,
              punctuation:         'none'
          )
          expect(pt.tokenize(text)).to eq(["experiment"])
        end

        it 'tokenizes a string #006' do
          text = "Hello; what is your: name @username **delete**"
          pt = PragmaticTokenizer::Tokenizer.new(
              clean:       true,
              punctuation: 'none'
          )
          expect(pt.tokenize(text)).to eq(["hello", "what", "is", "your", "name", "@username", "delete"])
        end

        it 'tokenizes a string #007' do
          text = 'His name is Mr. Smith.'
          pt = PragmaticTokenizer::Tokenizer.new(
              language:    'en',
              punctuation: 'none',
              downcase:    false
          )
          expect(pt.tokenize(text)).to eq(['His', 'name', 'is', 'Mr.', 'Smith'])
        end

        it 'tokenizes a string #008' do
          text = "Can't go tonight. Didn't finish."
          pt = PragmaticTokenizer::Tokenizer.new(
              downcase:            false,
              expand_contractions: true
          )
          expect(pt.tokenize(text)).to eq(["Cannot", "go", "tonight", ".", "Did", "not", "finish", "."])
        end

        it 'tokenizes a string #009' do
          text = "Some *interesting stuff* is __happening here__"
          pt = PragmaticTokenizer::Tokenizer.new(
              punctuation: 'none',
              clean:       true
          )
          expect(pt.tokenize(text)).to eq(%w(some interesting stuff is happening here))
        end

        it 'also allows symbols for options' do
          text = 'His name is Mr. Smith.'
          pt = PragmaticTokenizer::Tokenizer.new(
              language:    :en,
              punctuation: :none
          )
          expect(pt.tokenize(text)).to eq(['his', 'name', 'is', 'mr.', 'smith'])
        end

        it 'handles long strings 1' do
          text = "Hello World. My name is Jonas. What is your name? My name is Jonas IV Smith. There it is! I found it. My name is Jonas E. Smith. Please turn to p. 55. Were Jane and co. at the party? They closed the deal with Pitt, Briggs & Co. at noon. Let's ask Jane and co. They should know. They closed the deal with Pitt, Briggs & Co. It closed yesterday. I can't see Mt. Fuji from here. St. Michael's Church is on 5th st. near the light. That is JFK Jr.'s book. I visited the U.S.A. last year. I live in the E.U. How about you? I live in the U.S. How about you? I work for the U.S. Government in Virginia. I have lived in the U.S. for 20 years. She has $100.00 in her bag. She has $100.00. It is in her bag. He teaches science (He previously worked for 5 years as an engineer.) at the local University. Her email is Jane.Doe@example.com. I sent her an email. The site is: https://www.example.50.com/new-site/awesome_content.html. Please check it out. She turned to him, 'This is great.' she said. She turned to him, \"This is great.\" she said. She turned to him, \"This is great.\" She held the book out to show him. Hello!! Long time no see. Hello?? Who is there? Hello!? Is that you? Hello?! Is that you? 1.) The first item 2.) The second item 1.) The first item. 2.) The second item. 1) The first item 2) The second item 1) The first item. 2) The second item. 1. The first item 2. The second item 1. The first item. 2. The second item. • 9. The first item • 10. The second item ⁃9. The first item ⁃10. The second item a. The first item b. The second item c. The third list item This is a sentence\ncut off in the middle because pdf. It was a cold \nnight in the city. features\ncontact manager\nevents, activities\n You can find it at N°. 1026.253.553. That is where the treasure is. She works at Yahoo! in the accounting department. We make a good team, you and I. Did you see Albert I. Jones yesterday? Thoreau argues that by simplifying one’s life, “the laws of the universe will appear less complex. . . .” \"Bohr [...] used the analogy of parallel stairways [...]\" (Smith 55). If words are left off at the end of a sentence, and that is all that is omitted, indicate the omission with ellipsis marks (preceded and followed by a space) and then indicate the end of the sentence with a period . . . . Next sentence. I never meant that.... She left the store. I wasn’t really ... well, what I mean...see . . . what I'm saying, the thing is . . . I didn’t mean it. One further habit which was somewhat weakened . . . was that of combining words into self-interpreting compounds. . . . The practice was not abandoned. . . ."
          pt = PragmaticTokenizer::Tokenizer.new(
              language:            'en',
              clean:               true,
              minimum_length:      3,
              expand_contractions: true,
              remove_stop_words:   true,
              numbers:             :none,
              punctuation:         :none
          )
          check = ["jonas", "jonas", "smith", "jonas", "smith", "turn", "jane", "party", "closed", "deal", "pitt", "briggs", "noon", "jane", "closed", "deal", "pitt", "briggs", "closed", "yesterday", "mt.", "fuji", "st.", "michael's", "church", "st.", "light", "jfk", "jr.", "book", "visited", "u.s.a.", "year", "live", "e.u.", "live", "u.s.", "work", "u.s.", "government", "virginia", "lived", "u.s.", "years", "bag", "bag", "teaches", "science", "worked", "years", "engineer", "local", "university", "email", "jane.doe@example.com", "email", "site", "check", "turned", "great", "turned", "great", "turned", "great", "held", "book", "long", "time", "item", "item", "item", "item", "item", "item", "item", "item", "item", "item", "item", "item", "item", "item", "item", "item", "item", "item", "list", "item", "sentence", "cut", "middle", "pdf", "cold", "night", "city", "features", "contact", "manager", "events", "activities", "treasure", "works", "yahoo", "accounting", "department", "good", "team", "albert", "jones", "yesterday", "thoreau", "argues", "simplifying", "one’s", "life", "laws", "universe", "complex", "bohr", "analogy", "parallel", "stairways", "smith", "left", "sentence", "omission", "ellipsis", "marks", "preceded", "space", "sentence", "period", "sentence", "meant", "left", "store", "habit", "weakened", "combining", "self-interpreting", "compounds", "practice", "abandoned"]
          puts (pt.tokenize(text) - check).inspect
          expect(pt.tokenize(text)).to eq(check)
        end

        it 'handles long strings 2' do
          text = "Hello World. My name is Jonas. What is your name? My name is Jonas IV Smith. There it is! I found it. My name is Jonas E. Smith. Please turn to p. 55. Were Jane and co. at the party? They closed the deal with Pitt, Briggs & Co. at noon. Let's ask Jane and co. They should know. They closed the deal with Pitt, Briggs & Co. It closed yesterday. I can't see Mt. Fuji from here. St. Michael's Church is on 5th st. near the light. That is JFK Jr.'s book. I visited the U.S.A. last year. I live in the E.U. How about you? I live in the U.S. How about you? I work for the U.S. Government in Virginia. I have lived in the U.S. for 20 years. She has $100.00 in her bag. She has $100.00. It is in her bag. He teaches science (He previously worked for 5 years as an engineer.) at the local University. Her email is Jane.Doe@example.com. I sent her an email. The site is: https://www.example.50.com/new-site/awesome_content.html. Please check it out. She turned to him, 'This is great.' she said. She turned to him, \"This is great.\" she said. She turned to him, \"This is great.\" She held the book out to show him. Hello!! Long time no see. Hello?? Who is there? Hello!? Is that you? Hello?! Is that you? 1.) The first item 2.) The second item 1.) The first item. 2.) The second item. 1) The first item 2) The second item 1) The first item. 2) The second item. 1. The first item 2. The second item 1. The first item. 2. The second item. • 9. The first item • 10. The second item ⁃9. The first item ⁃10. The second item a. The first item b. The second item c. The third list item This is a sentence\ncut off in the middle because pdf. It was a cold \nnight in the city. features\ncontact manager\nevents, activities\n You can find it at N°. 1026.253.553. That is where the treasure is. She works at Yahoo! in the accounting department. We make a good team, you and I. Did you see Albert I. Jones yesterday? Thoreau argues that by simplifying one’s life, “the laws of the universe will appear less complex. . . .” \"Bohr [...] used the analogy of parallel stairways [...]\" (Smith 55). If words are left off at the end of a sentence, and that is all that is omitted, indicate the omission with ellipsis marks (preceded and followed by a space) and then indicate the end of the sentence with a period . . . . Next sentence. I never meant that.... She left the store. I wasn’t really ... well, what I mean...see . . . what I'm saying, the thing is . . . I didn’t mean it. One further habit which was somewhat weakened . . . was that of combining words into self-interpreting compounds. . . . The practice was not abandoned. . . ." * 10
          pt = PragmaticTokenizer::Tokenizer.new(
              language:            'en',
              clean:               true,
              minimum_length:      3,
              expand_contractions: true,
              remove_stop_words:   true,
              numbers:             :none,
              punctuation:         :none
          )
          expect(pt.tokenize(text)).to eq(["jonas", "jonas", "smith", "jonas", "smith", "turn", "jane", "party", "closed", "deal", "pitt", "briggs", "noon", "jane", "closed", "deal", "pitt", "briggs", "closed", "yesterday", "mt.", "fuji", "st.", "michael's", "church", "st.", "light", "jfk", "jr.", "book", "visited", "u.s.a.", "year", "live", "e.u.", "live", "u.s.", "work", "u.s.", "government", "virginia", "lived", "u.s.", "years", "bag", "bag", "teaches", "science", "worked", "years", "engineer", "local", "university", "email", "jane.doe@example.com", "email", "site", "check", "turned", "great", "turned", "great", "turned", "great", "held", "book", "long", "time", "item", "item", "item", "item", "item", "item", "item", "item", "item", "item", "item", "item", "item", "item", "item", "item", "item", "item", "list", "item", "sentence", "cut", "middle", "pdf", "cold", "night", "city", "features", "contact", "manager", "events", "activities", "treasure", "works", "yahoo", "accounting", "department", "good", "team", "albert", "jones", "yesterday", "thoreau", "argues", "simplifying", "one’s", "life", "laws", "universe", "complex", "bohr", "analogy", "parallel", "stairways", "smith", "left", "sentence", "omission", "ellipsis", "marks", "preceded", "space", "sentence", "period", "sentence", "meant", "left", "store", "habit", "weakened", "combining", "self-interpreting", "compounds", "practice", "abandoned"] * 10)
        end

        it 'handles markdown' do
          text = "This is _bold_ and this is *italic*"
          pt = PragmaticTokenizer::Tokenizer.new(
              punctuation: 'none',
              clean:       true
          )
          expect(pt.tokenize(text)).to eq(%w(this is bold and this is italic))
        end

        it 'handles single quotes' do
          text = "Recognised as one of the ‘good’ games."
          pt = PragmaticTokenizer::Tokenizer.new(
              language:            'en',
              clean:               true,
              numbers:             :none,
              minimum_length:      3,
              expand_contractions: true,
              remove_stop_words:   true,
              punctuation:         :none,
              downcase:            true)
          expect(pt.tokenize(text)).to eq(%w(recognised good games))
        end

        it 'removes control characters' do
          text = "\u0000 \u001F \u007FHello test."
          pt = PragmaticTokenizer::Tokenizer.new(
              language: 'en',
              clean:    true
          )
          expect(pt.tokenize(text)).to eq(["hello", "test", "."])
        end

        it 'splits too long words with hypens' do
          text = "hi-hat and old-school but not really-important-long-word"
          pt = PragmaticTokenizer::Tokenizer.new(
              punctuation:     'none',
              long_word_split: 12
          )
          expect(pt.tokenize(text)).to eq(["hi-hat", "and", "old-school", "but", "not", "really", "important", "long", "word"])
        end

        it 'handles hashtags 2' do
          text = "This is the #upper-#limit"
          pt = PragmaticTokenizer::Tokenizer.new(
              punctuation: 'none',
              hashtags:    :keep_and_clean
          )
          expect(pt.tokenize(text)).to eq(%w(this is the upper limit))
        end

        it 'handles hashtags 3' do
          text = "The #2016-fun has just begun."
          pt = PragmaticTokenizer::Tokenizer.new(
              punctuation: 'none',
              hashtags:    :keep_and_clean
          )
          expect(pt.tokenize(text)).to eq(%w(the 2016 fun has just begun))
        end

        it 'does not clean mentions' do
          text = "@_someone_ because @someone and @_someone was taken"
          pt = PragmaticTokenizer::Tokenizer.new(
              mentions: :keep_original,
              clean:    true
          )
          expect(pt.tokenize(text)).to eq(["@_someone_", "because", "@someone", "and", "@_someone", "was", "taken"])
        end

        it 'removes double single quotes' do
          text = "Strong statement in ''The Day The Earth Caught Fire'' (1961)"
          pt = PragmaticTokenizer::Tokenizer.new(
              punctuation: :none,
              clean:       true
          )
          expect(pt.tokenize(text)).to eq(%w(strong statement in the day the earth caught fire 1961))
        end

        it 'removes a hyphen prefix 1' do
          text = "Geopol.-Strategy"
          pt = PragmaticTokenizer::Tokenizer.new(
              punctuation: :none,
              clean:       true
          )
          expect(pt.tokenize(text)).to eq(%w(geopol strategy))
        end

        it 'removes a hyphen prefix 2' do
          text = "The language we use creates the reality we experience.-Michael Hyatt #quote"
          pt = PragmaticTokenizer::Tokenizer.new(
              punctuation: :none,
              clean:       true
          )
          expect(pt.tokenize(text)).to eq(["the", "language", "we", "use", "creates", "the", "reality", "we", "experience", "michael", "hyatt", "#quote"])
        end

        it 'does not remove tokens with ampersands' do
          text = "you&amp;me"
          pt = PragmaticTokenizer::Tokenizer.new(
              clean:       true,
              punctuation: :none
          )
          expect(pt.tokenize(text)).to eq(%w(you&me))
        end

        it 'cleans percent signs not related to numbers' do
          text = "TudoW%1 provides company users a way to offer each other, and guests, and interpreters%6 free assistance. To date, there have been %2 questions asked."
          pt = PragmaticTokenizer::Tokenizer.new(
              clean:       true,
              numbers:     :none,
              punctuation: :none
          )
          expect(pt.tokenize(text)).to eq(%w(tudow provides company users a way to offer each other and guests and interpreters free assistance to date there have been questions asked))
        end

        it 'removes non-breaking spaces' do
          text = "%20141201~221624  %User ID,JU,JU John %TU=00000362  %PT-BR  %Wordfast    da hello."
          pt = PragmaticTokenizer::Tokenizer.new(
            language: :en,
            filter_languages: [:en],
            clean: true,
            numbers: :none,
            minimum_length: 3,
            expand_contractions: true,
            remove_stop_words: true,
            punctuation: :none,
            remove_emails: true,
            remove_domains: true,
            remove_urls: true,
            hashtags: :remove,
            mentions: :remove,
            downcase: true
          )
          expect(pt.tokenize(text)).to eq(["user", "john", "pt-br", "wordfast"])
        end
      end
    end

    context 'ending punctutation' do
      it 'handles ending question marks' do
        text = 'What is your name?'
        expect(PragmaticTokenizer::Tokenizer.new.tokenize(text)).to eq(["what", "is", "your", "name", "?"])
      end

      it 'handles exclamation points' do
        text = 'You are the best!'
        expect(PragmaticTokenizer::Tokenizer.new.tokenize(text)).to eq(["you", "are", "the", "best", "!"])
      end

      it 'handles periods' do
        text = 'This way a productive day.'
        expect(PragmaticTokenizer::Tokenizer.new.tokenize(text)).to eq(["this", "way", "a", "productive", "day", "."])
      end

      it 'handles quotation marks' do
        text = "\"He is not the one you are looking for.\""
        expect(PragmaticTokenizer::Tokenizer.new.tokenize(text)).to eq(["\"", "he", "is", "not", "the", "one", "you", "are", "looking", "for", ".", "\""])
      end

      it 'handles single quotation marks' do
        text = "'He is not the one you are looking for.'"
        expect(PragmaticTokenizer::Tokenizer.new.tokenize(text)).to eq(["'", "he", "is", "not", "the", "one", "you", "are", "looking", "for", ".", "'"])
      end

      it "handles single quotation marks ('twas)" do
        text = "'Twas the night before Christmas and 'twas cloudy."
        expect(PragmaticTokenizer::Tokenizer.new.tokenize(text)).to eq(["'twas", "the", "night", "before", "christmas", "and", "'twas", "cloudy", "."])
      end

      it 'handles double quotes at the end of a sentence' do
        text = "She said, \"I love cake.\""
        expect(PragmaticTokenizer::Tokenizer.new.tokenize(text)).to eq(["she", "said", ",", "\"", "i", "love", "cake", ".", "\""])
      end

      it 'handles double quotes at the beginning of a sentence' do
        text = "\"I love cake.\", she said to her friend."
        expect(PragmaticTokenizer::Tokenizer.new.tokenize(text)).to eq(["\"", "i", "love", "cake", ".", "\"", ",", "she", "said", "to", "her", "friend", "."])
      end

      it 'handles double quotes in the middle of a sentence' do
        text = "She said, \"I love cake.\" to her friend."
        expect(PragmaticTokenizer::Tokenizer.new.tokenize(text)).to eq(["she", "said", ",", "\"", "i", "love", "cake", ".", "\"", "to", "her", "friend", "."])
      end
    end

    context 'other punctutation' do
      it 'handles ellipses' do
        text = 'Today is the last day...'
        expect(PragmaticTokenizer::Tokenizer.new.tokenize(text)).to eq(['today', 'is', 'the', 'last', 'day', '...'])
      end

      it 'handles special quotes' do
        text = "«That's right», he said."
        expect(PragmaticTokenizer::Tokenizer.new.tokenize(text)).to eq(["«", "that's", "right", "»", ",", "he", "said", "."])
      end

      it 'handles upside down punctuation (¿)' do
        text = "¿Really?"
        expect(PragmaticTokenizer::Tokenizer.new.tokenize(text)).to eq(["¿", "really", "?"])
      end

      it 'handles upside down punctuation (¡)' do
        text = "¡Really!"
        expect(PragmaticTokenizer::Tokenizer.new.tokenize(text)).to eq(["¡", "really", "!"])
      end

      it 'handles colons' do
        text = "This was the news: 'Today is the day!'"
        expect(PragmaticTokenizer::Tokenizer.new.tokenize(text)).to eq(["this", "was", "the", "news", ":", "'", "today", "is", "the", "day", "!", "'"])
      end

      it 'handles web addresses' do
        text = "Please visit the site - https://www.tm-town.com"
        expect(PragmaticTokenizer::Tokenizer.new.tokenize(text)).to eq(["please", "visit", "the", "site", "-", "https://www.tm-town.com"])
      end

      it 'handles multiple colons and web addresses' do
        text = "Please visit the site: https://www.tm-town.com"
        expect(PragmaticTokenizer::Tokenizer.new.tokenize(text)).to eq(["please", "visit", "the", "site", ":", "https://www.tm-town.com"])
      end

      it 'handles multiple dashes' do
        text = "John--here is your ticket."
        expect(PragmaticTokenizer::Tokenizer.new.tokenize(text)).to eq(["john", "-", "here", "is", "your", "ticket", "."])
      end

      it 'handles brackets' do
        text = "This is an array: ['Hello']."
        expect(PragmaticTokenizer::Tokenizer.new.tokenize(text)).to eq(["this", "is", "an", "array", ":", "[", "'", "hello", "'", "]", "."])
      end

      it 'handles double question marks' do
        text = "This is a question??"
        expect(PragmaticTokenizer::Tokenizer.new.tokenize(text)).to eq(["this", "is", "a", "question", "?", "?"])
      end

      it 'handles multiple ending punctuation' do
        text = "This is a question?!?"
        expect(PragmaticTokenizer::Tokenizer.new.tokenize(text)).to eq(["this", "is", "a", "question", "?", "!", "?"])
      end

      it 'handles contractions 1' do
        text = "How'd it go yesterday?"
        expect(PragmaticTokenizer::Tokenizer.new.tokenize(text)).to eq(["how'd", "it", "go", "yesterday", "?"])
      end

      it 'handles contractions 2' do
        text = "You shouldn't worry."
        expect(PragmaticTokenizer::Tokenizer.new.tokenize(text)).to eq(["you", "shouldn't", "worry", "."])
      end

      it 'handles contractions 3' do
        text = "We've gone too far. It'll be over when we're done."
        expect(PragmaticTokenizer::Tokenizer.new.tokenize(text)).to eq(["we've", "gone", "too", "far", ".", "it'll", "be", "over", "when", "we're", "done", "."])
      end

      it 'handles numbers' do
        text = 'He paid $10,000,000 for the new house which is equivalent to ¥1,000,000,000.00.'
        expect(PragmaticTokenizer::Tokenizer.new.tokenize(text)).to eq(['he', 'paid', '$10,000,000', 'for', 'the', 'new', 'house', 'which', 'is', 'equivalent', 'to', '¥1,000,000,000.00', '.'])
      end

      it 'follows the Chicago Manual of Style on punctuation' do
        text = 'An abbreviation that ends with a period must not be left hanging without it (in parentheses, e.g.), and a sentence containing a parenthesis must itself have terminal punctuation (are we almost done?).'
        expect(PragmaticTokenizer::Tokenizer.new.tokenize(text)).to eq(['an', 'abbreviation', 'that', 'ends', 'with', 'a', 'period', 'must', 'not', 'be', 'left', 'hanging', 'without', 'it', '(', 'in', 'parentheses', ',', 'e.g.', ')', ',', 'and', 'a', 'sentence', 'containing', 'a', 'parenthesis', 'must', 'itself', 'have', 'terminal', 'punctuation', '(', 'are', 'we', 'almost', 'done', '?', ')', '.'])
      end

      it 'is case insensitive' do
        text = 'his name is mr. smith, king of the \'entire\' forest.'
        expect(PragmaticTokenizer::Tokenizer.new.tokenize(text)).to eq(['his', 'name', 'is', 'mr.', 'smith', ',', 'king', 'of', 'the', '\'', 'entire', '\'', 'forest', '.'])
      end

      it 'handles web url addresses #1' do
        text = 'Check out http://www.google.com/?this_is_a_url/hello-world.html for more info.'
        expect(PragmaticTokenizer::Tokenizer.new.tokenize(text)).to eq(["check", "out", "http://www.google.com/?this_is_a_url/hello-world.html", "for", "more", "info", "."])
      end

      it 'handles web url addresses #2' do
        text = 'Check out https://www.google.com/?this_is_a_url/hello-world.html for more info.'
        expect(PragmaticTokenizer::Tokenizer.new.tokenize(text)).to eq(["check", "out", "https://www.google.com/?this_is_a_url/hello-world.html", "for", "more", "info", "."])
      end

      it 'handles web url addresses #3' do
        text = 'Check out www.google.com/?this_is_a_url/hello-world.html for more info.'
        expect(PragmaticTokenizer::Tokenizer.new.tokenize(text)).to eq(["check", "out", "www.google.com/?this_is_a_url/hello-world.html", "for", "more", "info", "."])
      end

      it 'handles email addresses' do
        text = 'Please email example@example.com for more info.'
        expect(PragmaticTokenizer::Tokenizer.new.tokenize(text)).to eq(["please", "email", "example@example.com", "for", "more", "info", "."])
      end

      it 'handles empty tokens' do
        text = "!!!!! https://t.co/xxxx"
        pt = PragmaticTokenizer::Tokenizer.new(
            punctuation: 'none'
        )
        expect(pt.tokenize(text)).to eq(["https://t.co/xxxx"])
      end
    end

    context 'abbreviations' do
      it 'handles military abbreviations' do
        text = 'His name is Col. Smith.'
        expect(PragmaticTokenizer::Tokenizer.new.tokenize(text)).to eq(["his", "name", "is", "col.", "smith", "."])
      end

      it 'handles institution abbreviations' do
        text = 'She went to East Univ. to get her degree.'
        expect(PragmaticTokenizer::Tokenizer.new.tokenize(text)).to eq(["she", "went", "to", "east", "univ.", "to", "get", "her", "degree", "."])
      end

      it 'handles company abbreviations' do
        text = 'He works at ABC Inc. on weekends.'
        expect(PragmaticTokenizer::Tokenizer.new.tokenize(text)).to eq(["he", "works", "at", "abc", "inc.", "on", "weekends", "."])
      end

      it 'handles old state abbreviations' do
        text = 'He went to school in Mass. back in the day.'
        expect(PragmaticTokenizer::Tokenizer.new.tokenize(text)).to eq(["he", "went", "to", "school", "in", "mass.", "back", "in", "the", "day", "."])
      end

      it 'handles month abbreviations' do
        text = 'It is cold in Jan. they say.'
        expect(PragmaticTokenizer::Tokenizer.new.tokenize(text)).to eq(["it", "is", "cold", "in", "jan.", "they", "say", "."])
      end

      it 'handles miscellaneous abbreviations' do
        text = '1, 2, 3, etc. is the beat.'
        expect(PragmaticTokenizer::Tokenizer.new.tokenize(text)).to eq(['1', ',', '2', ',', '3', ',', 'etc.', 'is', 'the', 'beat', '.'])
      end

      it 'handles one letter abbreviations (i.e. Alfred E. Stone)' do
        text = 'Alfred E. Stone is a person.'
        expect(PragmaticTokenizer::Tokenizer.new.tokenize(text)).to eq(["alfred", "e.", "stone", "is", "a", "person", "."])
      end

      it 'handles repeating letter-dot words (i.e. U.S.A. or J.C. Penney)' do
        text = 'The U.S.A. is a country.'
        expect(PragmaticTokenizer::Tokenizer.new.tokenize(text)).to eq(["the", "u.s.a.", "is", "a", "country", "."])
      end

      it 'handles abbreviations that occur at the end of a sentence' do
        text = 'He works at ABC Inc.'
        expect(PragmaticTokenizer::Tokenizer.new.tokenize(text)).to eq(["he", "works", "at", "abc", "inc."])
      end

      it 'handles punctuation after an abbreviation' do
        text = 'Exclamation point requires both marks (Q.E.D.!).'
        expect(PragmaticTokenizer::Tokenizer.new.tokenize(text)).to eq(['exclamation', 'point', 'requires', 'both', 'marks', '(', 'q.e.d.', '!', ')', '.'])
      end
    end
  end
end
