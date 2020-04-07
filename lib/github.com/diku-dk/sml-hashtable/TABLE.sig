(** Polymorphic hash tables *)

signature TABLE = sig

  type ('k,'v) table

  val new    : {hash: 'k -> word, eq: 'k * 'k -> bool} -> ('k,'v) table
  val size   : ('k,'v) table -> int
  val add    : 'k * 'v * ('k,'v) table -> unit
  val lookup : ('k,'v) table -> 'k -> 'v option
  val delete : ('k,'v) table -> 'k -> unit
  val list   : ('k,'v) table -> ('k * 'v) list
  val app    : ('k * 'v -> unit) -> ('k,'v) table -> unit
  val map    : ('v -> 'r) -> ('k,'v) table -> ('k, 'r) table
  val Map    : ('k * 'v -> 'r) -> ('k,'v) table -> ('k,'r) table
  val filter : ('k * 'v -> bool) -> ('k,'v) table -> unit
  val copy   : ('k,'v) table -> ('k,'v) table
  val clear  : ('k,'v) table -> unit

  (* profiling functions *)
  val peekSameHash: ('k,'v) table -> 'k -> word * int
  val bucketSizes : ('k,'v) table -> int list

end

(**

[('k,'v) table] is the type of hashtables with keys of type 'k and
values of type 'v.

[new {hash,eq}] returns a new hashtable, using hash as the hash
function and eq for the equality predicate. It is assumed that
eq(k1,k2) implies hash k1 = hash k2 for all k1, k2.

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
