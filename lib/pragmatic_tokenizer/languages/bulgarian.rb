module PragmaticTokenizer
  module Languages
    module Bulgarian
      include Languages::Common
      ABBREVIATIONS = Set.new(%w[акад ал б.р б.ред бел.а бел.пр бр бул в вж вкл вм вр г ген гр дж дм доц др ем заб зам инж к.с кв кв.м кг км кор куб куб.м л лв м м.г мин млн млрд мм н.с напр пл полк проф р рис с св сек см сп срв ст стр т т.г т.е т.н т.нар табл тел у ул фиг ха хил ч чл щ.д]).freeze
      STOP_WORDS = File.open("lib/pragmatic_tokenizer/stopwords/#{name.to_s.split('::').last.downcase}.txt").read.split("\n").freeze
      CONTRACTIONS  = {}.freeze
    end
  end
end
