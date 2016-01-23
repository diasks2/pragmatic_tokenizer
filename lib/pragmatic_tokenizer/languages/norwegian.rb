module PragmaticTokenizer
  module Languages
    module Norwegian
      include Languages::Common
      ABBREVIATIONS = [].freeze
      STOP_WORDS = ["alle", "andre", "arbeid", "av", "bare", "begge", "bli", "bort", "bra", "bruk", "bruke", "da", "deg", "denne", "der", "deres", "det", "dette", "din", "disse", "du", "eller", "en", "ene", "eneste", "enhver", "enn", "er", "et", "folk", "for", "fordi", "forsûke", "fra", "få", "før", "fûr", "fûrst", "gjorde", "gjûre", "god", "gå", "ha", "hadde", "han", "hans", "har", "hennes", "her", "hun", "hva", "hvem", "hver", "hvilken", "hvis", "hvor", "hvordan", "hvorfor", "i", "ikke", "inn", "innen", "jeg", "kan", "kunne", "lage", "lang", "lik", "like", "makt", "mange", "med", "meg", "meget", "men", "mens", "mer", "mest", "min", "mot", "mye", "må", "måte", "navn", "nei", "noen", "ny", "nå", "når", "og", "også", "om", "opp", "oss", "over", "part", "punkt", "på", "rett", "riktig", "samme", "sant", "seg", "sett", "si", "siden", "sist", "skulle", "slik", "slutt", "som", "start", "stille", "så", "tid", "til", "tilbake", "tilstand", "under", "ut", "uten", "var", "ved", "verdi", "vi", "vil", "ville", "vite", "vår", "vöre", "vört", "å"].freeze
      CONTRACTIONS = {}.freeze
    end
  end
end
