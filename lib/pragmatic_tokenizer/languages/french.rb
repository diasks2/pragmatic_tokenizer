module PragmaticTokenizer
  module Languages
    module French
      include Languages::Common
      ABBREVIATIONS = Set.new(%w[a.c.n a.m al ann apr art auj av b.p boul c.-à-d c.n c.n.s c.p.i c.q.f.d c.s ca cf ch.-l chap co contr dir e.g e.v env etc ex fasc fig fr fém hab i.e ibid id inf l.d lib ll.aa ll.aa.ii ll.aa.rr ll.aa.ss ll.ee ll.mm ll.mm.ii.rr loc.cit ltd masc mm ms n.b n.d n.d.a n.d.l.r n.d.t n.p.a.i n.s n/réf nn.ss p.c.c p.ex p.j p.s pl pp r.-v r.a.s r.i.p r.p s.a s.a.i s.a.r s.a.s s.e s.m s.m.i.r s.s sec sect sing sq sqq ss suiv sup suppl t.s.v.p tél vb vol vs x.o z.i éd]).freeze
      STOP_WORDS = File.open(File.expand_path("../../stopwords/#{name.to_s.split('::').last.downcase}.txt", __FILE__)).read.split("\n").freeze
      CONTRACTIONS  = {}.freeze

      class SingleQuotes

        # why can't we directly reference constants from Languages::Common?
        ALNUM_QUOTE  = PragmaticTokenizer::Languages::Common::SingleQuotes::ALNUM_QUOTE
        QUOTE_WORD   = PragmaticTokenizer::Languages::Common::SingleQuotes::QUOTE_WORD
        C_APOSTROPHE = /c'/i
        J_APOSTROPHE = /j'/i
        L_APOSTROPHE = /l'/i
        D_APOSTROPHE = /d'/i
        QU_APOSTROPHE = /qu'/i
        N_APOSTROPHE = /n'/i
        T_APOSTROPHE = /t'/i
        M_APOSTROPHE = /m'/i
        S_APOSTROPHE = /s'/i
        QUELQU_APOSTROPHE = /quelqu'/i
        JUSQU_APOSTROPHE = /jusqu'/i
        LORSQU_APOSTROPHE = /lorsqu'/i
        PUISQU_APOSTROPHE = /puisqu'/i
        QUOIQU_APOSTROPHE = /quoiqu'/i

        def handle_single_quotes(text)
          replacement = PragmaticTokenizer::Languages::Common::PUNCTUATION_MAP["'".freeze]
          text.gsub!(C_APOSTROPHE, '\1 c' << replacement << ' ')
          text.gsub!(J_APOSTROPHE, '\1 j' << replacement << ' ')
          text.gsub!(L_APOSTROPHE, '\1 l' << replacement << ' ')
          text.gsub!(D_APOSTROPHE, '\1 d' << replacement << ' ')
          text.gsub!(QU_APOSTROPHE, '\1 qu' << replacement << ' ')
          text.gsub!(N_APOSTROPHE, '\1 n' << replacement << ' ')
          text.gsub!(T_APOSTROPHE, '\1 t' << replacement << ' ')
          text.gsub!(M_APOSTROPHE, '\1 m' << replacement << ' ')
          text.gsub!(S_APOSTROPHE, '\1 s' << replacement << ' ')
          text.gsub!(QUELQU_APOSTROPHE, '\1 quelqu' << replacement << ' ')
          text.gsub!(JUSQU_APOSTROPHE, '\1 jusqu' << replacement << ' ')
          text.gsub!(LORSQU_APOSTROPHE, '\1 lorsqu' << replacement << ' ')
          text.gsub!(PUISQU_APOSTROPHE, '\1 puisqu' << replacement << ' ')
          text.gsub!(QUOIQU_APOSTROPHE, '\1 quoiqu' << replacement << ' ')
          text.gsub!(ALNUM_QUOTE,  '\1 '  << replacement << ' ')
          text.gsub!(QUOTE_WORD,   ' '    << replacement)
          text
        end
      end
    end
  end
end
