module PragmaticTokenizer
  module Languages
    module French
      include Languages::Common
      ABBREVIATIONS = Set.new(%w[a.c.n a.m al ann apr art auj av b.p boul c.-à-d c.n c.n.s c.p.i c.q.f.d c.s ca cf ch.-l chap co contr dir e.g e.v env etc ex fasc fig fr fém hab i.e ibid id inf l.d lib ll.aa ll.aa.ii ll.aa.rr ll.aa.ss ll.ee ll.mm ll.mm.ii.rr loc.cit ltd masc mm ms n.b n.d n.d.a n.d.l.r n.d.t n.p.a.i n.s n/réf nn.ss p.c.c p.ex p.j p.s pl pp r.-v r.a.s r.i.p r.p s.a s.a.i s.a.r s.a.s s.e s.m s.m.i.r s.s sec sect sing sq sqq ss suiv sup suppl t.s.v.p tél vb vol vs x.o z.i éd]).freeze
      STOP_WORDS    = Set.new(%w[a à â abord afin ah ai aie ainsi allaient allo allô allons après assez attendu au aucun aucune aujourd aujourd'hui auquel aura auront aussi autre autres aux auxquelles auxquels avaient avais avait avant avec avoir ayant b bah beaucoup bien bigre boum bravo brrr c ça car ce ceci cela celle celle-ci celle-là celles celles-ci celles-là celui celui-ci celui-là cent cependant certain certaine certaines certains certes ces cet cette ceux ceux-ci ceux-là chacun chaque cher chère chères chers chez chiche chut ci cinq cinquantaine cinquante cinquantième cinquième clac clic combien comme comment compris concernant contre couic crac d da dans de debout dedans dehors delà depuis derrière des dès désormais desquelles desquels dessous dessus deux deuxième deuxièmement devant devers devra différent différente différentes différents dire divers diverse diverses dix dix-huit dixième dix-neuf dix-sept doit doivent donc dont douze douzième dring du duquel durant e effet eh elle elle-même elles elles-mêmes en encore entre envers environ es ès est et etant étaient étais était étant etc été etre être eu euh eux eux-mêmes excepté f façon fais faisaient faisant fait feront fi flac floc font g gens h ha hé hein hélas hem hep hi ho holà hop hormis hors hou houp hue hui huit huitième hum hurrah i il ils importe j je jusqu jusque k l la là laquelle las le lequel les lès lesquelles lesquels leur leurs longtemps lorsque lui lui-même m ma maint mais malgré me même mêmes merci mes mien mienne miennes miens mille mince moi moi-même moins mon moyennant n na ne néanmoins neuf neuvième ni nombreuses nombreux non nos notre nôtre nôtres nous nous-mêmes nul o o| ô oh ohé olé ollé on ont onze onzième ore ou où ouf ouias oust ouste outre p paf pan par parmi partant particulier particulière particulièrement pas passé pendant personne peu peut peuvent peux pff pfft pfut pif plein plouf plus plusieurs plutôt pouah pour pourquoi premier première premièrement près proche psitt puisque q qu quand quant quanta quant-à-soi quarante quatorze quatre quatre-vingt quatrième quatrièmement que quel quelconque quelle quelles quelque quelques quelqu'un quels qui quiconque quinze quoi quoique r revoici revoilà rien s sa sacrebleu sans sapristi sauf se seize selon sept septième sera seront ses si sien sienne siennes siens sinon six sixième soi soi-même soit soixante son sont sous stop suis suivant sur surtout t ta tac tant te té tel telle tellement telles tels tenant tes tic tien tienne tiennes tiens toc toi toi-même ton touchant toujours tous tout toute toutes treize trente très trois troisième troisièmement trop tsoin tsouin tu u un une unes uns v va vais vas vé vers via vif vifs vingt vivat vive vives vlan voici voilà vont vos votre vôtre vôtres vous vous-mêmes vu w x y z zut alors aucuns bon devrait dos droite début essai faites fois force haut ici juste maintenant mine mot nommés nouveaux parce parole personnes pièce plupart seulement soyez sujet tandis valeur voie voient état étions d'un d'une]).freeze
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
