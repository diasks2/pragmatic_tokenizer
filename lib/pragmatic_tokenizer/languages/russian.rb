module PragmaticTokenizer
  module Languages
    module Russian
      include Languages::Common
      ABBREVIATIONS = Set.new(%w[y y.e а авт адм.-терр акад в вв вкз вост.-европ г гг гос гр д деп дисс дол долл ежедн ж жен з зап зап.-европ заруб и ин иностр инст к канд кв кг куб л л.h л.н м мин моск муж н нед о п пгт пер пп пр просп проф р руб с сек см спб стр т тел тов тт тыс у у.е ул ф ч]).freeze
      STOP_WORDS = File.open("lib/pragmatic_tokenizer/stopwords/#{name.to_s.split('::').last.downcase}.txt").read.split("\n").freeze
      CONTRACTIONS  = {}.freeze
    end
  end
end
