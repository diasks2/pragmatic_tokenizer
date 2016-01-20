module PragmaticTokenizer
  class PostProcessor

    attr_reader :text, :abbreviations
    def initialize(text:, abbreviations:)
      @text = text
      @abbreviations = abbreviations
    end

    def post_process
      tokens = text.split
        .flat_map { |t| (t[0] == '‚' || t[0] == ',') && t.length > 1 ? t.split(/(,|‚)/).flatten : t }
        .flat_map { |t| (t[-1] == '’' || t[-1] == "'" || t[-1] == '‘' || t[-1] == '`') && t.length > 1 ? t.split(/(’|'|‘|`)/).flatten : t }
        .map { |t| convert_sym_to_punct(t) }
      full_stop_separated_tokens = FullStopSeparator.new(tokens: tokens, abbreviations: abbreviations).separate
      EndingPunctuationSeparator.new(tokens: EndingPunctuationSeparator.new(tokens: full_stop_separated_tokens).separate.flat_map { |t| t.include?("/") && t !~ /(http|https|www)(\.|:)/ ? t.gsub!(/\//, '\1 \2').split(' ').flatten : t }
        .flat_map { |t| t.include?("?") && t !~ /(http|https|www)(\.|:)/ && t.length > 1 ? t.gsub(/\?/, '\1 \2').split(' ').flatten : t }
        .flat_map { |t| t.include?("+") ? t.gsub!(/\+/, '\1 \2').split(' ').flatten : t }
        .flat_map { |t| t =~ /\A\.[^\.]/ && t.length > 1 ? t.gsub(/\./, '\1 ').split(' ').flatten : t }
        .flat_map { |t| t =~ /\A\:\S{2,}/ ? t.gsub(/\:/, ': ').split(' ').flatten : t }
        .flat_map { |t| t.include?(".") &&
          t !~ /(http|https|www)(\.|:)/ &&
          t !~ /\.(com|net|org|edu|gov|mil|int)/ &&
          t !~ /\.[a-z]{2}/ &&
          t.length > 2 &&
          t !~ /\A[a-zA-Z]{1}\./ &&
          t.count(".") == 1 &&
          t !~ /\d+/ &&
          !abbreviations.include?(Unicode::downcase(t.split(".")[0] == nil ? '' : t.split(".")[0])) &&
          t !~ /\S+(＠|@)\S+/ ? t.gsub(/\./, '\1 . \2').split(' ').flatten : t }
        .flat_map { |t| t.include?(".") &&
          t !~ /(http|https|www)(\.|:)/ &&
          t.length > 1 &&
          t !~ /(\s+|\A)[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,6}(:[0-9]{1,5})?(\/.*)?/ix &&
          t !~ /\S+(＠|@)\S+/ &&
          abbreviations.include?(Unicode::downcase(t.split(".")[0] == nil ? '' : t.split(".")[0])) ? t.gsub(/\./, '\1. \2').split(' ').flatten : t }
        .flat_map { |t| t =~ PragmaticTokenizer::Languages::Common::PREFIX_EMOJI_REGEX ? t.gsub(PragmaticTokenizer::Languages::Common::PREFIX_EMOJI_REGEX, '\1 \2').split(' ').flatten : t }
        .flat_map { |t| t =~ PragmaticTokenizer::Languages::Common::POSTFIX_EMOJI_REGEX ? t.gsub(PragmaticTokenizer::Languages::Common::POSTFIX_EMOJI_REGEX, '\1 \2').split(' ').flatten : t }
      ).separate
    end

    private

    def convert_sym_to_punct(token)
      symbol_matches = /[♳ ♴ ♵ ♶ ♷ ♸ ♹ ♺ ⚀ ⚁ ⚂ ⚃ ⚄ ⚅ ☇ ☈ ☉ ☊ ☋ ☌ ☍ ☠ ☢ ☣ ☤ ☥ ☦ ☧ ☀ ☁ ☂ ☃ ☄ ☮ ♔ ♕ ♖ ♗ ♘ ♙ ♚ ⚘ ⚭]/.match(token)
      symbol_matches.nil? ? token : token.gsub!(symbol_matches[0], PragmaticTokenizer::Languages::Common::PUNCTUATION_MAP.key(symbol_matches[0]))
    end
  end
end
