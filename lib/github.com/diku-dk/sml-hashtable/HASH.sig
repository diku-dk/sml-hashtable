(* Hash functions *)

signature HASH = sig

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

  val hashNum : {maxDepth: int, maxLength: int}
                -> 'a hasher -> 'a -> hash

  val hash    : 'a hasher -> 'a -> hash
end
