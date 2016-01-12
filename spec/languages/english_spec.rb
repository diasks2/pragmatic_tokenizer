require 'spec_helper'

describe PragmaticTokenizer do
  context 'Language: English (en)' do
    context 'tokenization' do
      it 'tokenizes a string #001' do
        # https://www.ibm.com/developerworks/community/blogs/nlp/entry/tokenization?lang=en
        pt = PragmaticTokenizer::Tokenizer.new("\"I said, 'what're you? Crazy?'\" said Sandowsky. \"I can't afford to do that.\"",
          expand_contractions: true
        )
        expect(pt.tokenize).to eq(['"', 'i', 'said', ',', "'", 'what', 'are', 'you', '?', 'crazy', '?', "'", '"', 'said', 'sandowsky', '.', '"', 'i', 'cannot', 'afford', 'to', 'do', 'that', '.', '"'])
      end

      it 'tokenizes a string #002' do
        # http://nlp.stanford.edu/software/tokenizer.shtml
        pt = PragmaticTokenizer::Tokenizer.new("\"Oh, no,\" she's saying, \"our $400 blender can't handle something this hard!\"",
          expand_contractions: true
        )
        expect(pt.tokenize).to eq(['"', 'oh', ',', 'no', ',', '"', 'she', 'is', 'saying', ',', '"', 'our', '$400', 'blender', 'cannot', 'handle', 'something', 'this', 'hard', '!', '"'])
      end

      it 'tokenizes a string #003' do
        pt = PragmaticTokenizer::Tokenizer.new("Hello world.")
        expect(pt.tokenize).to eq(["hello", "world", "."])
      end

      it 'tokenizes a string #004' do
        pt = PragmaticTokenizer::Tokenizer.new("Hello Dr. Death.")
        expect(pt.tokenize).to eq(["hello", "dr.", "death", "."])
      end

      it 'tokenizes a string #005' do
        pt = PragmaticTokenizer::Tokenizer.new('His name is Mr. Smith.',
          language: 'en',
          punctuation: 'none'
        )
        expect(pt.tokenize).to eq(['his', 'name', 'is', 'mr.', 'smith'])
      end

      it 'tokenizes a string #006' do
        pt = PragmaticTokenizer::Tokenizer.new("Hello Ms. Piggy, this is John. We are selling a new fridge for $5,000. That is a 20% discount over the Nev. retailers. It is a 'MUST BUY', so don't hesistate.",
          language: 'en',
          punctuation: 'only'
        )
        expect(pt.tokenize).to eq([",", ".", ".", ".", "'", "'", ",", "."])
      end

      it 'tokenizes a string #007' do
        pt = PragmaticTokenizer::Tokenizer.new("Hello Ms. Piggy, this is John. We are selling a new fridge for $5,000. That is a 20% discount over the Nev. retailers. It is a 'MUST BUY', so don't hesistate.",
          language: 'en'
        )
        expect(pt.tokenize).to eq(["hello", "ms.", "piggy", ",", "this", "is", "john", ".", "we", "are", "selling", "a", "new", "fridge", "for", "$5,000", ".", "that", "is", "a", "20%", "discount", "over", "the", "nev.", "retailers", ".", "it", "is", "a", "'", "must", "buy", "'", ",", "so", "don't", "hesistate", "."])
      end

      it 'tokenizes a string #008' do
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
        pt = PragmaticTokenizer::Tokenizer.new(text, language: 'en')
        expect(pt.tokenize).to eq(['lisa', 'raines', ',', 'a', 'lawyer', 'and', 'director', 'of', 'government', 'relations', 'for', 'the', 'industrial', 'biotechnical', 'association', ',', 'contends', 'that', 'a', 'judge', 'well-versed', 'in', 'patent', 'law', 'and', 'the', 'concerns', 'of', 'research-based', 'industries', 'would', 'have', 'ruled', 'otherwise', '.', 'and', 'judge', 'newman', ',', 'a', 'former', 'patent', 'lawyer', ',', 'wrote', 'in', 'her', 'dissent', 'when', 'the', 'court', 'denied', 'a', 'motion', 'for', 'a', 'rehearing', 'of', 'the', 'case', 'by', 'the', 'full', 'court', ',', "\'", 'the', "panel's", 'judicial', 'legislation', 'has', 'affected', 'an', 'important', 'high-technological', 'industry', ',', 'without', 'regard', 'to', 'the', 'consequences', 'for', 'research', 'and', 'innovation', 'or', 'the', 'public', 'interest', '.', '\'', 'says', 'ms.', 'raines', ',', '\'', '[', 'the', 'judgement', ']', 'confirms', 'our', 'concern', 'that', 'the', 'absence', 'of', 'patent', 'lawyers', 'on', 'the', 'court', 'could', 'prove', 'troublesome', '.', "\'"])
      end

      it 'tokenizes a string #009' do
        pt = PragmaticTokenizer::Tokenizer.new("Hello the a it experiment one fine.",
          language: 'en',
          remove_stop_words: true
        )
        expect(pt.tokenize).to eq(["experiment", "fine", "."])
      end

      it 'tokenizes a string #010' do
        # https://www.ibm.com/developerworks/community/blogs/nlp/entry/tokenization?lang=en
        pt = PragmaticTokenizer::Tokenizer.new("\"I said, 'what're you? Crazy?'\" said Sandowsky. \"I can't afford to do that.\"",
          expand_contractions: true,
          remove_stop_words: true,
          punctuation: 'none'
        )
        expect(pt.tokenize).to eq(["crazy", "sandowsky", "afford"])
      end

      it 'tokenizes a string #011' do
        pt = PragmaticTokenizer::Tokenizer.new("Hello ---------------.",
          clean: true
        )
        expect(pt.tokenize).to eq(["hello", "."])
      end

      it 'tokenizes a string #012' do
        pt = PragmaticTokenizer::Tokenizer.new("Hello ____________________ .",
          clean: true
        )
        expect(pt.tokenize).to eq(["hello", "."])
      end

      it 'tokenizes a string #013' do
        pt = PragmaticTokenizer::Tokenizer.new("Hello ____________________ .",

        )
        expect(pt.tokenize).to eq(["hello", "."])
      end

      it 'tokenizes a string #014' do
        pt = PragmaticTokenizer::Tokenizer.new("Hello, that will be $5 dollars. You can pay at 5:00, after it is 500.",
          remove_numbers: true
        )
        expect(pt.tokenize).to eq(["hello", ",", "that", "will", "be", "dollars", ".", "you", "can", "pay", "at", ",", "after", "it", "is", "."])
      end

      it 'tokenizes a string #015' do
        pt = PragmaticTokenizer::Tokenizer.new("Let's test the minimum length of fiver.",
          minimum_length: 5
        )
        expect(pt.tokenize).to eq(["let's", "minimum", "length", "fiver"])
      end

      it 'tokenizes a string #016' do
        pt = PragmaticTokenizer::Tokenizer.new("Remove III Roman Numerals and IX. with a period.",
          remove_numbers: true,
          remove_roman_numerals: true
        )
        expect(pt.tokenize).to eq(["remove", "roman", "numerals", "and", ".", "with", "a", "period", "."])
      end

      it 'tokenizes a string #017' do
        pt = PragmaticTokenizer::Tokenizer.new("© ABC Company 1994",
          clean: true
        )
        expect(pt.tokenize).to eq(["abc", "company", "1994"])
      end

      it 'tokenizes a string #018' do
        pt = PragmaticTokenizer::Tokenizer.new("This sentence has a long string of dots .......................",
          clean: true
        )
        expect(pt.tokenize).to eq(["this", "sentence", "has", "a", "long", "string", "of", "dots"])
      end

      it 'tokenizes a string #019' do
        pt = PragmaticTokenizer::Tokenizer.new("Hello world with a stop word experiment.",
          language: 'en',
          clean: true,
          remove_numbers: true,
          minimum_length: 3,
          expand_contractions: true,
          remove_stop_words: true,
          punctuation: 'none'
        )
        expect(pt.tokenize).to eq(["experiment"])
      end

      it 'tokenizes a string #020' do
        pt = PragmaticTokenizer::Tokenizer.new("Hello; what is your: name @username **delete**",
          clean: true,
          punctuation: 'none'
        )
        expect(pt.tokenize).to eq(["hello", "what", "is", "your", "name", "username", "delete"])
      end

      it 'tokenizes a string #021' do
        pt = PragmaticTokenizer::Tokenizer.new("Look for his/her account.",
          expand_contractions: true,
        )
        expect(pt.tokenize).to eq(["look", "for", "his", "her", "account", "."])
      end

      it 'tokenizes a string #022' do
        pt = PragmaticTokenizer::Tokenizer.new("kath. / evang",
          punctuation: 'none',
        )
        expect(pt.tokenize).to eq(["kath", "evang"])
      end

      it 'tokenizes a string #023' do
        pt = PragmaticTokenizer::Tokenizer.new("derStandard.at › Sport",
          punctuation: 'none',
        )
        expect(pt.tokenize).to eq(["derstandard.at", "sport"])
      end

      it 'tokenizes a string #024' do
        pt = PragmaticTokenizer::Tokenizer.new("hello ^^",
          punctuation: 'none',
        )
        expect(pt.tokenize).to eq(["hello"])
      end

      it 'tokenizes a string #025' do
        pt = PragmaticTokenizer::Tokenizer.new("This hyphen – is not...or is it? ... It's a - dash... And a horizontal ellipsis…",
          punctuation: 'none',
        )
        expect(pt.tokenize).to eq(["this", "hyphen", "is", "not", "or", "is", "it", "it's", "a", "dash", "and", "a", "horizontal", "ellipsis"])
      end

      it 'tokenizes a string #026' do
        pt = PragmaticTokenizer::Tokenizer.new("A sentence. One with two dots.. And with three... Or horizontal ellipsis… which are three dots too.",
          punctuation: 'none',
        )
        expect(pt.tokenize).to eq(["a", "sentence", "one", "with", "two", "dots", "and", "with", "three", "or", "horizontal", "ellipsis", "which", "are", "three", "dots", "too"])
      end

      it 'tokenizes a string #027' do
        pt = PragmaticTokenizer::Tokenizer.new("+++ BREAKING +++ something happened; is it interesting?",
          punctuation: 'none',
        )
        expect(pt.tokenize).to eq(["breaking", "something", "happened", "is", "it", "interesting"])
      end

      it 'tokenizes a string #028' do
        pt = PragmaticTokenizer::Tokenizer.new("Some *interesting stuff* is __happening here__",
          punctuation: 'none',
        )
        expect(pt.tokenize).to eq(["some", "interesting", "stuff", "is", "happening", "here"])
      end

      it 'tokenizes a string #029' do
        pt = PragmaticTokenizer::Tokenizer.new('His name is Mr. Smith.',
          language: 'en',
          punctuation: 'none',
          downcase: false
        )
        expect(pt.tokenize).to eq(['His', 'name', 'is', 'Mr.', 'Smith'])
      end

      it 'tokenizes a string #030' do
        pt = PragmaticTokenizer::Tokenizer.new("It has a state-of-the-art design.")
        expect(pt.tokenize).to eq(["it", "has", "a", "state-of-the-art", "design", "."])
      end

      it 'tokenizes a string #031' do
        pt = PragmaticTokenizer::Tokenizer.new("Jan. 2015 was 20% colder than now. But not in inter- and outer-space.")
        expect(pt.tokenize).to eq(["jan.", "2015", "was", "20%", "colder", "than", "now", ".", "but", "not", "in", "inter", "-", "and", "outer-space", "."])
      end

      it 'tokenizes a string #032' do
        pt = PragmaticTokenizer::Tokenizer.new("hello ;-) yes",
          punctuation: 'none'
        )
        expect(pt.tokenize).to eq(["hello", "yes"])
      end

      it 'tokenizes a string #033' do
        pt = PragmaticTokenizer::Tokenizer.new("hello ;)",
          punctuation: 'none'
        )
        expect(pt.tokenize).to eq(["hello"])
      end

      it 'tokenizes a string #034' do
        pt = PragmaticTokenizer::Tokenizer.new("hello ;-) yes")
        expect(pt.tokenize).to eq(["hello", ";", "-", ")", "yes"])
      end

      it 'tokenizes a string #035' do
        pt = PragmaticTokenizer::Tokenizer.new("hello ;)")
        expect(pt.tokenize).to eq(["hello", ";", ")"])
      end

      it 'tokenizes a string #036' do
        pt = PragmaticTokenizer::Tokenizer.new("area &lt;0.8 cm2")
        expect(pt.tokenize).to eq(["area", "<0.8", "cm2"])
      end

      it 'tokenizes a string #037' do
        pt = PragmaticTokenizer::Tokenizer.new("area <0.8 cm2")
        expect(pt.tokenize).to eq(["area", "<0.8", "cm2"])
      end

      it 'tokenizes a string #038' do
        pt = PragmaticTokenizer::Tokenizer.new("the “Star-Trek“-Inventor")
        expect(pt.tokenize).to eq(["the", "“", "star-trek", "“", "-", "inventor"])
      end

      it 'tokenizes a string #039' do
        pt = PragmaticTokenizer::Tokenizer.new("I like apples and/or oranges.",
          expand_contractions: true
        )
        expect(pt.tokenize).to eq(["i", "like", "apples", "and", "or", "oranges", "."])
      end

      it 'tokenizes a string #040' do
        pt = PragmaticTokenizer::Tokenizer.new("Can't go tonight. Didn't finish.",
          downcase: false,
          expand_contractions: true
        )
        expect(pt.tokenize).to eq(["Cannot", "go", "tonight", ".", "Did", "not", "finish", "."])
      end

      it 'tokenizes a string #041' do
        pt = PragmaticTokenizer::Tokenizer.new('Go to http://www.example.com.')
        expect(pt.tokenize).to eq(["go", "to", "http://www.example.com", "."])
      end

      it 'tokenizes a string #042' do
        pt = PragmaticTokenizer::Tokenizer.new('One of the lawyers from ‚Making a Murderer’ admitted a mistake')
        expect(pt.tokenize).to eq(["one", "of", "the", "lawyers", "from", "‚", "making", "a", "murderer", "’", "admitted", "a", "mistake"])
      end

      it 'tokenizes a string #043' do
        pt = PragmaticTokenizer::Tokenizer.new("One of the lawyers from 'Making a Murderer' admitted a mistake")
        expect(pt.tokenize).to eq(["one", "of", "the", "lawyers", "from", "'", "making", "a", "murderer", "'", "admitted", "a", "mistake"])
      end
    end

    context 'other methods' do
      context 'hashtags' do
        it 'finds all valid hashtags #001' do
          pt = PragmaticTokenizer::Tokenizer.new('Find me all the #fun #hashtags and only give me #backallofthem.')
          expect(pt.hashtags).to eq(['#fun', '#hashtags', '#backallofthem'])
        end

        it 'finds all valid hashtags #002' do
          pt = PragmaticTokenizer::Tokenizer.new('#fun #hashtags and only give me ＃backallofthem')
          expect(pt.hashtags).to eq(['#fun', '#hashtags', '＃backallofthem'])
        end
      end

      context 'urls' do
        it 'finds all valid urls #001' do
          pt = PragmaticTokenizer::Tokenizer.new('Check out http://www.google.com/?this_is_a_url/hello-world.html for more info.')
          expect(pt.urls).to eq(["http://www.google.com/?this_is_a_url/hello-world.html"])
        end

        it 'finds all valid urls #002' do
          pt = PragmaticTokenizer::Tokenizer.new('Check out https://www.google.com/?this_is_a_url/hello-world.html for more info.')
          expect(pt.urls).to eq(["https://www.google.com/?this_is_a_url/hello-world.html"])
        end

        it 'finds all valid urls #003' do
          pt = PragmaticTokenizer::Tokenizer.new('Check out www.google.com/?this_is_a_url/hello-world.html for more info.')
          expect(pt.urls).to eq(["www.google.com/?this_is_a_url/hello-world.html"])
        end

        it 'finds all valid urls #004' do
          pt = PragmaticTokenizer::Tokenizer.new('Go to http://www.example.com.')
          expect(pt.urls).to eq(["http://www.example.com"])
        end
      end

      context 'emails' do
        it 'finds all valid emails #001' do
          pt = PragmaticTokenizer::Tokenizer.new('Please email example@example.com for more info.')
          expect(pt.emails).to eq(['example@example.com'])
        end

        it 'finds all valid emails #002' do
          pt = PragmaticTokenizer::Tokenizer.new('123@gmail.com Please email example@example.com for more info. test@hotmail.com')
          expect(pt.emails).to eq(['123@gmail.com', 'example@example.com', 'test@hotmail.com'])
        end

        it 'finds all valid emails #003' do
          pt = PragmaticTokenizer::Tokenizer.new('123@gmail.com.')
          expect(pt.emails).to eq(['123@gmail.com'])
        end
      end

      context 'mentions' do
        it 'finds all valid @ mentions #001' do
          pt = PragmaticTokenizer::Tokenizer.new('Find me all the @johnny and @space mentions @john.')
          expect(pt.mentions).to eq(['@johnny', '@space', '@john'])
        end

        it 'finds all valid @ mentions #002' do
          pt = PragmaticTokenizer::Tokenizer.new('Find me all the ＠awesome mentions.')
          expect(pt.mentions).to eq(["＠awesome"])
        end
      end

      context 'emoticons' do
        it 'finds simple emoticons #001' do
          pt = PragmaticTokenizer::Tokenizer.new('Hello ;-) :) 😄')
          expect(pt.emoticons).to eq([';-)', ':)'])
        end
      end

      context 'emoji' do
        it 'finds all valid emoji #001' do
          pt = PragmaticTokenizer::Tokenizer.new('Hello ;-) :) 😄')
          expect(pt.emoji).to eq(['😄'])
        end

        it 'finds all valid emoji #002' do
          pt = PragmaticTokenizer::Tokenizer.new('I am a string with emoji 😍😍😱😱👿👿🐔🌚 and some other Unicode characters 比如中文 and numbers 55 33.')
          expect(pt.emoji).to eq(["😍", "😍", "😱", "😱", "👿", "👿", "🐔", "🌚"])
        end

        it 'finds all valid emoji #003' do
          pt = PragmaticTokenizer::Tokenizer.new("Return the emoji 👿😍😱🐔🌚.")
          expect(pt.emoji).to eq(["👿", "😍", "😱", "🐔", "🌚"])
        end
      end
    end

    context 'ending punctutation' do
      it 'handles ending question marks' do
        text = 'What is your name?'
        expect(PragmaticTokenizer::Tokenizer.new(text).tokenize).to eq(["what", "is", "your", "name", "?"])
      end

      it 'handles exclamation points' do
        text = 'You are the best!'
        expect(PragmaticTokenizer::Tokenizer.new(text).tokenize).to eq(["you", "are", "the", "best", "!"])
      end

      it 'handles periods' do
        text = 'This way a productive day.'
        expect(PragmaticTokenizer::Tokenizer.new(text).tokenize).to eq(["this", "way", "a", "productive", "day", "."])
      end

      it 'handles quotation marks' do
        text = "\"He is not the one you are looking for.\""
        expect(PragmaticTokenizer::Tokenizer.new(text).tokenize).to eq(["\"", "he", "is", "not", "the", "one", "you", "are", "looking", "for", ".", "\""])
      end

      it 'handles single quotation marks' do
        text = "'He is not the one you are looking for.'"
        expect(PragmaticTokenizer::Tokenizer.new(text).tokenize).to eq(["'", "he", "is", "not", "the", "one", "you", "are", "looking", "for", ".", "'"])
      end

      it "handles single quotation marks ('twas)" do
        text = "'Twas the night before Christmas and 'twas cloudy."
        expect(PragmaticTokenizer::Tokenizer.new(text).tokenize).to eq(["'twas", "the", "night", "before", "christmas", "and", "'twas", "cloudy", "."])
      end

      it 'handles double quotes at the end of a sentence' do
        text = "She said, \"I love cake.\""
        expect(PragmaticTokenizer::Tokenizer.new(text).tokenize).to eq(["she", "said", ",", "\"", "i", "love", "cake", ".", "\""])
      end

      it 'handles double quotes at the beginning of a sentence' do
        text = "\"I love cake.\", she said to her friend."
        expect(PragmaticTokenizer::Tokenizer.new(text).tokenize).to eq(["\"", "i", "love", "cake", ".", "\"", ",", "she", "said", "to", "her", "friend", "."])
      end

      it 'handles double quotes in the middle of a sentence' do
        text = "She said, \"I love cake.\" to her friend."
        expect(PragmaticTokenizer::Tokenizer.new(text).tokenize).to eq(["she", "said", ",", "\"", "i", "love", "cake", ".", "\"", "to", "her", "friend", "."])
      end
    end

    context 'other punctutation' do
      it 'handles ellipses' do
        text = 'Today is the last day...'
        expect(PragmaticTokenizer::Tokenizer.new(text).tokenize).to eq(['today', 'is', 'the', 'last', 'day', '...'])
      end

      it 'handles special quotes' do
        text = "«That's right», he said."
        expect(PragmaticTokenizer::Tokenizer.new(text).tokenize).to eq(["«", "that's", "right", "»", ",", "he", "said", "."])
      end

      it 'handles upside down punctuation (¿)' do
        text = "¿Really?"
        expect(PragmaticTokenizer::Tokenizer.new(text).tokenize).to eq(["¿", "really", "?"])
      end

      it 'handles upside down punctuation (¡)' do
        text = "¡Really!"
        expect(PragmaticTokenizer::Tokenizer.new(text).tokenize).to eq(["¡", "really", "!"])
      end

      it 'handles colons' do
        text = "This was the news: 'Today is the day!'"
        expect(PragmaticTokenizer::Tokenizer.new(text).tokenize).to eq(["this", "was", "the", "news", ":", "'", "today", "is", "the", "day", "!", "'"])
      end

      it 'handles web addresses' do
        text = "Please visit the site - https://www.tm-town.com"
        expect(PragmaticTokenizer::Tokenizer.new(text).tokenize).to eq(["please", "visit", "the", "site", "-", "https://www.tm-town.com"])
      end

      it 'handles multiple colons and web addresses' do
        text = "Please visit the site: https://www.tm-town.com"
        expect(PragmaticTokenizer::Tokenizer.new(text).tokenize).to eq(["please", "visit", "the", "site", ":", "https://www.tm-town.com"])
      end

      it 'handles multiple dashes' do
        text = "John--here is your ticket."
        expect(PragmaticTokenizer::Tokenizer.new(text).tokenize).to eq(["john", "-", "here", "is", "your", "ticket", "."])
      end

      it 'handles brackets' do
        text = "This is an array: ['Hello']."
        expect(PragmaticTokenizer::Tokenizer.new(text).tokenize).to eq(["this", "is", "an", "array", ":", "[", "'", "hello", "'", "]", "."])
      end

      it 'handles double question marks' do
        text = "This is a question??"
        expect(PragmaticTokenizer::Tokenizer.new(text).tokenize).to eq(["this", "is", "a", "question", "?", "?"])
      end

      it 'handles multiple ending punctuation' do
        text = "This is a question?!?"
        expect(PragmaticTokenizer::Tokenizer.new(text).tokenize).to eq(["this", "is", "a", "question", "?", "!", "?"])
      end

      it 'handles contractions' do
        text = "How'd it go yesterday?"
        expect(PragmaticTokenizer::Tokenizer.new(text).tokenize).to eq(["how'd", "it", "go", "yesterday", "?"])
      end

      it 'handles contractions' do
        text = "You shouldn't worry."
        expect(PragmaticTokenizer::Tokenizer.new(text).tokenize).to eq(["you", "shouldn't", "worry", "."])
      end

      it 'handles contractions' do
        text = "We've gone too far. It'll be over when we're done."
        expect(PragmaticTokenizer::Tokenizer.new(text).tokenize).to eq(["we've", "gone", "too", "far", ".", "it'll", "be", "over", "when", "we're", "done", "."])
      end

      it 'handles numbers' do
        text = 'He paid $10,000,000 for the new house which is equivalent to ¥1,000,000,000.00.'
        expect(PragmaticTokenizer::Tokenizer.new(text).tokenize).to eq(['he', 'paid', '$10,000,000', 'for', 'the', 'new', 'house', 'which', 'is', 'equivalent', 'to', '¥1,000,000,000.00', '.'])
      end

      it 'follows the Chicago Manual of Style on punctuation' do
        text = 'An abbreviation that ends with a period must not be left hanging without it (in parentheses, e.g.), and a sentence containing a parenthesis must itself have terminal punctuation (are we almost done?).'
        expect(PragmaticTokenizer::Tokenizer.new(text).tokenize).to eq(['an', 'abbreviation', 'that', 'ends', 'with', 'a', 'period', 'must', 'not', 'be', 'left', 'hanging', 'without', 'it', '(', 'in', 'parentheses', ',', 'e.g.', ')', ',', 'and', 'a', 'sentence', 'containing', 'a', 'parenthesis', 'must', 'itself', 'have', 'terminal', 'punctuation', '(', 'are', 'we', 'almost', 'done', '?', ')', '.'])
      end

      it 'is case insensitive' do
        text = 'his name is mr. smith, king of the \'entire\' forest.'
        expect(PragmaticTokenizer::Tokenizer.new(text).tokenize).to eq(['his', 'name', 'is', 'mr.', 'smith', ',', 'king', 'of', 'the', '\'', 'entire', '\'', 'forest', '.'])
      end

      it 'handles web url addresses #1' do
        text = 'Check out http://www.google.com/?this_is_a_url/hello-world.html for more info.'
        expect(PragmaticTokenizer::Tokenizer.new(text).tokenize).to eq(["check", "out", "http://www.google.com/?this_is_a_url/hello-world.html", "for", "more", "info", "."])
      end

      it 'handles web url addresses #2' do
        text = 'Check out https://www.google.com/?this_is_a_url/hello-world.html for more info.'
        expect(PragmaticTokenizer::Tokenizer.new(text).tokenize).to eq(["check", "out", "https://www.google.com/?this_is_a_url/hello-world.html", "for", "more", "info", "."])
      end

      it 'handles web url addresses #3' do
        text = 'Check out www.google.com/?this_is_a_url/hello-world.html for more info.'
        expect(PragmaticTokenizer::Tokenizer.new(text).tokenize).to eq(["check", "out", "www.google.com/?this_is_a_url/hello-world.html", "for", "more", "info", "."])
      end

      it 'handles email addresses' do
        text = 'Please email example@example.com for more info.'
        expect(PragmaticTokenizer::Tokenizer.new(text).tokenize).to eq(["please", "email", "example@example.com", "for", "more", "info", "."])
      end

      it 'handles empty tokens' do
        text = "!!!!! https://t.co/xxxx"
        pt = PragmaticTokenizer::Tokenizer.new(text,
          punctuation: 'none'
        )
        expect(pt.tokenize).to eq(["https://t.co/xxxx"])
      end
    end

    context 'abbreviations' do
      it 'handles military abbreviations' do
        text = 'His name is Col. Smith.'
        expect(PragmaticTokenizer::Tokenizer.new(text).tokenize).to eq(["his", "name", "is", "col.", "smith", "."])
      end

      it 'handles institution abbreviations' do
        text = 'She went to East Univ. to get her degree.'
        expect(PragmaticTokenizer::Tokenizer.new(text).tokenize).to eq(["she", "went", "to", "east", "univ.", "to", "get", "her", "degree", "."])
      end

      it 'handles company abbreviations' do
        text = 'He works at ABC Inc. on weekends.'
        expect(PragmaticTokenizer::Tokenizer.new(text).tokenize).to eq(["he", "works", "at", "abc", "inc.", "on", "weekends", "."])
      end

      it 'handles old state abbreviations' do
        text = 'He went to school in Mass. back in the day.'
        expect(PragmaticTokenizer::Tokenizer.new(text).tokenize).to eq(["he", "went", "to", "school", "in", "mass.", "back", "in", "the", "day", "."])
      end

      it 'handles month abbreviations' do
        text = 'It is cold in Jan. they say.'
        expect(PragmaticTokenizer::Tokenizer.new(text).tokenize).to eq(["it", "is", "cold", "in", "jan.", "they", "say", "."])
      end

      it 'handles miscellaneous abbreviations' do
        text = '1, 2, 3, etc. is the beat.'
        expect(PragmaticTokenizer::Tokenizer.new(text).tokenize).to eq(['1', ',', '2', ',', '3', ',', 'etc.', 'is', 'the', 'beat', '.'])
      end

      it 'handles one letter abbreviations (i.e. Alfred E. Stone)' do
        text = 'Alfred E. Stone is a person.'
        expect(PragmaticTokenizer::Tokenizer.new(text).tokenize).to eq(["alfred", "e.", "stone", "is", "a", "person", "."])
      end

      it 'handles repeating letter-dot words (i.e. U.S.A. or J.C. Penney)' do
        text = 'The U.S.A. is a country.'
        expect(PragmaticTokenizer::Tokenizer.new(text).tokenize).to eq(["the", "u.s.a.", "is", "a", "country", "."])
      end

      it 'handles abbreviations that occur at the end of a sentence' do
        text = 'He works at ABC Inc.'
        expect(PragmaticTokenizer::Tokenizer.new(text).tokenize).to eq(["he", "works", "at", "abc", "inc", "."])
      end

      it 'handles punctuation after an abbreviation' do
        text = 'Exclamation point requires both marks (Q.E.D.!).'
        expect(PragmaticTokenizer::Tokenizer.new(text).tokenize).to eq(['exclamation', 'point', 'requires', 'both', 'marks', '(', 'q.e.d.', '!', ')', '.'])
      end
    end
  end
end