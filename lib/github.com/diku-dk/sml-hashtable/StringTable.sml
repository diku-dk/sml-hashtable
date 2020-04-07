structure StringTable : MONO_TABLE where type dom = string =
  MonoTable(type t = string
            val hash = Hash.stringHash
            val eq = op =)
