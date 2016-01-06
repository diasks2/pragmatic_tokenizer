require 'spec_helper'

describe PragmaticTokenizer do
  context 'Language: English (en)' do
    context 'example strings' do
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

      it 'tokenizes a string #0010' do
        # https://www.ibm.com/developerworks/community/blogs/nlp/entry/tokenization?lang=en
        pt = PragmaticTokenizer::Tokenizer.new("\"I said, 'what're you? Crazy?'\" said Sandowsky. \"I can't afford to do that.\"",
          expand_contractions: true,
          remove_stop_words: true,
          punctuation: 'none'
        )
        expect(pt.tokenize).to eq(["crazy", "sandowsky", "afford"])
      end

      it 'tokenizes a string #0011' do
        pt = PragmaticTokenizer::Tokenizer.new("Hello ---------------.",
          clean: true
        )
        expect(pt.tokenize).to eq(["hello", "."])
      end

      it 'tokenizes a string #0012' do
        pt = PragmaticTokenizer::Tokenizer.new("Hello ____________________ .",
          clean: true
        )
        expect(pt.tokenize).to eq(["hello", "."])
      end

      it 'tokenizes a string #0013' do
        pt = PragmaticTokenizer::Tokenizer.new("Hello ____________________ .",

        )
        expect(pt.tokenize).to eq(["hello", "____________________", "."])
      end

      it 'tokenizes a string #0014' do
        pt = PragmaticTokenizer::Tokenizer.new("Hello, that will be $5 dollars. You can pay at 5:00, after it is 500.",
          remove_numbers: true
        )
        expect(pt.tokenize).to eq(["hello", ",", "that", "will", "be", "dollars", ".", "you", "can", "pay", "at", ",", "after", "it", "is", "."])
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