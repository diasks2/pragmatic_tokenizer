module PragmaticTokenizer
  class Regex

    # Things that can or should be done:
    # - check where the use of unicode categories helps (\p{Abbreviation})
    # - use URI.parse and other libraries instead of regexp to identify urls, domains, emails
    # - check multiple domain regex, we have spec issues when using one or the other
    # - check multiple punctuation regex

    # Text that needs to be tokenized is initially split into chunks of this length:
    CHUNK_LONG_INPUT_TEXT         = /\S.{1,10000}(?!\S)/m

    # Ranges
    #RANGE_EMOJI                   = /[\u{00A9}\u{00AE}\u{203C}\u{2049}\u{2122}\u{2139}\u{2194}-\u{2199}\u{21A9}-\u{21AA}\u{231A}-\u{231B}\u{2328}\u{23CF}\u{23E9}-\u{23F3}\u{23F8}-\u{23FA}\u{24C2}\u{25AA}-\u{25AB}\u{25B6}\u{25C0}\u{25FB}-\u{25FE}\u{2600}-\u{2604}\u{260E}\u{2611}\u{2614}-\u{2615}\u{2618}\u{261D}\u{2620}\u{2622}-\u{2623}\u{2626}\u{262A}\u{262E}-\u{262F}\u{2638}-\u{263A}\u{2640}\u{2642}\u{2648}-\u{2653}\u{2660}\u{2663}\u{2665}-\u{2666}\u{2668}\u{267B}\u{267F}\u{2692}-\u{2697}\u{2699}\u{269B}-\u{269C}\u{26A0}-\u{26A1}\u{26AA}-\u{26AB}\u{26B0}-\u{26B1}\u{26BD}-\u{26BE}\u{26C4}-\u{26C5}\u{26C8}\u{26CE}-\u{26CF}\u{26D1}\u{26D3}-\u{26D4}\u{26E9}-\u{26EA}\u{26F0}-\u{26F5}\u{26F7}-\u{26FA}\u{26FD}\u{2702}\u{2705}\u{2708}-\u{270D}\u{270F}\u{2712}\u{2714}\u{2716}\u{271D}\u{2721}\u{2728}\u{2733}-\u{2734}\u{2744}\u{2747}\u{274C}\u{274E}\u{2753}-\u{2755}\u{2757}\u{2763}-\u{2764}\u{2795}-\u{2797}\u{27A1}\u{27B0}\u{27BF}\u{2934}-\u{2935}\u{2B05}-\u{2B07}\u{2B1B}-\u{2B1C}\u{2B50}\u{2B55}\u{3030}\u{303D}\u{3297}\u{3299}\u{1F004}\u{1F0CF}\u{1F170}-\u{1F171}\u{1F17E}-\u{1F17F}\u{1F18E}\u{1F191}-\u{1F19A}\u{1F1E6}-\u{1F1FF}\u{1F201}-\u{1F202}\u{1F21A}\u{1F22F}\u{1F232}-\u{1F23A}\u{1F250}-\u{1F251}\u{1F300}-\u{1F321}\u{1F324}-\u{1F393}\u{1F396}-\u{1F397}\u{1F399}-\u{1F39B}\u{1F39E}-\u{1F3F0}\u{1F3F3}-\u{1F3F5}\u{1F3F7}-\u{1F4FD}\u{1F4FF}-\u{1F53D}\u{1F549}-\u{1F54E}\u{1F550}-\u{1F567}\u{1F56F}-\u{1F570}\u{1F573}-\u{1F57A}\u{1F587}\u{1F58A}-\u{1F58D}\u{1F590}\u{1F595}-\u{1F596}\u{1F5A4}-\u{1F5A5}\u{1F5A8}\u{1F5B1}-\u{1F5B2}\u{1F5BC}\u{1F5C2}-\u{1F5C4}\u{1F5D1}-\u{1F5D3}\u{1F5DC}-\u{1F5DE}\u{1F5E1}\u{1F5E3}\u{1F5E8}\u{1F5EF}\u{1F5F3}\u{1F5FA}-\u{1F64F}\u{1F680}-\u{1F6C5}\u{1F6CB}-\u{1F6D2}\u{1F6E0}-\u{1F6E5}\u{1F6E9}\u{1F6EB}-\u{1F6EC}\u{1F6F0}\u{1F6F3}-\u{1F6F8}\u{1F910}-\u{1F93A}\u{1F93C}-\u{1F93E}\u{1F940}-\u{1F945}\u{1F947}-\u{1F94C}\u{1F950}-\u{1F96B}\u{1F980}-\u{1F997}\u{1F9C0}\u{1F9D0}-\u{1F9E6}\u{200D}\u{20E3}\u{FE0F}\u{E0020}-\u{E007F}\u{2388}\u{2605}\u{2607}-\u{260D}\u{260F}-\u{2610}\u{2612}\u{2616}-\u{2617}\u{2619}-\u{261C}\u{261E}-\u{261F}\u{2621}\u{2624}-\u{2625}\u{2627}-\u{2629}\u{262B}-\u{262D}\u{2630}-\u{2637}\u{263B}-\u{263F}\u{2641}\u{2643}-\u{2647}\u{2654}-\u{265F}\u{2661}-\u{2662}\u{2664}\u{2667}\u{2669}-\u{267A}\u{267C}-\u{267E}\u{2680}-\u{2691}\u{2698}\u{269A}\u{269D}-\u{269F}\u{26A2}-\u{26A9}\u{26AC}-\u{26AF}\u{26B2}-\u{26BC}\u{26BF}-\u{26C3}\u{26C6}-\u{26C7}\u{26C9}-\u{26CD}\u{26D0}\u{26D2}\u{26D5}-\u{26E8}\u{26EB}-\u{26EF}\u{26F6}\u{26FB}-\u{26FC}\u{26FE}-\u{2701}\u{2703}-\u{2704}\u{270E}\u{2710}-\u{2711}\u{2765}-\u{2767}\u{1F000}-\u{1F003}\u{1F005}-\u{1F0CE}\u{1F0D0}-\u{1F0FF}\u{1F10D}-\u{1F10F}\u{1F12F}\u{1F16C}-\u{1F16F}\u{1F1AD}-\u{1F1E5}\u{1F203}-\u{1F20F}\u{1F23C}-\u{1F23F}\u{1F249}-\u{1F24F}\u{1F252}-\u{1F2FF}\u{1F322}-\u{1F323}\u{1F394}-\u{1F395}\u{1F398}\u{1F39C}-\u{1F39D}\u{1F3F1}-\u{1F3F2}\u{1F3F6}\u{1F4FE}\u{1F53E}-\u{1F548}\u{1F54F}\u{1F568}-\u{1F56E}\u{1F571}-\u{1F572}\u{1F57B}-\u{1F586}\u{1F588}-\u{1F589}\u{1F58E}-\u{1F58F}\u{1F591}-\u{1F594}\u{1F597}-\u{1F5A3}\u{1F5A6}-\u{1F5A7}\u{1F5A9}-\u{1F5B0}\u{1F5B3}-\u{1F5BB}\u{1F5BD}-\u{1F5C1}\u{1F5C5}-\u{1F5D0}\u{1F5D4}-\u{1F5DB}\u{1F5DF}-\u{1F5E0}\u{1F5E2}\u{1F5E4}-\u{1F5E7}\u{1F5E9}-\u{1F5EE}\u{1F5F0}-\u{1F5F2}\u{1F5F4}-\u{1F5F9}\u{1F6C6}-\u{1F6CA}\u{1F6D3}-\u{1F6DF}\u{1F6E6}-\u{1F6E8}\u{1F6EA}\u{1F6ED}-\u{1F6EF}\u{1F6F1}-\u{1F6F2}\u{1F6F9}-\u{1F6FF}\u{1F774}-\u{1F77F}\u{1F7D5}-\u{1F7FF}\u{1F80C}-\u{1F80F}\u{1F848}-\u{1F84F}\u{1F85A}-\u{1F85F}\u{1F888}-\u{1F88F}\u{1F8AE}-\u{1F90F}\u{1F93F}\u{1F94D}-\u{1F94F}\u{1F96C}-\u{1F97F}\u{1F998}-\u{1F9BF}\u{1F9C1}-\u{1F9CF}]/ # e.g. ✁✎✳❄➾
    RANGE_EMOJI                   = /[\uFE0E\u{00A9}\u{00AE}\u{203C}\u{2049}\u{2122}\u{2139}\u{2194}-\u{2199}\u{21A9}-\u{21AA}\u{231A}-\u{231B}\u{2328}\u{23CF}\u{23E9}-\u{23F3}\u{23F8}-\u{23FA}\u{24C2}\u{25AA}-\u{25AB}\u{25B6}\u{25C0}\u{25FB}-\u{25FE}\u{2600}-\u{2604}\u{260E}\u{2611}\u{2614}-\u{2615}\u{2618}\u{261D}\u{2620}\u{2622}-\u{2623}\u{2626}\u{262A}\u{262E}-\u{262F}\u{2638}-\u{263A}\u{2648}-\u{2653}\u{2660}\u{2663}\u{2665}-\u{2666}\u{2668}\u{267B}\u{267F}\u{2692}-\u{2694}\u{2696}-\u{2697}\u{2699}\u{269B}-\u{269C}\u{26A0}-\u{26A1}\u{26AA}-\u{26AB}\u{26B0}-\u{26B1}\u{26BD}-\u{26BE}\u{26C4}-\u{26C5}\u{26C8}\u{26CE}-\u{26CF}\u{26D1}\u{26D3}-\u{26D4}\u{26E9}-\u{26EA}\u{26F0}-\u{26F5}\u{26F7}-\u{26FA}\u{26FD}\u{2702}\u{2705}\u{2708}-\u{270D}\u{270F}\u{2712}\u{2714}\u{2716}\u{271D}\u{2721}\u{2728}\u{2733}-\u{2734}\u{2744}\u{2747}\u{274C}\u{274E}\u{2753}-\u{2755}\u{2757}\u{2763}-\u{2764}\u{2795}-\u{2797}\u{27A1}\u{27B0}\u{27BF}\u{2934}-\u{2935}\u{2B05}-\u{2B07}\u{2B1B}-\u{2B1C}\u{2B50}\u{2B55}\u{3030}\u{303D}\u{3297}\u{3299}\u{1F004}\u{1F0CF}\u{1F170}-\u{1F171}\u{1F17E}-\u{1F17F}\u{1F18E}\u{1F191}-\u{1F19A}\u{1F201}-\u{1F202}\u{1F21A}\u{1F22F}\u{1F232}-\u{1F23A}\u{1F250}-\u{1F251}\u{1F300}-\u{1F321}\u{1F324}-\u{1F393}\u{1F396}-\u{1F397}\u{1F399}-\u{1F39B}\u{1F39E}-\u{1F3F0}\u{1F3F3}-\u{1F3F5}\u{1F3F7}-\u{1F4FD}\u{1F4FF}-\u{1F53D}\u{1F549}-\u{1F54E}\u{1F550}-\u{1F567}\u{1F56F}-\u{1F570}\u{1F573}-\u{1F579}\u{1F587}\u{1F58A}-\u{1F58D}\u{1F590}\u{1F595}-\u{1F596}\u{1F5A5}\u{1F5A8}\u{1F5B1}-\u{1F5B2}\u{1F5BC}\u{1F5C2}-\u{1F5C4}\u{1F5D1}-\u{1F5D3}\u{1F5DC}-\u{1F5DE}\u{1F5E1}\u{1F5E3}\u{1F5EF}\u{1F5F3}\u{1F5FA}-\u{1F64F}\u{1F680}-\u{1F6C5}\u{1F6CB}-\u{1F6D0}\u{1F6E0}-\u{1F6E5}\u{1F6E9}\u{1F6EB}-\u{1F6EC}\u{1F6F0}\u{1F6F3}\u{1F910}-\u{1F918}\u{1F980}-\u{1F984}\u{1F9C0}]/

    RANGE_FULLWIDTH               = /[\uFF01-\ufF1F]/ # e.g. ！＂＃＇？
    RANGE_ALPHANUMERIC_SUPPLEMENT = /[\u{1F100}-\u{1F1FF}]/
    # Regular expressions which do not need to capture anything are enclosed in /(?: … )/ to enhance performance
    
    COLON1                        = /(?:(:)([[:print:]]{2,}))/ # two non-space after colon prevent matching emoticons
    COLON2                        = /(?::)/
    COMMAS                        = /(?:([,‚])+)/
    ENCLOSED_PLUS                 = /(?:([[:print:]]+)\+([[:print:]]+))/
    EMAIL                         = /(?:[[:print:]]+[＠@][[:print:]]+\.[[:print:]]+)/
    DIGIT                         = /(?:[[:digit:]]+)/
    ASTERISK                      = /(?:\*+)/
    UNDERSCORE                    = /(?:_+)/
    HYPHEN_OR_UNDERSCORE          = /(?:[-_])/
    PERIOD_AND_PRIOR              = /(?:(.+\.))/
    PERIOD_ONLY                   = /(?:(\.))/
    CONTRACTIONS                  = /(?:[\`‘’‚‛‹›＇´`])/
    PUNCTUATION1                  = /(?:([\p{Pd}\p{Pe}\p{Pf}\p{Pi}\p{Ps}])+)/ # all punctuation categories except Pc (Connector) and Po (other)
    PUNCTUATION2                  = /(?:(?<=\S)([!?#{RANGE_FULLWIDTH.source}]+))/
    PUNCTUATION3                  = /(?:[!%\-–\u00AD<>=+]+)/
    PUNCTUATION4                  = /(?:[.．。]+)/
    EMOJI                         = /(?:(#{RANGE_EMOJI.source}))/
    NO_BREAK_SPACE                = /(?:\u00A0+)/
    HTTP                          = /(?:https?:\/\/)/
    TIME_WITH_COLON               = /(?:\d:\d)/
    DOMAIN_PREFIX                 = /(?:https?:\/\/|www\.|[[:alpha:]]\.)/
    DOMAIN_SUFFIX                 = /(?:[[:alpha:]]\.(?:com|net|org|edu|gov|mil|int|[[:alpha:]]{2}))/
    DOMAIN1                       = /(?:((https?:\/\/|)[[:print:]]+\.[[:alpha:]]{2,6}(:[0-9]{1,5})?(\/[[:print:]]*+)?))/
    DOMAIN2                       = /(?:[[:alnum:]]{2,}([\-.][[:alnum:]]+)*\.[[:alpha:]]{2,6}(:[0-9]{1,5})?(\/[[:print:]]*+)?)/
    NOT_URL                       = /(?:^(?!#{DOMAIN_PREFIX.source})([[:print:]]*))/
    HASHTAG_OR_MENTION            = /(?:[@#＠＃][[:print:]]+)/
    HASHTAG                       = /(?:[#＃][[:print:]]+)/
    MENTION                       = /(?:[@＠][[:print:]]+)/
    HASHTAG_WITH_HYPHEN           = /(?:^([#＃][[:digit:]]+)-)/
    ONE_AS_EXCLAMATION            = /(?:\D1+)/
    ONES_EXCLAMATIONS             = /(?:!+(1*+!*+)*+)/
    MANY_PERIODS                  = /(?:^\.{2,}$)/
    COPYRIGHT_TRADEMARK           = /(?:[®©™]+)/
    CONTROL_CHARACTER             = /(?:[[:cntrl:]]+)/ # matches any character with hexadecimal value 00 through 1F or 7F.
    APOSTROPHE_AND_S              = /(?:['’`́]s)/
    ALSO_DECIMALS                 = /(?:[[:alpha:]]*+[[:digit:]]+)/
    ACUTE_ACCENT_S                = /(?:\s\u0301(?=s))/

    # Regular expressions used to capture items
    QUESTION_MARK_NOT_URL         = /#{NOT_URL.source}(\?)/
    # Should we change specs and also capture "/", just like we capture ":" and "?"
    SLASH_NOT_URL                 = /#{NOT_URL.source}\//
    SHIFT_BOUNDARY_CHARACTERS     = /([;^|…«»„“¿¡≠~″“”‵‵〝〞〟〃「⌈」⌋『』+~\\\\]+)/
    MULTIPLE_DOTS                 = /(\.{2,})/ # we keep all dashes
    MULTIPLE_DASHES               = /(-){2,}/ # we only keep first dash
    BRACKET                       = /([{}()\[\]])/
    EXCLAMATION_BETWEEN_ALPHA     = /(?<=[[:alpha:]])(!)(?=[[:alpha:]])/
    PERCENT_BEFORE_DIGIT          = /(%)\d+/
    COMMA_BEFORE_NON_DIGIT        = /(,)(?=\D)/
    COMMA_AFTER_NON_DIGIT         = /(?<=\D)(,)/
    COLON_IN_URL                  = /(?<=[(https?|ftp)]):(?=\/\/)/
    QUOTE_BEFORE_PRINT            = /(('')|["“])(?=[[:print:]])/
    QUOTE                         = /('')|["”]/
    HYPHEN_AFTER_NON_WORD         = /(?<=\W)(-)/
    HYPHEN_BEFORE_NON_WORD        = /(-)(?=\W)/

    STARTS_WITH_COMMAS            = /^#{COMMAS.source}/
    STARTS_WITH_HTTP              = /^#{HTTP.source}/
    STARTS_WITH_DOMAIN            = /^#{DOMAIN_PREFIX.source}/
    STARTS_WITH_COLON1            = /^#{COLON1.source}/
    STARTS_WITH_UNDERSCORE        = /^#{UNDERSCORE.source}/
    STARTS_WITH_PUNCTUATION3      = /^#{PUNCTUATION3.source}/

    ENDS_WITH_DOMAIN              = /#{DOMAIN_SUFFIX.source}$/
    ENDS_WITH_PUNCTUATION1        = /#{PUNCTUATION1.source}$/
    ENDS_WITH_PUNCTUATION2        = /#{PUNCTUATION2.source}$/
    ENDS_WITH_COLON2              = /#{COLON2.source}$/
    ENDS_WITH_UNDERSCORE          = /#{UNDERSCORE.source}$/
    ENDS_WITH_ONES_EXCLAMATIONS   = /#{ONES_EXCLAMATIONS.source}$/
    ENDS_WITH_EXCITED_ONE         = /#{ONE_AS_EXCLAMATION.source}$/
    ENDS_WITH_APOSTROPHE_AND_S    = /#{APOSTROPHE_AND_S.source}$/
    ENDS_WITH_ALPHA               = /[[:alpha:]]$/
    ENDS_WITH_DIGIT               = /[[:digit:]]$/

    ONLY_DECIMALS                 = /(?:^[[:digit:]]+$)/
    NO_DECIMALS                   = /(?:^\D+$)/
    ONLY_PUNCTUATION              = /^[[[:punct:]]^|+]+$/
    ONLY_ROMAN_NUMERALS           = /^(?=[MDCLXVI])M*(C[MD]|D?C*)(X[CL]|L?X*)(I[XV]|V?I*)$/i
    ONLY_EMAIL                    = /^#{EMAIL}$/
    ONLY_HASHTAG_MENTION          = /^#{HASHTAG_OR_MENTION}$/
    ONLY_HASHTAG                  = /^#{HASHTAG}$/
    ONLY_MENTION                  = /^#{MENTION}$/
    ONLY_DOMAIN1                  = /^#{DOMAIN1}$/
    ONLY_DOMAIN2                  = /^#{DOMAIN2}$/
    ONLY_DOMAIN3                  = Regexp.union(STARTS_WITH_DOMAIN, ENDS_WITH_DOMAIN)
    DOMAIN_OR_EMAIL               = Regexp.union(ONLY_DOMAIN1, ONLY_EMAIL)
    UNDERSCORES_ASTERISK          = Regexp.union(STARTS_WITH_UNDERSCORE, ENDS_WITH_UNDERSCORE, ASTERISK)
    NO_DECIMALS_NO_NUMERALS       = Regexp.union(ALSO_DECIMALS, ONLY_ROMAN_NUMERALS)

    COMMAS_OR_PUNCTUATION = Regexp.union(
        STARTS_WITH_COMMAS,
        ENDS_WITH_PUNCTUATION1,
        ENDS_WITH_PUNCTUATION2
    )

    # Can this constant name be clarified?
    VARIOUS = Regexp.union(
        EMOJI,
        SLASH_NOT_URL,
        QUESTION_MARK_NOT_URL,
        ENCLOSED_PLUS,
        STARTS_WITH_COLON1,
        HASHTAG_WITH_HYPHEN
      )

    IRRELEVANT_CHARACTERS = Regexp.union(
        STARTS_WITH_PUNCTUATION3,
        ENDS_WITH_COLON2,
        ENDS_WITH_ONES_EXCLAMATIONS,
        CONTROL_CHARACTER,
        COPYRIGHT_TRADEMARK,
        RANGE_ALPHANUMERIC_SUPPLEMENT
    )

    PRE_PROCESS = Regexp.union(
        SHIFT_BOUNDARY_CHARACTERS,
        MULTIPLE_DOTS,
        BRACKET,
        MULTIPLE_DASHES,
        EXCLAMATION_BETWEEN_ALPHA,
        PERCENT_BEFORE_DIGIT,
        COMMA_BEFORE_NON_DIGIT,
        COMMA_AFTER_NON_DIGIT
    )

  end
end
