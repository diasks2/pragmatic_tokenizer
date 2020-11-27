require "unicode/emoji"

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
    RANGE_EMOJI                   = /\u{1F3F4}\u{E0067}\u{E0062}(?:\u{E0077}\u{E006C}\u{E0073}|\u{E0073}\u{E0063}\u{E0074}|\u{E0065}\u{E006E}\u{E0067})\u{E007F}|\u{1F469}\u200D\u{1F469}\u200D(?:\u{1F466}\u200D\u{1F466}|\u{1F467}\u200D[\u{1F466}\u{1F467}])|\u{1F468}(?:\u{1F3FF}\u200D(?:\u{1F91D}\u200D\u{1F468}[\u{1F3FB}-\u{1F3FE}]|[\u{1F33E}\u{1F373}\u{1F37C}\u{1F393}\u{1F3A4}\u{1F3A8}\u{1F3EB}\u{1F3ED}\u{1F4BB}\u{1F4BC}\u{1F527}\u{1F52C}\u{1F680}\u{1F692}\u{1F9AF}-\u{1F9B3}\u{1F9BC}\u{1F9BD}])|\u{1F3FE}\u200D(?:\u{1F91D}\u200D\u{1F468}[\u{1F3FB}-\u{1F3FD}\u{1F3FF}]|[\u{1F33E}\u{1F373}\u{1F37C}\u{1F393}\u{1F3A4}\u{1F3A8}\u{1F3EB}\u{1F3ED}\u{1F4BB}\u{1F4BC}\u{1F527}\u{1F52C}\u{1F680}\u{1F692}\u{1F9AF}-\u{1F9B3}\u{1F9BC}\u{1F9BD}])|\u{1F3FD}\u200D(?:\u{1F91D}\u200D\u{1F468}[\u{1F3FB}\u{1F3FC}\u{1F3FE}\u{1F3FF}]|[\u{1F33E}\u{1F373}\u{1F37C}\u{1F393}\u{1F3A4}\u{1F3A8}\u{1F3EB}\u{1F3ED}\u{1F4BB}\u{1F4BC}\u{1F527}\u{1F52C}\u{1F680}\u{1F692}\u{1F9AF}-\u{1F9B3}\u{1F9BC}\u{1F9BD}])|\u{1F3FC}\u200D(?:\u{1F91D}\u200D\u{1F468}[\u{1F3FB}\u{1F3FD}-\u{1F3FF}]|[\u{1F33E}\u{1F373}\u{1F37C}\u{1F393}\u{1F3A4}\u{1F3A8}\u{1F3EB}\u{1F3ED}\u{1F4BB}\u{1F4BC}\u{1F527}\u{1F52C}\u{1F680}\u{1F692}\u{1F9AF}-\u{1F9B3}\u{1F9BC}\u{1F9BD}])|\u{1F3FB}\u200D(?:\u{1F91D}\u200D\u{1F468}[\u{1F3FC}-\u{1F3FF}]|[\u{1F33E}\u{1F373}\u{1F37C}\u{1F393}\u{1F3A4}\u{1F3A8}\u{1F3EB}\u{1F3ED}\u{1F4BB}\u{1F4BC}\u{1F527}\u{1F52C}\u{1F680}\u{1F692}\u{1F9AF}-\u{1F9B3}\u{1F9BC}\u{1F9BD}])|\u200D(?:\u2764\uFE0F\u200D(?:\u{1F48B}\u200D)?\u{1F468}|[\u{1F468}\u{1F469}]\u200D(?:\u{1F466}\u200D\u{1F466}|\u{1F467}\u200D[\u{1F466}\u{1F467}])|\u{1F466}\u200D\u{1F466}|\u{1F467}\u200D[\u{1F466}\u{1F467}]|[\u{1F468}\u{1F469}]\u200D[\u{1F466}\u{1F467}]|[\u2695\u2696\u2708]\uFE0F|[\u{1F466}\u{1F467}]|[\u{1F33E}\u{1F373}\u{1F37C}\u{1F393}\u{1F3A4}\u{1F3A8}\u{1F3EB}\u{1F3ED}\u{1F4BB}\u{1F4BC}\u{1F527}\u{1F52C}\u{1F680}\u{1F692}\u{1F9AF}-\u{1F9B3}\u{1F9BC}\u{1F9BD}])|(?:\u{1F3FF}\u200D[\u2695\u2696\u2708]|\u{1F3FE}\u200D[\u2695\u2696\u2708]|\u{1F3FD}\u200D[\u2695\u2696\u2708]|\u{1F3FC}\u200D[\u2695\u2696\u2708]|\u{1F3FB}\u200D[\u2695\u2696\u2708])\uFE0F|\u{1F3FF}|\u{1F3FE}|\u{1F3FD}|\u{1F3FC}|\u{1F3FB})?|\u{1F9D1}(?:[\u{1F3FB}-\u{1F3FF}]\u200D(?:\u{1F91D}\u200D\u{1F9D1}[\u{1F3FB}-\u{1F3FF}]|[\u{1F33E}\u{1F373}\u{1F37C}\u{1F384}\u{1F393}\u{1F3A4}\u{1F3A8}\u{1F3EB}\u{1F3ED}\u{1F4BB}\u{1F4BC}\u{1F527}\u{1F52C}\u{1F680}\u{1F692}\u{1F9AF}-\u{1F9B3}\u{1F9BC}\u{1F9BD}])|\u200D(?:\u{1F91D}\u200D\u{1F9D1}|[\u{1F33E}\u{1F373}\u{1F37C}\u{1F384}\u{1F393}\u{1F3A4}\u{1F3A8}\u{1F3EB}\u{1F3ED}\u{1F4BB}\u{1F4BC}\u{1F527}\u{1F52C}\u{1F680}\u{1F692}\u{1F9AF}-\u{1F9B3}\u{1F9BC}\u{1F9BD}]))|\u{1F469}(?:\u200D(?:\u2764\uFE0F\u200D(?:\u{1F48B}\u200D[\u{1F468}\u{1F469}]|[\u{1F468}\u{1F469}])|[\u{1F33E}\u{1F373}\u{1F37C}\u{1F393}\u{1F3A4}\u{1F3A8}\u{1F3EB}\u{1F3ED}\u{1F4BB}\u{1F4BC}\u{1F527}\u{1F52C}\u{1F680}\u{1F692}\u{1F9AF}-\u{1F9B3}\u{1F9BC}\u{1F9BD}])|\u{1F3FF}\u200D[\u{1F33E}\u{1F373}\u{1F37C}\u{1F393}\u{1F3A4}\u{1F3A8}\u{1F3EB}\u{1F3ED}\u{1F4BB}\u{1F4BC}\u{1F527}\u{1F52C}\u{1F680}\u{1F692}\u{1F9AF}-\u{1F9B3}\u{1F9BC}\u{1F9BD}]|\u{1F3FE}\u200D[\u{1F33E}\u{1F373}\u{1F37C}\u{1F393}\u{1F3A4}\u{1F3A8}\u{1F3EB}\u{1F3ED}\u{1F4BB}\u{1F4BC}\u{1F527}\u{1F52C}\u{1F680}\u{1F692}\u{1F9AF}-\u{1F9B3}\u{1F9BC}\u{1F9BD}]|\u{1F3FD}\u200D[\u{1F33E}\u{1F373}\u{1F37C}\u{1F393}\u{1F3A4}\u{1F3A8}\u{1F3EB}\u{1F3ED}\u{1F4BB}\u{1F4BC}\u{1F527}\u{1F52C}\u{1F680}\u{1F692}\u{1F9AF}-\u{1F9B3}\u{1F9BC}\u{1F9BD}]|\u{1F3FC}\u200D[\u{1F33E}\u{1F373}\u{1F37C}\u{1F393}\u{1F3A4}\u{1F3A8}\u{1F3EB}\u{1F3ED}\u{1F4BB}\u{1F4BC}\u{1F527}\u{1F52C}\u{1F680}\u{1F692}\u{1F9AF}-\u{1F9B3}\u{1F9BC}\u{1F9BD}]|\u{1F3FB}\u200D[\u{1F33E}\u{1F373}\u{1F37C}\u{1F393}\u{1F3A4}\u{1F3A8}\u{1F3EB}\u{1F3ED}\u{1F4BB}\u{1F4BC}\u{1F527}\u{1F52C}\u{1F680}\u{1F692}\u{1F9AF}-\u{1F9B3}\u{1F9BC}\u{1F9BD}])|\u{1F469}\u{1F3FF}\u200D\u{1F91D}\u200D[\u{1F468}\u{1F469}][\u{1F3FB}-\u{1F3FE}]|\u{1F469}\u{1F3FE}\u200D\u{1F91D}\u200D[\u{1F468}\u{1F469}][\u{1F3FB}-\u{1F3FD}\u{1F3FF}]|\u{1F469}\u{1F3FD}\u200D\u{1F91D}\u200D[\u{1F468}\u{1F469}][\u{1F3FB}\u{1F3FC}\u{1F3FE}\u{1F3FF}]|\u{1F469}\u{1F3FC}\u200D\u{1F91D}\u200D[\u{1F468}\u{1F469}][\u{1F3FB}\u{1F3FD}-\u{1F3FF}]|\u{1F469}\u{1F3FB}\u200D\u{1F91D}\u200D[\u{1F468}\u{1F469}][\u{1F3FC}-\u{1F3FF}]|\u{1F469}\u200D\u{1F466}\u200D\u{1F466}|\u{1F469}\u200D\u{1F469}\u200D[\u{1F466}\u{1F467}]|(?:\u{1F441}\uFE0F\u200D\u{1F5E8}|\u{1F469}(?:\u{1F3FF}\u200D[\u2695\u2696\u2708]|\u{1F3FE}\u200D[\u2695\u2696\u2708]|\u{1F3FD}\u200D[\u2695\u2696\u2708]|\u{1F3FC}\u200D[\u2695\u2696\u2708]|\u{1F3FB}\u200D[\u2695\u2696\u2708]|\u200D[\u2695\u2696\u2708])|\u{1F3F3}\uFE0F\u200D\u26A7|\u{1F9D1}(?:[\u{1F3FB}-\u{1F3FF}]\u200D[\u2695\u2696\u2708]|\u200D[\u2695\u2696\u2708])|\u{1F43B}\u200D\u2744|(?:[\u{1F3C3}\u{1F3C4}\u{1F3CA}\u{1F46E}\u{1F470}\u{1F471}\u{1F473}\u{1F477}\u{1F481}\u{1F482}\u{1F486}\u{1F487}\u{1F645}-\u{1F647}\u{1F64B}\u{1F64D}\u{1F64E}\u{1F6A3}\u{1F6B4}-\u{1F6B6}\u{1F926}\u{1F935}\u{1F937}-\u{1F939}\u{1F93D}\u{1F93E}\u{1F9B8}\u{1F9B9}\u{1F9CD}-\u{1F9CF}\u{1F9D6}-\u{1F9DD}][\u{1F3FB}-\u{1F3FF}]|[\u{1F46F}\u{1F93C}\u{1F9DE}\u{1F9DF}])\u200D[\u2640\u2642]|[\u26F9\u{1F3CB}\u{1F3CC}\u{1F575}][\uFE0F\u{1F3FB}-\u{1F3FF}]\u200D[\u2640\u2642]|\u{1F3F4}\u200D\u2620|[\u{1F3C3}\u{1F3C4}\u{1F3CA}\u{1F46E}\u{1F470}\u{1F471}\u{1F473}\u{1F477}\u{1F481}\u{1F482}\u{1F486}\u{1F487}\u{1F645}-\u{1F647}\u{1F64B}\u{1F64D}\u{1F64E}\u{1F6A3}\u{1F6B4}-\u{1F6B6}\u{1F926}\u{1F935}\u{1F937}-\u{1F939}\u{1F93D}\u{1F93E}\u{1F9B8}\u{1F9B9}\u{1F9CD}-\u{1F9CF}\u{1F9D6}-\u{1F9DD}]\u200D[\u2640\u2642]|[\u00A9\u00AE\u203C\u2049\u2122\u2139\u2194-\u2199\u21A9\u21AA\u2328\u23CF\u23ED-\u23EF\u23F1\u23F2\u23F8-\u23FA\u24C2\u25AA\u25AB\u25B6\u25C0\u25FB\u25FC\u2600-\u2604\u260E\u2611\u2618\u2620\u2622\u2623\u2626\u262A\u262E\u262F\u2638-\u263A\u2640\u2642\u265F\u2660\u2663\u2665\u2666\u2668\u267B\u267E\u2692\u2694-\u2697\u2699\u269B\u269C\u26A0\u26A7\u26B0\u26B1\u26C8\u26CF\u26D1\u26D3\u26E9\u26F0\u26F1\u26F4\u26F7\u26F8\u2702\u2708\u2709\u270F\u2712\u2714\u2716\u271D\u2721\u2733\u2734\u2744\u2747\u2763\u2764\u27A1\u2934\u2935\u2B05-\u2B07\u3030\u303D\u3297\u3299\u{1F170}\u{1F171}\u{1F17E}\u{1F17F}\u{1F202}\u{1F237}\u{1F321}\u{1F324}-\u{1F32C}\u{1F336}\u{1F37D}\u{1F396}\u{1F397}\u{1F399}-\u{1F39B}\u{1F39E}\u{1F39F}\u{1F3CD}\u{1F3CE}\u{1F3D4}-\u{1F3DF}\u{1F3F5}\u{1F3F7}\u{1F43F}\u{1F4FD}\u{1F549}\u{1F54A}\u{1F56F}\u{1F570}\u{1F573}\u{1F576}-\u{1F579}\u{1F587}\u{1F58A}-\u{1F58D}\u{1F5A5}\u{1F5A8}\u{1F5B1}\u{1F5B2}\u{1F5BC}\u{1F5C2}-\u{1F5C4}\u{1F5D1}-\u{1F5D3}\u{1F5DC}-\u{1F5DE}\u{1F5E1}\u{1F5E3}\u{1F5E8}\u{1F5EF}\u{1F5F3}\u{1F5FA}\u{1F6CB}\u{1F6CD}-\u{1F6CF}\u{1F6E0}-\u{1F6E5}\u{1F6E9}\u{1F6F0}\u{1F6F3}])\uFE0F|\u{1F469}\u200D\u{1F467}\u200D[\u{1F466}\u{1F467}]|\u{1F3F3}\uFE0F\u200D\u{1F308}|\u{1F469}\u200D\u{1F467}|\u{1F469}\u200D\u{1F466}|\u{1F415}\u200D\u{1F9BA}|\u{1F469}(?:\u{1F3FF}|\u{1F3FE}|\u{1F3FD}|\u{1F3FC}|\u{1F3FB})?|\u{1F1FD}\u{1F1F0}|\u{1F1F6}\u{1F1E6}|\u{1F1F4}\u{1F1F2}|\u{1F408}\u200D\u2B1B|\u{1F441}\uFE0F|\u{1F3F3}\uFE0F|\u{1F9D1}[\u{1F3FB}-\u{1F3FF}]?|\u{1F1FF}[\u{1F1E6}\u{1F1F2}\u{1F1FC}]|\u{1F1FE}[\u{1F1EA}\u{1F1F9}]|\u{1F1FC}[\u{1F1EB}\u{1F1F8}]|\u{1F1FB}[\u{1F1E6}\u{1F1E8}\u{1F1EA}\u{1F1EC}\u{1F1EE}\u{1F1F3}\u{1F1FA}]|\u{1F1FA}[\u{1F1E6}\u{1F1EC}\u{1F1F2}\u{1F1F3}\u{1F1F8}\u{1F1FE}\u{1F1FF}]|\u{1F1F9}[\u{1F1E6}\u{1F1E8}\u{1F1E9}\u{1F1EB}-\u{1F1ED}\u{1F1EF}-\u{1F1F4}\u{1F1F7}\u{1F1F9}\u{1F1FB}\u{1F1FC}\u{1F1FF}]|\u{1F1F8}[\u{1F1E6}-\u{1F1EA}\u{1F1EC}-\u{1F1F4}\u{1F1F7}-\u{1F1F9}\u{1F1FB}\u{1F1FD}-\u{1F1FF}]|\u{1F1F7}[\u{1F1EA}\u{1F1F4}\u{1F1F8}\u{1F1FA}\u{1F1FC}]|\u{1F1F5}[\u{1F1E6}\u{1F1EA}-\u{1F1ED}\u{1F1F0}-\u{1F1F3}\u{1F1F7}-\u{1F1F9}\u{1F1FC}\u{1F1FE}]|\u{1F1F3}[\u{1F1E6}\u{1F1E8}\u{1F1EA}-\u{1F1EC}\u{1F1EE}\u{1F1F1}\u{1F1F4}\u{1F1F5}\u{1F1F7}\u{1F1FA}\u{1F1FF}]|\u{1F1F2}[\u{1F1E6}\u{1F1E8}-\u{1F1ED}\u{1F1F0}-\u{1F1FF}]|\u{1F1F1}[\u{1F1E6}-\u{1F1E8}\u{1F1EE}\u{1F1F0}\u{1F1F7}-\u{1F1FB}\u{1F1FE}]|\u{1F1F0}[\u{1F1EA}\u{1F1EC}-\u{1F1EE}\u{1F1F2}\u{1F1F3}\u{1F1F5}\u{1F1F7}\u{1F1FC}\u{1F1FE}\u{1F1FF}]|\u{1F1EF}[\u{1F1EA}\u{1F1F2}\u{1F1F4}\u{1F1F5}]|\u{1F1EE}[\u{1F1E8}-\u{1F1EA}\u{1F1F1}-\u{1F1F4}\u{1F1F6}-\u{1F1F9}]|\u{1F1ED}[\u{1F1F0}\u{1F1F2}\u{1F1F3}\u{1F1F7}\u{1F1F9}\u{1F1FA}]|\u{1F1EC}[\u{1F1E6}\u{1F1E7}\u{1F1E9}-\u{1F1EE}\u{1F1F1}-\u{1F1F3}\u{1F1F5}-\u{1F1FA}\u{1F1FC}\u{1F1FE}]|\u{1F1EB}[\u{1F1EE}-\u{1F1F0}\u{1F1F2}\u{1F1F4}\u{1F1F7}]|\u{1F1EA}[\u{1F1E6}\u{1F1E8}\u{1F1EA}\u{1F1EC}\u{1F1ED}\u{1F1F7}-\u{1F1FA}]|\u{1F1E9}[\u{1F1EA}\u{1F1EC}\u{1F1EF}\u{1F1F0}\u{1F1F2}\u{1F1F4}\u{1F1FF}]|\u{1F1E8}[\u{1F1E6}\u{1F1E8}\u{1F1E9}\u{1F1EB}-\u{1F1EE}\u{1F1F0}-\u{1F1F5}\u{1F1F7}\u{1F1FA}-\u{1F1FF}]|\u{1F1E7}[\u{1F1E6}\u{1F1E7}\u{1F1E9}-\u{1F1EF}\u{1F1F1}-\u{1F1F4}\u{1F1F6}-\u{1F1F9}\u{1F1FB}\u{1F1FC}\u{1F1FE}\u{1F1FF}]|\u{1F1E6}[\u{1F1E8}-\u{1F1EC}\u{1F1EE}\u{1F1F1}\u{1F1F2}\u{1F1F4}\u{1F1F6}-\u{1F1FA}\u{1F1FC}\u{1F1FD}\u{1F1FF}]|[#\*0-9]\uFE0F\u20E3|[\u{1F3C3}\u{1F3C4}\u{1F3CA}\u{1F46E}\u{1F470}\u{1F471}\u{1F473}\u{1F477}\u{1F481}\u{1F482}\u{1F486}\u{1F487}\u{1F645}-\u{1F647}\u{1F64B}\u{1F64D}\u{1F64E}\u{1F6A3}\u{1F6B4}-\u{1F6B6}\u{1F926}\u{1F935}\u{1F937}-\u{1F939}\u{1F93D}\u{1F93E}\u{1F9B8}\u{1F9B9}\u{1F9CD}-\u{1F9CF}\u{1F9D6}-\u{1F9DD}][\u{1F3FB}-\u{1F3FF}]|[\u26F9\u{1F3CB}\u{1F3CC}\u{1F575}][\uFE0F\u{1F3FB}-\u{1F3FF}]|\u{1F3F4}|[\u270A\u270B\u{1F385}\u{1F3C2}\u{1F3C7}\u{1F442}\u{1F443}\u{1F446}-\u{1F450}\u{1F466}\u{1F467}\u{1F46B}-\u{1F46D}\u{1F472}\u{1F474}-\u{1F476}\u{1F478}\u{1F47C}\u{1F483}\u{1F485}\u{1F4AA}\u{1F57A}\u{1F595}\u{1F596}\u{1F64C}\u{1F64F}\u{1F6C0}\u{1F6CC}\u{1F90C}\u{1F90F}\u{1F918}-\u{1F91C}\u{1F91E}\u{1F91F}\u{1F930}-\u{1F934}\u{1F936}\u{1F977}\u{1F9B5}\u{1F9B6}\u{1F9BB}\u{1F9D2}-\u{1F9D5}][\u{1F3FB}-\u{1F3FF}]|[\u261D\u270C\u270D\u{1F574}\u{1F590}][\uFE0F\u{1F3FB}-\u{1F3FF}]|[\u270A\u270B\u{1F385}\u{1F3C2}\u{1F3C7}\u{1F408}\u{1F415}\u{1F43B}\u{1F442}\u{1F443}\u{1F446}-\u{1F450}\u{1F466}\u{1F467}\u{1F46B}-\u{1F46D}\u{1F472}\u{1F474}-\u{1F476}\u{1F478}\u{1F47C}\u{1F483}\u{1F485}\u{1F4AA}\u{1F57A}\u{1F595}\u{1F596}\u{1F64C}\u{1F64F}\u{1F6C0}\u{1F6CC}\u{1F90C}\u{1F90F}\u{1F918}-\u{1F91C}\u{1F91E}\u{1F91F}\u{1F930}-\u{1F934}\u{1F936}\u{1F977}\u{1F9B5}\u{1F9B6}\u{1F9BB}\u{1F9D2}-\u{1F9D5}]|[\u{1F3C3}\u{1F3C4}\u{1F3CA}\u{1F46E}\u{1F470}\u{1F471}\u{1F473}\u{1F477}\u{1F481}\u{1F482}\u{1F486}\u{1F487}\u{1F645}-\u{1F647}\u{1F64B}\u{1F64D}\u{1F64E}\u{1F6A3}\u{1F6B4}-\u{1F6B6}\u{1F926}\u{1F935}\u{1F937}-\u{1F939}\u{1F93D}\u{1F93E}\u{1F9B8}\u{1F9B9}\u{1F9CD}-\u{1F9CF}\u{1F9D6}-\u{1F9DD}]|[\u{1F46F}\u{1F93C}\u{1F9DE}\u{1F9DF}]|[\u231A\u231B\u23E9-\u23EC\u23F0\u23F3\u25FD\u25FE\u2614\u2615\u2648-\u2653\u267F\u2693\u26A1\u26AA\u26AB\u26BD\u26BE\u26C4\u26C5\u26CE\u26D4\u26EA\u26F2\u26F3\u26F5\u26FA\u26FD\u2705\u2728\u274C\u274E\u2753-\u2755\u2757\u2795-\u2797\u27B0\u27BF\u2B1B\u2B1C\u2B50\u2B55\u{1F004}\u{1F0CF}\u{1F18E}\u{1F191}-\u{1F19A}\u{1F201}\u{1F21A}\u{1F22F}\u{1F232}-\u{1F236}\u{1F238}-\u{1F23A}\u{1F250}\u{1F251}\u{1F300}-\u{1F320}\u{1F32D}-\u{1F335}\u{1F337}-\u{1F37C}\u{1F37E}-\u{1F384}\u{1F386}-\u{1F393}\u{1F3A0}-\u{1F3C1}\u{1F3C5}\u{1F3C6}\u{1F3C8}\u{1F3C9}\u{1F3CF}-\u{1F3D3}\u{1F3E0}-\u{1F3F0}\u{1F3F8}-\u{1F407}\u{1F409}-\u{1F414}\u{1F416}-\u{1F43A}\u{1F43C}-\u{1F43E}\u{1F440}\u{1F444}\u{1F445}\u{1F451}-\u{1F465}\u{1F46A}\u{1F479}-\u{1F47B}\u{1F47D}-\u{1F480}\u{1F484}\u{1F488}-\u{1F4A9}\u{1F4AB}-\u{1F4FC}\u{1F4FF}-\u{1F53D}\u{1F54B}-\u{1F54E}\u{1F550}-\u{1F567}\u{1F5A4}\u{1F5FB}-\u{1F644}\u{1F648}-\u{1F64A}\u{1F680}-\u{1F6A2}\u{1F6A4}-\u{1F6B3}\u{1F6B7}-\u{1F6BF}\u{1F6C1}-\u{1F6C5}\u{1F6D0}-\u{1F6D2}\u{1F6D5}-\u{1F6D7}\u{1F6EB}\u{1F6EC}\u{1F6F4}-\u{1F6FC}\u{1F7E0}-\u{1F7EB}\u{1F90D}\u{1F90E}\u{1F910}-\u{1F917}\u{1F91D}\u{1F920}-\u{1F925}\u{1F927}-\u{1F92F}\u{1F93A}\u{1F93F}-\u{1F945}\u{1F947}-\u{1F976}\u{1F978}\u{1F97A}-\u{1F9B4}\u{1F9B7}\u{1F9BA}\u{1F9BC}-\u{1F9CB}\u{1F9D0}\u{1F9E0}-\u{1F9FF}\u{1FA70}-\u{1FA74}\u{1FA78}-\u{1FA7A}\u{1FA80}-\u{1FA86}\u{1FA90}-\u{1FAA8}\u{1FAB0}-\u{1FAB6}\u{1FAC0}-\u{1FAC2}\u{1FAD0}-\u{1FAD6}\u{2b50}\u{26a1}\u{2604}\u{2600}\u{26c5}\u{2601}\u{2603}\u{26c4}\u{2614}\u{2602}\u{2615}\u{26bd}\u{26be}\u{26f3}\u{26f5}\u{2693}\u{26fd}\u{26f2}\u{26fa}\u{26ea}\u{231a}\u{231b}\u{262e}\u{2626}\u{2648}\u{2649}\u{264a}\u{264b}\u{264c}\u{264d}\u{264e}\u{264f}\u{2650}\u{2651}\u{2652}\u{2653}\u{1f194}\u{2622}\u{2623}\u{1f21a}\u{1f19a}\u{1f170}\u{1f171}\u{1f18e}\u{1f191}\u{1f17e}\u{1f198}\u{2b55}\u{26d4}\u{2757}\u{1f22f}\u{267f}\u{1f17f}\u{1f196}\u{1f197}\u{1f199}\u{1f192}\u{1f195}\u{1f193}\u{2122}\u{a9}\u{ae}\u{26aa}\u{26ab}\u{25fe}\u{25fd}\u{2b1b}\u{2b1c}\u{1f004}\u{1f3f4}\u{1f1e6}\u{1f1e9}\u{1f1e7}\u{1f1ee}\u{1f1fb}\u{1f1f0}\u{1f1e8}\u{1f1f9}\u{1f1ed}\u{1f1ea}\u{1f1f8}\u{1f1ec}\u{1f1eb}\u{1f1f5}]/
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
    EMOJI                         = Regexp.new("(#{Unicode::Emoji::REGEX_WELL_FORMED_INCLUDE_TEXT.to_s})")
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
