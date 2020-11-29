require 'spec_helper'

def admitted?(input)
  input.scan(Regexp.new("[#{ADMITTED_SYMBOLS_IN_A_WORD.map { |w| Regexp.escape(w) }.join("")}]", "i")).size > 0
end

describe PragmaticTokenizer do
  ADMITTED_SYMBOLS_IN_A_WORD = ["&","+","-","_","'"]
  TEXT_SYMBOLS = ["!",'"',"#","$","%","&","'","(",")","*","+",",","-",".","/",":",";","<","=",">","?","@","[","\\", "]","\^","_","{","|","}","\~","€","£","ლ","₵","¥","$","﷼","฿","…","’","“","”","‵‵", "〝", "″","〞","〟", "〃", "「", "⌈", "」", "⌋","『", "』"," "]
  # @see https://en.wikipedia.org/wiki/Currency_symbol
  # @see http://graphemica.com/
  DOLLAR_SIGN = [0x0024, 0xfe69, 0xff04].map{ |u| u.chr(Encoding::UTF_8) }
  EURO_SIGN   = [0x20ac].map{ |u| u.chr(Encoding::UTF_8) }
  POUND_SIGN  = [0x00a3, 0x20a4].map{ |u| u.chr(Encoding::UTF_8) }
  LARI_SYMBOL = [0x20be, 0x10aa, 0x2d0a, 0x10da].map{ |u| u.chr(Encoding::UTF_8) }
  CEDI_SIGN   = [0x20b5].map{ |u| u.chr(Encoding::UTF_8) }
  YEN_SIGN    = [0x00a5, 0xffe5].map{ |u| u.chr(Encoding::UTF_8) }
  RIAL_SIGN   = [0xfdfc].map{ |u| u.chr(Encoding::UTF_8) }
  BAHT_SIGN   = [0x0e3f].map{ |u| u.chr(Encoding::UTF_8) }
  CURRENCY_SYMBOLS = DOLLAR_SIGN + EURO_SIGN + POUND_SIGN + LARI_SYMBOL + CEDI_SIGN + YEN_SIGN + RIAL_SIGN + BAHT_SIGN

  max = 1000
  # skipping currency symbols and symbols not allowed in the middle of a word
  in_symbols  = TEXT_SYMBOLS - CURRENCY_SYMBOLS - ['#', '@']
  in_words    = in_symbols.map { |s| "test#{s}word" } + in_symbols.map { |s| "testword#{s}" } + in_symbols.map { |s| "#{s}testword" } + ['@@lorem', 'lorem', '@lorem', '#lorem', 'lorem@lorem.com', 'lorem.ipsum@lorem.com', '666', '666.666', '666.666,666', '666,666.666', 'http://www.lorem.com', 'http://lorem.com', 'lorem.com'] + in_symbols
  out_words   = in_symbols.map { |s| "test#{s.scan(Regexp.new("[#{ADMITTED_SYMBOLS_IN_A_WORD.map { |w| Regexp.escape(w) }.join("")}]", "i")).size > 0 ? s : " "}word" } + in_symbols.map { |s| 'testword' } + in_symbols.map { |s| 'testword' } + ['lorem', 'lorem', '@lorem', '#lorem', 'lorem@lorem.com', 'lorem.ipsum@lorem.com', '666', '666.666', '666.666,666', '666,666.666', 'http://www.lorem.com', 'http://lorem.com', 'lorem.com']

  tests = []

  lut = {}
  in_words.each_with_index do |item, k|
    lut[item] = out_words[k] || ''
  end

  temp_in_words = []

  (0..max).collect do |i|
    temp_in_words = in_words if temp_in_words.empty?
    in_words_shuffle = temp_in_words.sort_by { rand }[0..rand(temp_in_words.size)].compact
    temp_in_words = temp_in_words - in_words_shuffle
    in_words_shuffle_string = in_words_shuffle.join(' ')
    out_words_shuffle = in_words_shuffle.map { |item| lut[item] }.flatten.compact
    out_words_shuffle_string = out_words_shuffle.join(' ')
    out_words_links_keywords_string = out_words_shuffle.map { |element| 'lorem' if element =~ /^http:\/\/www.lorem.com$|^http:\/\/lorem.com$/ }.compact.join(' ').to_s
    tests << [in_words_shuffle_string, "#{out_words_shuffle_string}#{" #{out_words_links_keywords_string}" if out_words_links_keywords_string.size > 0}"]
  end

  TOKENIZER = PragmaticTokenizer::Tokenizer.new(
    remove_stop_words: false,
    punctuation: :none,
    minimum_length: 1,
    remove_emoji: false,
    downcase: true,
    clean: true)

  # tests.uniq.each_with_index do |test, i|
  #   it "Testing no currency case #{i}: #{test[0]}" do
  #     check = test[1]
  #     tokenized = TOKENIZER.tokenize(test[0]).join(' ')
  #     puts "ORIGINAL"
  #     puts test[0]
      
  #     puts "TOKENIZED"
  #     puts tokenized
  #     puts "\n"
  #     puts "CHECK"
  #     puts check
  #     puts "\n\n"
  #     expect(tokenized).to eq(check)
  #   end
  # end
  
  it "tokenizes emoji" do
    emoji = Unicode::Emoji.list.keys.map{ |cat| Unicode::Emoji.list(cat).keys.map{|sub| Unicode::Emoji.list(cat, sub)}}.flatten
    tokenized = TOKENIZER.tokenize(emoji.join(' '))
    not_supported = ["☠️", "☀️", "☁️", "☂️", "☃️", "☄️", "☢️", "☣️", "☦️", "☮️", "©️", "®️", "™️", "*️⃣", "Ⓜ️", "🏴‍☠️"]
    expect(tokenized).to eq(emoji - not_supported)
  end

  it 'Testing currency after no space' do
    text = 'http://community.giffgaff.com RT @Diegyms: Mira la evolución de los generos músicales 50cent contemporáneos 20$ en 20 segundos. http://t.co/PI7EqoLwPG vía @ThomsonHolidays london5th o2'
    check= 'http://community.giffgaff.com rt @Diegyms mira la evolución de los generos músicales 50cent contemporáneos 20$ en 20 segundos http://t.co/PI7EqoLwPG vía @ThomsonHolidays london5th o2'
    expect(TOKENIZER.tokenize(text.dup).join(' ')).to eq(check)
  end

  it 'Testing currency after with space' do
    text = 'Ahí les va una pista del siguiente episodio de 12.00 $ #12especialesmasunoyundiademuertos en @r101ck http://t.co/lyDrfEBkHO'
    check = 'ahí les va una pista del siguiente episodio de 12.00 #12especialesmasunoyundiademuertos en @r101ck http://t.co/lyDrfEBkHO'
    expect(TOKENIZER.tokenize(text.dup).join(' ')).to eq(check)
  end

  it 'Testing currency before with no space' do
    text = 'Ahí les va una pista del siguiente episodio de $12.00 #12especialesmasunoyundiademuertos en @r101ck http://t.co/lyDrfEBkHO'
    check = 'ahí les va una pista del siguiente episodio de $12.00 #12especialesmasunoyundiademuertos en @r101ck http://t.co/lyDrfEBkHO'
    expect(TOKENIZER.tokenize(text.dup).join(' ')).to eq(check)
  end

  it 'Testing currency before with space' do
    text = 'Ahí les va una pista del siguiente episodio de $ 12.00 #12especialesmasunoyundiademuertos en @r101ck http://t.co/lyDrfEBkHO'
    check = 'ahí les va una pista del siguiente episodio de 12.00 #12especialesmasunoyundiademuertos en @r101ck http://t.co/lyDrfEBkHO'
    expect(TOKENIZER.tokenize(text.dup).join(' ')).to eq(check)
  end

  it 'Testing words with special text and numbers' do
    text  = "123_test VPL-FHZ58 VPL-FHZ58 one-two asd-123 poi_poi_123_sdfg 'asd'123 _asd&123"
    check = "123_test vpl-fhz58 vpl-fhz58 one-two asd-123 poi_poi_123_sdfg asd'123 asd&123"
    expect(TOKENIZER.tokenize(text.dup).join(' ')).to eq(check)
  end

  it "Testing for malformed indexing \uFFFE⁣⁣" do
    text = "#ABLVDevents⁣⁣\n“Teeth Health & Beauty”⁣⁣\nJoin us tomorrow for GCC Oral Health Week Event under the supervision of Ministry of Health ⁣⁣\nand under the patronage of Dr. Fatma Mohammed Al Ajmi ⁣\n⁣⁣\nThursday 28 March 2019 from 4-8 pm at #AlAraimiBoulevard⁣⁣\n*Free Dental Examination⁣⁣\n*Awareness Programs⁣⁣\n*Kids Corner⁣⁣\n*Gifts and Other Surprises⁣⁣\n⁣.\n\"الأسنان صحة وجمال\"⁣⁣\nشاركوا معنا في فعالیة الأسبوع الخلیجي الموحد لتعزیز صحة الفم والأسنان تحت إشراف \uFFFE#وزارة_الصحة وتحت رعایة الدكتورة ⁣⁣\nفاطمة بنت محمد العجمیة⁣\n⁣⁣\nالخمیس ٢٨ مارس ٢٠١٩ من ٤-٨ مساءاً في #العریمي_بولیفارد ⁣⁣\n*فحص مجاني للأسنان⁣⁣\n*أركان توعیة⁣⁣\n*ركن للاطفال⁣⁣\n*ھدایا ومفاجآت أخرى "
    check = '#ABLVDevents⁣⁣ teeth health beauty ⁣⁣ join us tomorrow for gcc oral health week event under the supervision of ministry of health ⁣⁣ and under the patronage of dr. fatma mohammed al ajmi ⁣ ⁣⁣ thursday 28 march 2019 from 4-8 pm at #AlAraimiBoulevard⁣⁣ free dental examination⁣⁣ awareness programs⁣⁣ kids corner⁣⁣ gifts and other surprises⁣⁣ ⁣ الأسنان صحة وجمال ⁣⁣ شاركوا معنا في فعالیة الأسبوع الخلیجي الموحد لتعزیز صحة الفم والأسنان تحت إشراف #وزارة_الصحة وتحت رعایة الدكتورة ⁣⁣ فاطمة بنت محمد العجمیة⁣ ⁣⁣ الخمیس ٢٨ مارس ٢٠١٩ من ٤ ٨ مساءاً في #العریمي_بولیفارد ⁣⁣ فحص مجاني للأسنان⁣⁣ أركان توعیة⁣⁣ ركن للاطفال⁣⁣ ھدایا ومفاجآت أخرى'
    expect(TOKENIZER.tokenize(text.dup).join(' ')).to eq(check)
  end

  it "Testing html" do
    text = '<script type="language/javascript">alert("foo")</script><div class="thread" id="t75360037"> <div class="postContainer opContainer" id="pc75360037"> <div id="p75360037" class="post op"> <div class="postInfoM mobile" id="pim75360037"> <span class="nameBlock"><span class="name">Anonymous</span><br><span class="subject"></span> </span><span class="dateTime postNum" data-utc="1586334960">04/08/20(Wed)04:36:00 <a href="#p75360037" title="Link to this post">No.</a><a href="javascript:quote(\'75360037\');" title="Reply to this post">75360037</a></span></div> <div class="file" id="f75360037"> <div class="fileText" id="fT75360037">File: <a href="//i.4cdn.org/g/1586334960971.jpg" target="_blank">thinkingpepe.jpg</a> (7 KB, 229x250)</div><a class="fileThumb" href="//i.4cdn.org/g/1586334960971.jpg" target="_blank"><img src="//i.4cdn.org/g/1586334960971s.jpg" alt="7 KB" data-md5="P1YV5O5Y4ILg2zeqOyy2gw==" style="height: 250px; width: 229px;"> <div data-tip data-tip-cb="mShowFull" class="mFileInfo mobile">7 KB JPG</div> </a> </div> <div class="postInfo desktop" id="pi75360037"><input type="checkbox" name="75360037" value="delete"> <span class="subject"></span> <span class="nameBlock"><span class="name">Anonymous</span> </span> <span class="dateTime" data-utc="1586334960">04/08/20(Wed)04:36:00</span> <span class="postNum desktop"><a href="#p75360037" title="Link to this post">No.</a><a href="javascript:quote(\'75360037\');" title="Reply to this post">75360037</a></span></div> <blockquote class="postMessage" id="m75360037">Guys im a new linux user. I turned off auto updates because one time it auto updated and fucked up my riced UI. <br>Is this OK? Or should i keep autoupdating everything and risk it breaking shit again?</blockquote> </div> </div> </div>'
    check = 'anonymous 04/08 20 wed 04:36:00 no. 75360037 file thinkingpepe jpg 7 kb 229x250 7 kb jpg anonymous 04/08 20 wed 04:36:00 no. 75360037 guys im a new linux user i turned off auto updates because one time it auto updated and fucked up my riced ui is this ok or should i keep autoupdating everything and risk it breaking shit again'
    expect(TOKENIZER.tokenize(text.dup).join(' ')).to eq(check)
  end

  it 'Testing BBcode' do
    text = "[QUOTE=thecoltguy;3166727]Here are a few:\n\n\n\n\n\n\n\n\n[URL=\"https://private.fotki.com/thecoltguy/bankers-special/100-4671.html\"][IMG]https://media.fotki.com/2v2HvDqQUxA5Rgm.jpg[/IMG][/URL][/QUOTE]\n\nMost Excellent Outstanding Post. Good Job.\n\n\n[B][URL=\"https://www.coltforum.com/forums/attachments/colt-semiauto-pistols/281690d1490370011-got-hammerless-old.jpg\"][B][FONT=Comic Sans MS][SIZE=2][COLOR=black][FONT=arial][SIZE=2][COLOR=black][SIZE=2][FONT=arial][SIZE=2][COLOR=black][SIZE=2][FONT=arial][SIZE=2][COLOR=black][SIZE=2][FONT=arial][SIZE=2][COLOR=black][SIZE=2][FONT=arial][SIZE=2][COLOR=black][SIZE=2][FONT=arial][SIZE=2][COLOR=black][SIZE=2][SIZE=1][B][FONT=Comic Sans MS][SIZE=2][COLOR=black][FONT=arial][SIZE=2][COLOR=black][SIZE=2][FONT=arial][SIZE=2][COLOR=black][SIZE=2][FONT=arial][SIZE=2][COLOR=black][SIZE=2][FONT=arial][SIZE=2][COLOR=black][SIZE=2][FONT=arial][SIZE=2][COLOR=black][SIZE=2][FONT=arial][SIZE=2][COLOR=black][SIZE=2][SIZE=1][B][FONT=Comic Sans MS][SIZE=2][COLOR=black][FONT=arial][SIZE=2][COLOR=black][SIZE=2][FONT=arial][SIZE=2][COLOR=black][SIZE=2][FONT=arial][SIZE=2][COLOR=black][SIZE=2][FONT=arial][SIZE=2][COLOR=black][SIZE=2][FONT=arial][SIZE=2][COLOR=black][SIZE=2][FONT=arial][SIZE=2][COLOR=black][SIZE=2][SIZE=1][B][FONT=Comic Sans MS][SIZE=2][COLOR=black][FONT=arial][SIZE=2][COLOR=black][SIZE=2][FONT=arial][SIZE=2][COLOR=black][SIZE=2][FONT=arial][SIZE=2][COLOR=black][SIZE=2][FONT=arial][SIZE=2][COLOR=black][SIZE=2][FONT=arial][SIZE=2][COLOR=black][SIZE=2][FONT=arial][SIZE=2][COLOR=black][SIZE=2][SIZE=1][B][FONT=Comic Sans MS][SIZE=2][COLOR=black][FONT=arial][SIZE=2][COLOR=black][SIZE=2][FONT=arial][SIZE=2][COLOR=black][SIZE=2][FONT=arial][SIZE=2][COLOR=black][SIZE=2][FONT=arial][SIZE=2][COLOR=black][SIZE=2][FONT=arial][SIZE=2][COLOR=black][SIZE=2][FONT=arial][SIZE=2][COLOR=black][SIZE=2][SIZE=1][B][FONT=Comic Sans MS][SIZE=2][COLOR=black][FONT=arial][SIZE=2][COLOR=black][SIZE=2][FONT=arial][SIZE=2][COLOR=black][SIZE=2][FONT=arial][SIZE=2][COLOR=black][SIZE=2][FONT=arial][SIZE=2][COLOR=black][SIZE=2][FONT=arial][SIZE=2][COLOR=black][SIZE=2][FONT=arial][SIZE=2][COLOR=black][SIZE=2][SIZE=1][B][FONT=Comic Sans MS][SIZE=2][COLOR=black][FONT=arial][SIZE=2][COLOR=black][SIZE=2][FONT=arial][SIZE=2][COLOR=black][SIZE=2][FONT=arial][SIZE=2][COLOR=black][SIZE=2][FONT=arial][SIZE=2][COLOR=black][SIZE=2][FONT=arial][SIZE=2][COLOR=black][SIZE=2][FONT=arial][SIZE=2][COLOR=black][SIZE=2][SIZE=1][B][B][SIZE=3][FONT=Comic Sans MS][SIZE=2][COLOR=black][FONT=arial][SIZE=2][COLOR=black][SIZE=2][FONT=arial][SIZE=2][COLOR=black][SIZE=2][FONT=arial][SIZE=2][COLOR=black][SIZE=2][FONT=arial][SIZE=2][COLOR=black][SIZE=2][FONT=arial][SIZE=2][COLOR=black][SIZE=2][FONT=arial][SIZE=2][COLOR=black][SIZE=2][SIZE=1][SIZE=3][B][B][FONT=Comic Sans MS][SIZE=2][COLOR=black][FONT=arial][SIZE=2][COLOR=black][SIZE=2][FONT=arial][SIZE=2][COLOR=black][SIZE=2][FONT=arial][SIZE=2][COLOR=black][SIZE=2][FONT=arial][SIZE=2][COLOR=black][SIZE=2][FONT=arial][SIZE=2][COLOR=black][SIZE=2][FONT=arial][SIZE=2][COLOR=black][SIZE=2][SIZE=1][B][FONT=Comic Sans MS][SIZE=2][COLOR=black][FONT=arial][SIZE=2][COLOR=black][SIZE=2][FONT=arial][SIZE=2][COLOR=black][SIZE=2][FONT=arial][SIZE=2][COLOR=black][SIZE=2][FONT=arial][SIZE=2][COLOR=black][SIZE=2][FONT=arial][SIZE=2][COLOR=black][SIZE=2][FONT=arial][SIZE=2][COLOR=black][SIZE=2][SIZE=1][B][FONT=Comic Sans MS][SIZE=2][COLOR=black][FONT=arial][SIZE=2][COLOR=black][SIZE=2][FONT=arial][SIZE=2][COLOR=black][SIZE=2][FONT=arial][SIZE=2][COLOR=black][SIZE=2][FONT=arial][SIZE=2][COLOR=black][SIZE=2][FONT=arial][SIZE=2][COLOR=black][SIZE=2][FONT=arial][SIZE=2][COLOR=black][SIZE=2][SIZE=1][B][FONT=Comic Sans MS][SIZE=2][COLOR=black][FONT=arial][SIZE=2][COLOR=black][SIZE=2][FONT=arial][SIZE=2][COLOR=black][SIZE=2][FONT=arial][SIZE=2][COLOR=black][SIZE=2][FONT=arial][SIZE=2][COLOR=black][SIZE=2][FONT=arial][SIZE=2][COLOR=black][SIZE=2][FONT=arial][SIZE=2][COLOR=black][SIZE=2][SIZE=1][B][FONT=Comic Sans MS][SIZE=2][COLOR=black][FONT=arial][SIZE=2][COLOR=black][SIZE=2][FONT=arial][SIZE=2][COLOR=black][SIZE=2][FONT=arial][SIZE=2][COLOR=black][SIZE=2][FONT=arial][SIZE=2][COLOR=black][SIZE=2][FONT=arial][SIZE=2][COLOR=black][SIZE=2][FONT=arial][SIZE=2][COLOR=black][SIZE=2][SIZE=1][B][FONT=Comic Sans MS][SIZE=2][COLOR=black][FONT=arial][SIZE=2][COLOR=black][SIZE=2][FONT=arial][SIZE=2][COLOR=black][SIZE=2][FONT=arial][SIZE=2][COLOR=black][SIZE=2][FONT=arial][SIZE=2][COLOR=black][SIZE=2][FONT=arial][SIZE=2][COLOR=black][SIZE=2][FONT=arial][SIZE=2][COLOR=black][SIZE=2][SIZE=1][B][FONT=Comic Sans MS][SIZE=2][COLOR=black][FONT=arial][SIZE=2][COLOR=black][SIZE=2][FONT=arial][SIZE=2][COLOR=black][SIZE=2][FONT=arial][SIZE=2][COLOR=black][SIZE=2][FONT=arial][SIZE=2][COLOR=black][SIZE=2][FONT=arial][SIZE=2][COLOR=black][SIZE=2][FONT=arial][SIZE=2][COLOR=black][SIZE=2][SIZE=1][B][B][SIZE=3][FONT=Comic Sans MS][SIZE=2][COLOR=black][FONT=arial][SIZE=2][COLOR=black][SIZE=2][FONT=arial][SIZE=2][COLOR=black][SIZE=2][FONT=arial][SIZE=2][COLOR=black][SIZE=2][FONT=arial][SIZE=2][COLOR=black][SIZE=2][FONT=arial][SIZE=2][COLOR=black][SIZE=2][FONT=arial][SIZE=2][COLOR=black][SIZE=2][SIZE=1][SIZE=3][B]ei8ht[/B][B][B][FONT=Comic Sans MS][SIZE=2][COLOR=black][FONT=arial][SIZE=2][COLOR=black][SIZE=2][FONT=arial][SIZE=2][COLOR=black][SIZE=2][FONT=arial][SIZE=2][COLOR=black][SIZE=2][FONT=arial][SIZE=2][COLOR=black][SIZE=1]®[/SIZE][/COLOR][/SIZE][/FONT][/SIZE][/COLOR][/SIZE][/FONT][/SIZE][/COLOR][/SIZE][/FONT][/SIZE][/COLOR][/SIZE][/FONT][/COLOR][/SIZE][/FONT][/B][/B][/SIZE][/SIZE][/SIZE][/COLOR][/SIZE][/FONT][/SIZE][/COLOR][/SIZE][/FONT][/SIZE][/COLOR][/SIZE][/FONT][/SIZE][/COLOR][/SIZE][/FONT][/SIZE][/COLOR][/SIZE][/FONT][/SIZE][/COLOR][/SIZE][/FONT][/COLOR][/SIZE][/FONT][/SIZE][/B][/B][/SIZE][/SIZE][/COLOR][/SIZE][/FONT][/SIZE][/COLOR][/SIZE][/FONT][/SIZE][/COLOR][/SIZE][/FONT][/SIZE][/COLOR][/SIZE][/FONT][/SIZE][/COLOR][/SIZE][/FONT][/SIZE][/COLOR][/SIZE][/FONT][/COLOR][/SIZE][/FONT][/B][/SIZE][/SIZE][/COLOR][/SIZE][/FONT][/SIZE][/COLOR][/SIZE][/FONT][/SIZE][/COLOR][/SIZE][/FONT][/SIZE][/COLOR][/SIZE][/FONT][/SIZE][/COLOR][/SIZE][/FONT][/SIZE][/COLOR][/SIZE][/FONT][/COLOR][/SIZE][/FONT][/B][/SIZE][/SIZE][/COLOR][/SIZE][/FONT][/SIZE][/COLOR][/SIZE][/FONT][/SIZE][/COLOR][/SIZE][/FONT][/SIZE][/COLOR][/SIZE][/FONT][/SIZE][/COLOR][/SIZE][/FONT][/SIZE][/COLOR][/SIZE][/FONT][/COLOR][/SIZE][/FONT][/B][/SIZE][/SIZE][/COLOR][/SIZE][/FONT][/SIZE][/COLOR][/SIZE][/FONT][/SIZE][/COLOR][/SIZE][/FONT][/SIZE][/COLOR][/SIZE][/FONT][/SIZE][/COLOR][/SIZE][/FONT][/SIZE][/COLOR][/SIZE][/FONT][/COLOR][/SIZE][/FONT][/B][/SIZE][/SIZE][/COLOR][/SIZE][/FONT][/SIZE][/COLOR][/SIZE][/FONT][/SIZE][/COLOR][/SIZE][/FONT][/SIZE][/COLOR][/SIZE][/FONT][/SIZE][/COLOR][/SIZE][/FONT][/SIZE][/COLOR][/SIZE][/FONT][/COLOR][/SIZE][/FONT][/B][/SIZE][/SIZE][/COLOR][/SIZE][/FONT][/SIZE][/COLOR][/SIZE][/FONT][/SIZE][/COLOR][/SIZE][/FONT][/SIZE][/COLOR][/SIZE][/FONT][/SIZE][/COLOR][/SIZE][/FONT][/SIZE][/COLOR][/SIZE][/FONT][/COLOR][/SIZE][/FONT][/B][/SIZE][/SIZE][/COLOR][/SIZE][/FONT][/SIZE][/COLOR][/SIZE][/FONT][/SIZE][/COLOR][/SIZE][/FONT][/SIZE][/COLOR][/SIZE][/FONT][/SIZE][/COLOR][/SIZE][/FONT][/SIZE][/COLOR][/SIZE][/FONT][/COLOR][/SIZE][/FONT][/B][/B][/SIZE][/SIZE][/SIZE][/COLOR][/SIZE][/FONT][/SIZE][/COLOR][/SIZE][/FONT][/SIZE][/COLOR][/SIZE][/FONT][/SIZE][/COLOR][/SIZE][/FONT][/SIZE][/COLOR][/SIZE][/FONT][/SIZE][/COLOR][/SIZE][/FONT][/COLOR][/SIZE][/FONT][/SIZE][/B][/B][/SIZE][/SIZE][/COLOR][/SIZE][/FONT][/SIZE][/COLOR][/SIZE][/FONT][/SIZE][/COLOR][/SIZE][/FONT][/SIZE][/COLOR][/SIZE][/FONT][/SIZE][/COLOR][/SIZE][/FONT][/SIZE][/COLOR][/SIZE][/FONT][/COLOR][/SIZE][/FONT][/B][/SIZE][/SIZE][/COLOR][/SIZE][/FONT][/SIZE][/COLOR][/SIZE][/FONT][/SIZE][/COLOR][/SIZE][/FONT][/SIZE][/COLOR][/SIZE][/FONT][/SIZE][/COLOR][/SIZE][/FONT][/SIZE][/COLOR][/SIZE][/FONT][/COLOR][/SIZE][/FONT][/B][/SIZE][/SIZE][/COLOR][/SIZE][/FONT][/SIZE][/COLOR][/SIZE][/FONT][/SIZE][/COLOR][/SIZE][/FONT][/SIZE][/COLOR][/SIZE][/FONT][/SIZE][/COLOR][/SIZE][/FONT][/SIZE][/COLOR][/SIZE][/FONT][/COLOR][/SIZE][/FONT][/B][/SIZE][/SIZE][/COLOR][/SIZE][/FONT][/SIZE][/COLOR][/SIZE][/FONT][/SIZE][/COLOR][/SIZE][/FONT][/SIZE][/COLOR][/SIZE][/FONT][/SIZE][/COLOR][/SIZE][/FONT][/SIZE][/COLOR][/SIZE][/FONT][/COLOR][/SIZE][/FONT][/B][/SIZE][/SIZE][/COLOR][/SIZE][/FONT][/SIZE][/COLOR][/SIZE][/FONT][/SIZE][/COLOR][/SIZE][/FONT][/SIZE][/COLOR][/SIZE][/FONT][/SIZE][/COLOR][/SIZE][/FONT][/SIZE][/COLOR][/SIZE][/FONT][/COLOR][/SIZE][/FONT][/B][/SIZE][/SIZE][/COLOR][/SIZE][/FONT][/SIZE][/COLOR][/SIZE][/FONT][/SIZE][/COLOR][/SIZE][/FONT][/SIZE][/COLOR][/SIZE][/FONT][/SIZE][/COLOR][/SIZE][/FONT][/SIZE][/COLOR][/SIZE][/FONT][/COLOR][/SIZE][/FONT][/B][/SIZE][/SIZE][/COLOR][/SIZE][/FONT][/SIZE][/COLOR][/SIZE][/FONT][/SIZE][/COLOR][/SIZE][/FONT][/SIZE][/COLOR][/SIZE][/FONT][/SIZE][/COLOR][/SIZE][/FONT][/SIZE][/COLOR][/SIZE][/FONT][/COLOR][/SIZE][/FONT][/B][/URL][SIZE=3][URL=\"https://www.coltforum.com/forums/colt-semiauto-pistols/191777-got-hammerless.html\"]\nGot Hammerless?[/URL]                 [FONT=Comic Sans MS][SIZE=2][COLOR=black][FONT=arial][SIZE=2][COLOR=black][SIZE=2][FONT=arial][SIZE=2][COLOR=black][SIZE=2][FONT=arial][SIZE=2][COLOR=black][SIZE=2][FONT=arial][SIZE=2][COLOR=black][SIZE=2][FONT=arial][SIZE=2][COLOR=black][SIZE=2][FONT=arial][SIZE=2][COLOR=black][SIZE=2][SIZE=1]\n[SIZE=3][SIZE=2][B]OGCA Life Member[/B][/SIZE][/SIZE][/SIZE][/SIZE][/COLOR][/SIZE][/FONT][/SIZE][/COLOR][/SIZE][/FONT][/SIZE][/COLOR][/SIZE][/FONT][/SIZE][/COLOR][/SIZE][/FONT][/SIZE][/COLOR][/SIZE][/FONT][/SIZE][/COLOR][/SIZE][/FONT][/COLOR][/SIZE][/FONT][/SIZE][/B]              [URL=\"https://www.coltforum.com/forums/attachments/colt-semiauto-pistols/488306d1518063261-got-hammerless-lpd-22-23-6-copy.jpg\"] [/URL]"
    check = 'here are a few https://media.fotki.com/2v2HvDqQUxA5Rgm.jpg most excellent outstanding post good job ei8ht got hammerless ogca life member'
    expect(TOKENIZER.tokenize(text.dup).join(' ')).to eq(check)
  end

  it 'Testing base64 images' do
    text = '<h1 class="fs14 pB10">Guggenheim\'s select 2019 #biotech catalysts (Jun \'19)</h1><div id="divMessageText" class="fs12 ceFontFix"><span style="font-size: 12pt;"><br /><div>&nbsp; fyi and dd </div><div>(Twitter; <a target="_blank" href="https://twitter.com/syinvesting/status/1140944747768324096">https://twitter.com/syinvesting/status/1140944747768324096 )</a></div><div>&nbsp;</div><div><img src="data:image/jpeg;base64,iVBORw0KGgoAAAANSUhEUgAAAlMAAAQFCAYAAACV="> <p>paragraph1</p> <img src="data:image/gif;charset=utf-8;base64,iVBORw0KGgoAAAANSUhEUgAAAlMAAAQFCAYAAACV="> <p>paragraph2</p> <img src="data:;base64,iVBORw0KGgoAAAANSUhEUgAAAlMAAAQFCAYAAACV="> <p>paragraph3</p> </div> </div>'
    check = "guggenheim's select 2019 #biotech catalysts jun 19 fyi and dd twitter https://twitter.com/syinvesting/status/1140944747768324096 paragrap paragraph2 paragraph3"
    expect(TOKENIZER.tokenize(text.dup).join(' ')).to eq(check)
  end
end