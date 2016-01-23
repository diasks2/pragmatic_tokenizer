require 'pragmatic_tokenizer/languages/common'

require 'pragmatic_tokenizer/languages/english'
require 'pragmatic_tokenizer/languages/arabic'
require 'pragmatic_tokenizer/languages/bulgarian'
require 'pragmatic_tokenizer/languages/catalan'
require 'pragmatic_tokenizer/languages/czech'
require 'pragmatic_tokenizer/languages/danish'
require 'pragmatic_tokenizer/languages/deutsch'
require 'pragmatic_tokenizer/languages/greek'
require 'pragmatic_tokenizer/languages/spanish'
require 'pragmatic_tokenizer/languages/persian'
require 'pragmatic_tokenizer/languages/finnish'
require 'pragmatic_tokenizer/languages/french'
require 'pragmatic_tokenizer/languages/indonesian'
require 'pragmatic_tokenizer/languages/italian'
require 'pragmatic_tokenizer/languages/latvian'
require 'pragmatic_tokenizer/languages/dutch'
require 'pragmatic_tokenizer/languages/norwegian'
require 'pragmatic_tokenizer/languages/polish'
require 'pragmatic_tokenizer/languages/portuguese'
require 'pragmatic_tokenizer/languages/romanian'
require 'pragmatic_tokenizer/languages/russian'
require 'pragmatic_tokenizer/languages/slovak'
require 'pragmatic_tokenizer/languages/swedish'
require 'pragmatic_tokenizer/languages/turkish'

module PragmaticTokenizer
  module Languages
    LANGUAGE_CODES = {
        'en' => English,
      'ar' => Arabic,
      'bg' => Bulgarian,
      'ca' => Catalan,
      'cs' => Czech,
      'da' => Danish,
      'de' => Deutsch,
      'el' => Greek,
      'es' => Spanish,
      'fa' => Persian,
      'fi' => Finnish,
      'fr' => French,
      'id' => Indonesian,
      'it' => Italian,
      'lv' => Latvian,
      'nl' => Dutch,
      'nn' => Norwegian,
      'nb' => Norwegian,
      'no' => Norwegian,
      'pl' => Polish,
      'pt' => Portuguese,
      'ro' => Romanian,
      'ru' => Russian,
      'sk' => Slovak,
      'sv' => Swedish,
      'tr' => Turkish
    }.freeze

    def self.get_language_by_code(code)
      LANGUAGE_CODES[code] || Common
    end
  end
end