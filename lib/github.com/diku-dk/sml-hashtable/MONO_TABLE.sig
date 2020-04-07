(** Signature for monomorphic hash tables *)

signature MONO_TABLE = sig

  type dom
  type 'v table

  val new    : unit -> 'v table
  val size   : 'v table -> int
  val add    : dom * 'v * 'v table -> unit
  val lookup : 'v table -> dom -> 'v option
  val delete : 'v table -> dom -> unit
  val list   : 'v table -> (dom * 'v) list
  val app    : (dom * 'v -> unit) -> 'v table -> unit
  val map    : ('v -> 'r) -> 'v table -> 'r table
  val Map    : (dom * 'v -> 'r) -> 'v table -> 'r table
  val filter : (dom * 'v -> bool) -> 'v table -> unit
  val copy   : 'v table -> 'v table
  val clear  : 'v table -> unit

  (* profiling functions *)
  val peekSameHash: 'v table -> dom -> word * int
  val bucketSizes : 'v table -> int list

end

(**

['v table] is the type of hashtables with keys of type dom and
values of type 'v.

[new ()] returns a new empty hashtable.

[size t] returns the number of items in t.

[add (k,v,t)] inserts the association of k to v in t. Overwrites any
existing association of k in t.

[lookup t k] returns SOME v if k is associated with k in t. Returns
NONE otherwise.

[delete t k] deletes any possible association of k in t.

[list t] returns a list of the (key, value) pairs in t.

[app f t] applies the function f to each of the (key, value) pairs in
t.

[map f t] creates a copy of t with the values substituted by applying
f to each of the values in t.

[Map f t] returns a new hashtable, whose data items have been
obtained by applying f to the (key, value) pairs in t.  The new table
has the same keys, hash function and equality predicate as t.

[filter p t] deletes from t all data items that do not satisfy the
predicate p.

[copy t] returns a copy of t.

[clear t] empties all data in t.

[peekSameHash t k] returns the number of items associated with the
same hash as k in t. Useful for profiling.

[bucketSizes t] returns a list of the sizes of the buckets in
t. Useful for profiling.

*)
