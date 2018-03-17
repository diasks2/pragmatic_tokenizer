module PragmaticTokenizer
  module Languages
    module Slovak
      include Languages::Common
      ABBREVIATIONS = Set.new([]).freeze
      STOP_WORDS    = Set.new(%w[a aby aj ak ako ale alebo and ani áno asi až bez bude budem budeš budeme budete budú by bol bola boli bolo byť cez čo či ďalší ďalšia ďalšie dnes do ho ešte for i ja je jeho jej ich iba iné iný som si sme sú k kam každý každá každé každí kde keď kto ktorá ktoré ktorou ktorý ktorí ku lebo len ma mať má máte medzi mi mna mne mnou musieť môcť môj môže my na nad nám náš naši nie nech než nič niektorý nové nový nová noví o od odo of on ona ono oni ony po pod podľa pokiaľ potom práve pre prečo preto pretože prvý prvá prvé prví pred predo pri pýta s sa so svoje svoj svojich svojím svojími ta tak takže táto teda te tě ten tento the tieto tým týmto tiež to toto toho tohoto tom tomto tomuto tu tú túto tvoj ty tvojími už v vám váš vaše vo viac však všetok vy z za zo že a buď ju menej moja moje späť ste tá tam]).freeze
      CONTRACTIONS  = {}.freeze
    end
  end
end
