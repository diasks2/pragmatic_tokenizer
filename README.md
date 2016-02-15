# Pragmatic Tokenizer

[![Gem Version](https://badge.fury.io/rb/pragmatic_tokenizer.svg)](https://badge.fury.io/rb/pragmatic_tokenizer) [![Build Status](https://travis-ci.org/diasks2/pragmatic_tokenizer.png)](https://travis-ci.org/diasks2/pragmatic_tokenizer) [![License](https://img.shields.io/badge/license-MIT-brightgreen.svg?style=flat)](https://github.com/diasks2/pragmatic_tokenizer/blob/master/LICENSE.txt)

Pragmatic Tokenizer is a multilingual tokenizer to split a string into tokens.

## Installation

Add this line to your application's Gemfile:

**Ruby**  
```
gem install pragmatic_tokenizer
```

**Ruby on Rails**  
Add this line to your application’s Gemfile:  
```ruby 
gem 'pragmatic_tokenizer'
```

## Usage

* If no language is specified, the library will default to English.   
* To specify a language use its two character [ISO 639-1 code](https://www.tm-town.com/languages).
* Pragmatic Tokenizer will unescape any HTML entities.

**Example Usage**
```ruby
text = "\"I said, 'what're you? Crazy?'\" said Sandowsky. \"I can't afford to do that.\""

PragmaticTokenizer::Tokenizer.new.tokenize(text)
# => ["\"", "i", "said", ",", "'", "what're", "you", "?", "crazy", "?", "'", "\"", "said", "sandowsky", ".", "\"", "i", "can't", "afford", "to", "do", "that", ".", "\""]

# You can pass many different options to #initialize:
options = {
  language:            :en, # the language of the string you are tokenizing
  abbreviations:       ['a.b', 'a'], # a user-supplied array of abbreviations (downcased with ending period removed)
  stop_words:          ['is', 'the'], # a user-supplied array of stop words (downcased)
  remove_stop_words:   true, # remove stop words
  contractions:        { "i'm" => "i am" }, # a user-supplied hash of contractions (key is the contracted form; value is the expanded form - both the key and value should be downcased)
  expand_contractions: true, # (i.e. ["isn't"] will change to two tokens ["is", "not"])
  filter_languages:    [:en, :de], # process abbreviations, contractions and stop words for this array of languages
  punctuation:         :none, # see below for more details
  numbers:             :none, # see below for more details
  remove_emoji:        :true, # remove any emoji tokens
  remove_urls:         :true, # remove any urls
  remove_emails:       :true, # remove any emails
  remove_domains:      :true, # remove any domains
  hashtags:            :keep_and_clean, # remove the hastag prefix
  mentions:            :keep_and_clean, # remove the @ prefix
  clean:               true, # remove some special characters
  classic_filter:      true, # removes dots from acronyms and 's from the end of tokens
  downcase:            false, # do not downcase tokens
  minimum_length:      3, # remove any tokens less than 3 characters
  long_word_split:     10 # split tokens longer than 10 characters at hypens or underscores
}
```

**Options**  

##### `language`
  **default** = `'en'`
- To specify a language use its two character [ISO 639-1 code](https://www.tm-town.com/languages) as a symbol (i.e. `:en`) or string (i.e. `'en'`)

<hr>

##### `abbreviations`
  **default** = `nil`
- You can pass an array of abbreviations to overide or compliment the abbreviations that come stored in this gem. Each element of the array should be a downcased String with the ending period removed.

<hr>

##### `stop_words`
  **default** = `nil`
- You can pass an array of stop words to overide or compliment the stop words that come stored in this gem. Each element of the array should be a downcased String.

<hr>

##### `contractions`
  **default** = `nil`
- You can pass a hash of contractions to overide or compliment the contractions that come stored in this gem. Each key is the contracted form downcased and each value is the expanded form downcased.

<hr>

##### `remove_stop_words`
  **default** = `false`
- `true`  
  Removes all stop words.
- `false`   
  Does not remove stop words.

<hr>

##### `expand_contractions`
  **default** = `false`
- `true`  
  Expands contractions (i.e. i'll -> i will).
- `false`   
  Leaves contractions as is.

<hr>

##### `filter_languages`
  **default** = `nil`
- You can pass an array of languages of which you would like to process abbreviations, stop words and contractions. This language can be indepedent of the language of the string you are tokenizing (for example your tex might be German but contain so English stop words that you want to remove). If you supply your own abbreviations, stop words or contractions they will be merged with the abbreviations, stop words and contractions of any languages you add in this option. You can pass an array of symbols or strings (i.e. `[:en, :de]` or `['en', 'de']`)

<hr>

##### `punctuation`
  **default** = `'all'`
- `:all`  
  Does not remove any punctuation from the result.
- `:semi`   
  Removes full stops (i.e. periods) ['。', '．', '.'].
- `:none`  
  Removes all punctuation from the result.
- `:only`  
  Removes everything except punctuation. The returned result is an array of only the punctuation.

<hr>

##### `numbers`
  **default** = `'all'`
- `:all`  
  Does not remove any numbers from the result
- `:semi`   
  Removes tokens that include only digits
- `:none`  
  Removes all tokens that include a number from the result (including Roman numerals)
- `:only`  
  Removes everything except tokens that include a number

<hr>

##### `remove_emoji`
  **default** = `false`
- `true`  
  Removes any token that contains an emoji.
- `false`   
  Leaves tokens as is.

<hr>

##### `remove_urls`
  **default** = `false`
- `true`  
  Removes any token that contains a URL.
- `false`   
  Leaves tokens as is.

<hr>

##### `remove_domains`
  **default** = `false`
- `true`  
  Removes any token that contains a domain.
- `false`   
  Leaves tokens as is.

<hr>

##### `remove_domains`
  **default** = `false`
- `true`  
  Removes any token that contains a domain.
- `false`   
  Leaves tokens as is.

<hr>

##### `clean`
  **default** = `false`
- `true`  
  Removes tokens consisting of only hypens, underscores, or periods as well as some special characters (®, ©, ™). Also removes long tokens or tokens with a backslash.
- `false`   
  Leaves tokens as is.

<hr>

##### `hashtags`
  **default** = `:keep_original`
- `:keep_original`  
  Does not alter the token at all.
- `:keep_and_clean`   
  Removes the hashtag (#) prefix from the token.
- `:remove`   
  Removes the token completely.

<hr>

##### `mentions`
  **default** = `:keep_original`
- `:keep_original`  
  Does not alter the token at all.
- `:keep_and_clean`   
  Removes the mention (@) prefix from the token.
- `:remove`   
  Removes the token completely.

<hr>

##### `classic_filter`
  **default** = `false`
- `true`  
  Removes dots from acronyms and 's from the end of tokens.
- `false`   
  Leaves tokens as is.

<hr>

##### `downcase`
  **default** = `true`

<hr>

##### `minimum_length`
  **default** = `0`  
  The minimum number of characters a token should be.  

<hr>

##### `long_word_split`
  **default** = `nil`  
  The number of characters after which a token should be split at hypens or underscores.

## Language Support

The following lists the current level of support for different languages. Pull requests or help for any languages that are not fully supported would be greatly appreciated.  

*N.B. - contractions might not be applicable for all languages below - in that case the CONTRACTIONS hash should stay empty.*  

##### English
Specs: Yes  
Abbreviations: Yes  
Stop Words: Yes  
Contractions: Yes  

##### Arabic
Specs: No  
Abbreviations: Yes  
Stop Words: Yes  
Contractions: No  

##### Bulgarian
Specs: More needed   
Abbreviations: Yes  
Stop Words: Yes  
Contractions: No  

##### Catalan
Specs: No  
Abbreviations: No  
Stop Words: Yes  
Contractions: No  

##### Czech
Specs: No  
Abbreviations: No  
Stop Words: Yes  
Contractions: No  

##### Danish
Specs: No  
Abbreviations: No  
Stop Words: Yes  
Contractions: No  

##### Deutsch
Specs: More needed  
Abbreviations: Yes  
Stop Words: Yes  
Contractions: No  

##### Finnish
Specs: No  
Abbreviations: No  
Stop Words: Yes  
Contractions: No  

##### French
Specs: More needed  
Abbreviations: Yes  
Stop Words: Yes  
Contractions: No  

##### Greek
Specs: No  
Abbreviations: No  
Stop Words: Yes  
Contractions: No  

##### Indonesian
Specs: No  
Abbreviations: No  
Stop Words: Yes  
Contractions: No  

##### Italian
Specs: No  
Abbreviations: Yes  
Stop Words: Yes  
Contractions: No  

##### Latvian
Specs: No  
Abbreviations: No  
Stop Words: Yes  
Contractions: No  

##### Norwegian
Specs: No  
Abbreviations: No  
Stop Words: Yes  
Contractions: No  

##### Persian
Specs: No  
Abbreviations: No  
Stop Words: Yes  
Contractions: No  

##### Polish
Specs: No  
Abbreviations: Yes  
Stop Words: Yes  
Contractions: No  

##### Portuguese
Specs: No  
Abbreviations: No  
Stop Words: Yes  
Contractions: No  

##### Romanian
Specs: No  
Abbreviations: No  
Stop Words: Yes  
Contractions: No  

##### Russian
Specs: No  
Abbreviations: Yes  
Stop Words: Yes  
Contractions: No  

##### Slovak
Specs: No  
Abbreviations: No  
Stop Words: Yes  
Contractions: No  

##### Spanish
Specs: No  
Abbreviations: Yes  
Stop Words: Yes  
Contractions: Yes  

##### Swedish
Specs: No  
Abbreviations: No  
Stop Words: Yes  
Contractions: No  

##### Turkish
Specs: No  
Abbreviations: No  
Stop Words: Yes  
Contractions: No  

## Resources

* [The Art of Tokenization](https://www.ibm.com/developerworks/community/blogs/nlp/entry/tokenization?lang=en)
* [Handbook Of Natural Language Processing Second Edition](https://karczmarczuk.users.greyc.fr/TEACH/TAL/Doc/Handbook%20Of%20Natural%20Language%20Processing,%20Second%20Edition%20Chapman%20&%20Hall%20Crc%20Machine%20Learning%20&%20Pattern%20Recognition%202010.pdf)

## Contributing

1. Fork it ( https://github.com/diasks2/pragmatic_tokenizer/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## License

The MIT License (MIT)

Copyright (c) 2016 Kevin S. Dias

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
