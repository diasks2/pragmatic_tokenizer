module PragmaticTokenizer
  module Languages
    module Spanish
      include Languages::Common
      ABBREVIATIONS = Set.new(["a", "a.c", "a/c", "abr", "adj", "admón", "aero", "afmo", "ago", "almte", "ambi", "an", "anfi", "ante", "anti", "ap", "apdo", "archi", "arci", "arq", "art", "atte", "auto", "av", "avda", "bco", "bi", "bibl", "bien", "bis", "bs. as", "c", "c.f", "c.g", "c/c", "c/u", "cap", "cc.aa", "cdad", "cm", "co", "com", "con", "contra", "cra", "crio", "cta", "cuadri", "cuasi", "cuatri", "cv", "d.e.p", "da", "das", "dcha", "dcho", "de", "deci", "dep", "des", "di", "dic", "dicc", "dir", "dis", "dn", "do", "doc", "dom", "dpto", "dr", "dra", "dto", "ecto", "ee", "ej", "en", "endo", "entlo", "entre", "epi", "equi", "esq", "etc", "ex", "excmo", "ext", "extra", "f.c", "fca", "fdo", "febr", "ff. aa", "ff.cc", "fig", "fil", "fra", "g.p", "g/p", "geo", "gob", "gr", "gral", "grs", "hemi", "hetero", "hiper", "hipo", "hnos", "homo", "hs", "i", "igl", "iltre", "im", "imp", "impr", "impto", "in", "incl", "infra", "ing", "inst", "inter", "intra", "iso", "izdo", "izq", "izqdo", "j.c", "jue", "jul", "jun", "kg", "km", "lcdo", "ldo", "let", "lic", "ltd", "lun", "macro", "mar", "may", "mega", "mg", "micro", "min", "mini", "mié", "mm", "mono", "mt", "multi", "máx", "mín", "n. del t", "n.b", "neo", "no", "nos", "nov", "ntra. sra", "núm", "oct", "omni", "p", "p.a", "p.d", "p.ej", "p.v.p", "para", "pen", "ph", "ph.d", "pluri", "poli", "pos", "post", "pp", "ppal", "pre", "prev", "pro", "prof", "prov", "pseudo", "ptas", "pts", "pza", "pág", "págs", "párr", "párrf", "q.e.g.e", "q.e.p.d", "q.e.s.m", "re", "reg", "rep", "retro", "rr. hh", "rte", "s", "s. a", "s.a.r", "s.e", "s.l", "s.r.c", "s.r.l", "s.s.s", "s/n", "sdad", "seg", "semi", "sept", "seudo", "sig", "sobre", "sr", "sra", "sres", "srta", "sta", "sto", "sub", "super", "supra", "sáb", "t.v.e", "tamb", "tel", "tfno", "trans", "tras", "tri", "ud", "uds", "ulter", "ultra", "un", "uni", "univ", "uu", "v.b", "v.e", "vd", "vds", "vice", "vid", "vie", "vol", "vs", "vto", "yuxta"]).freeze
      STOP_WORDS = File.open("lib/pragmatic_tokenizer/stopwords/#{name.to_s.split('::').last.downcase}.txt").read.split("\n").freeze
      CONTRACTIONS = {
          "al"  => "a el",
          "del" => "de el"
      }.freeze
    end
  end
end
