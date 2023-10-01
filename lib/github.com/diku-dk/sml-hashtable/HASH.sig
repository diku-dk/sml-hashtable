(** Hash functions. *)

signature HASH =
  sig
    type hash = word
    val stringHash : string -> hash

    (* combinators for constructing hashes *)
    type 'a hasher
    val unit    : unit hasher
    val int     : int hasher
    val word    : word hasher
    val string  : string hasher
    val pair    : 'a hasher -> 'b hasher -> ('a * 'b) hasher
    val list    : 'a hasher -> 'a list hasher
    val hashNum : {maxDepth: int, maxLength: int} -> 'a hasher -> 'a -> hash
    val hash    : 'a hasher -> 'a -> hash
  end

(**

[type hash] The type of hashes (i.e., word values).

[stringHash s] returns a hash obtained from scanning s.

[type 'a hasher] type representing type-indexed composable hash
functions.

[unit] trivial hash function for hasing unit values.

[int] hash function for hashing integers.

[word] hash function for hashing word values.

[string] hash function for hashing strings.

[pair h1 h2] returns a hash function for hashing pairs of values that
are each hashed using the functions h1 and h2.

[list h] returns a hash function for hashing lists of elements that
are each hashed using the function h.

[hashNum {maxDepth,maxlength} h v] returns a hash of the value v using
the compatible hasher h. The parameters maxDepth and maxLength are
used for controling the maximum number of individual hash
contributions and the maximum number of hashed characters in strings,
respectively.

[hash h v] returns a hash of the value v using the compatible hasher
h. This function is identical to hashNum {maxDepth=12,maxLength=500}.

[Discussion]

Because of the depth and length control in composed hashers, all
composed hashers are guaranteed to terminate.

*)
