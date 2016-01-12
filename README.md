# Pragmatic Tokenizer

[![Gem Version](https://badge.fury.io/rb/pragmatic_tokenizer.svg)](https://badge.fury.io/rb/pragmatic_tokenizer) [![Build Status](https://travis-ci.org/diasks2/pragmatic_tokenizer.png)](https://travis-ci.org/diasks2/pragmatic_tokenizer) [![License](https://img.shields.io/badge/license-MIT-brightgreen.svg?style=flat)](https://github.com/diasks2/pragmatic_tokenizer/blob/master/LICENSE.txt)

Pragmatic Tokenizer is a multilingual tokenizer to split a string into tokens.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'pragmatic_tokenizer'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install pragmatic_tokenizer

## Usage

* If no language is specified, the library will default to English.   
* To specify a language use its two character [ISO 639-1 code](https://www.tm-town.com/languages).
* Pragmatic Tokenizer will unescape any HTML entities.

**Options**  

##### `punctuation`
  **default** = `'all'`
- `'all'`  
  Does not remove any punctuation from the result.
- `'semi'`   
  Removes full stops (i.e. periods) ['。', '．', '.'].
- `'none'`  
  Removes all punctuation from the result.
- `'only'`  
  Removes everything except punctuation. The returned result is an array of only the punctuation.

<hr>

##### `remove_stop_words`
  **default** = `'false'`
- `true`  
  Removes all stop words.
- `false`   
  Does not remove stop words.

<hr>

##### `expand_contractions`
  **default** = `'false'`
- `true`  
  Expands contractions (i.e. i'll -> i will).
- `false`   
  Leaves contractions as is.

<hr>

##### `clean`
  **default** = `'false'`
- `true`  
  Removes tokens consisting of only hypens, underscores, or periods as well as some special characters (®, ©, ™). Also removes long tokens or tokens with a backslash.
- `false`   
  Leaves tokens as is.

<hr>

##### `remove_numbers`
  **default** = `'false'`
- `true`  
  Removes any token that contains a number.
- `false`   
  Leaves tokens as is.

<hr>

##### `remove_roman_numerals`
  **default** = `'false'`
- `true`  
  Removes any token that contains a Roman numeral.
- `false`   
  Leaves tokens as is.

<hr>

##### `downcase`
  **default** = `'true'`

<hr>

##### `minimum_length`
  **default** = `0`  
  The minimum number of characters a token should be.  

**Methods**  

#### `#tokenize`

**Example Usage**
```ruby
text = "\"I said, 'what're you? Crazy?'\" said Sandowsky. \"I can't afford to do that.\""

PragmaticTokenizer::Tokenizer.new(text).tokenize
# => ["\"", "i", "said", ",", "'", "what're", "you", "?", "crazy", "?", "'", "\"", "said", "sandowsky", ".", "\"", "i", "can't", "afford", "to", "do", "that", ".", "\""]

PragmaticTokenizer::Tokenizer.new(text, remove_stop_words: true).tokenize
# => ["\"", ",", "'", "what're", "?", "crazy", "?", "'", "\"", "sandowsky", ".", "\"", "afford", ".", "\""]

PragmaticTokenizer::Tokenizer.new(text, punctuation: 'none').tokenize
# => ["i", "said", "what're", "you", "crazy", "said", "sandowsky", "i", "can't", "afford", "to", "do", "that"]

PragmaticTokenizer::Tokenizer.new(text, punctuation: 'only').tokenize
# => ["\"", ",", "'", "?", "?", "'", "\"", ".", "\"", ".", "\""]

PragmaticTokenizer::Tokenizer.new(text, punctuation: 'semi').tokenize
# => ["\"", "i", "said", ",", "'", "what're", "you", "?", "crazy", "?", "'", "\"", "said", "sandowsky", "\"", "i", "can't", "afford", "to", "do", "that", "\""]

PragmaticTokenizer::Tokenizer.new(text, expand_contractions: true).tokenize
# => ['"', 'i', 'said', ',', "'", 'what', 'are', 'you', '?', 'crazy', '?', "'", '"', 'said', 'sandowsky', '.', '"', 'i', 'cannot', 'afford', 'to', 'do', 'that', '.', '"']

PragmaticTokenizer::Tokenizer.new(text, 
  expand_contractions: true, 
  remove_stop_words: true, 
  punctuation: 'none'
).tokenize
# => ["crazy", "sandowsky", "afford"]

text = "The price is $5.50 and it works for 5 hours."
PragmaticTokenizer::Tokenizer.new(text, remove_numbers: true).tokenize
# => ["the", "price", "is", "and", "it", "works", "for", "hours", "."]

text = "Hello ______ ."
PragmaticTokenizer::Tokenizer.new(text, clean: true).tokenize
# => ["hello", "."]

text = "Let's test the minimum length."
PragmaticTokenizer::Tokenizer.new(text, minimum_length: 6).tokenize
# => ["minimum", "length"]
```

<hr>

#### `#urls`
Extract only valid URL tokens

*Not Yet Implemented*

<hr>

#### `#emails`
Extract only valid email tokens

*Not Yet Implemented*

<hr>

#### `#hashtags`
Extract only valid hashtag tokens

*Not Yet Implemented*

<hr>

#### `#mentions`
Extract only valid @ mention tokens

<hr>

#### `#emoticons`
Extract only simple emoticon tokens

<hr>

#### `#emoji`
Extract only valid† emoji tokens

*†matches all 1012 single-character Unicode Emoji (all except for two-character flags)*

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

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

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