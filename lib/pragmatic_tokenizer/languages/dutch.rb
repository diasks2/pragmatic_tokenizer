module PragmaticTokenizer
  module Languages
    module Dutch
      include Languages::Common
      ABBREVIATIONS = Set.new([]).freeze
      STOP_WORDS    = Set.new(%w[aan af al als bij dan dat die dit een en er had heb hem het hij hoe hun ik in is je kan me men met mij nog nu of ons ook te tot uit van was wat we wel wij zal ze zei zij zo zou aan aangaande aangezien achter achterna afgelopen aldaar aldus alhoewel alias alle allebei alleen alsnog altijd altoos ander andere anders anderszins behalve behoudens beide beiden ben beneden bent bepaald betreffende binnen binnenin boven bovenal bovendien bovengenoemd bovenstaand bovenvermeld buiten daar daarheen daarin daarna daarnet daarom daarop daarvanlangs de dikwijls door doorgaand dus echter eer eerdat eerder eerlang eerst elk elke enig enigszins enkel erdoor even eveneens evenwel gauw gedurende geen gehad gekund geleden gelijk gemoeten gemogen geweest gewoon gewoonweg haar hadden hare hebben hebt heeft hen hierbeneden hierboven hoewel hunne ikzelf inmiddels inzake jezelf jij jijzelf jou jouw jouwe juist jullie klaar kon konden krachtens kunnen kunt later liever maar mag meer mezelf mijn mijnent mijner mijzelf misschien mocht mochten moest moesten moet moeten mogen na naar nadat net niet noch nogal ofschoon om omdat omhoog omlaag omstreeks omtrent omver onder ondertussen ongeveer onszelf onze op opnieuw opzij over overeind overigens pas precies reeds rond rondom sedert sinds sindsdien slechts sommige spoedig steeds tamelijk tenzij terwijl thans tijdens toch toen toenmaals toenmalig totdat tussen uitgezonderd vaakwat vandaan vanuit vanwege veeleer verder vervolgens vol volgens voor vooraf vooral vooralsnog voorbij voordat voordezen voordien voorheen voorop vooruit vrij vroeg waar waarom wanneer want waren weer weg wegens weldra welk welke wie wiens wier wijzelf zelfs zichzelf zijn zijne zodra zonder zouden zowat zulke zullen zult worden wordt deze]).freeze
      CONTRACTIONS  = {}.freeze
    end
  end
end
