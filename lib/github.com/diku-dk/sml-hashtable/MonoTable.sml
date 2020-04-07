functor MonoTable (type t
                   val eq : t * t -> bool
                   val hash : t -> word) : MONO_TABLE =

struct
  type dom = t
  open Table
  type 'v table = (dom,'v)table
  fun new () = Table.new {hash=hash,eq=eq}
end
