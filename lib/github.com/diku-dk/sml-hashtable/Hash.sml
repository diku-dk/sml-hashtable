
structure Hash : HASH =
struct

type hash = word
type depth = int

type 'a hasher0 = 'a -> hash * depth -> hash * depth
type 'a hasher = {maxLength:int} -> 'a hasher0

local
  val Alpha = 0w65599
  val Beta = 0w19
in
  fun hashAddSmall0 w acc = w+acc*Beta
  fun hashAdd w (acc,d) = (w+acc*Alpha,d-1)
  fun hashAddSmall w (acc,d) = (w+acc*Beta,d-1)
  fun hashComb f (p as (acc,d)) =
      if d <= 0 then p else f p
  val UNIT_HASH = 0w23
  val NIL_HASH = 0w5
end

fun string {maxLength:int} : string hasher0 =
    fn (s:string) => fn (acc,depth) =>
    let val sz = size s
	val sz = if sz > maxLength then maxLength else sz
	fun loop (n,a) =
	    if n >= sz then a
	    else loop (n+1,
		       hashAddSmall0
			   (Word.fromInt(Char.ord(String.sub(s,n)))) a)
    in (loop (0,acc), depth)
    end

fun unit _ : unit hasher0 =
    fn () => hashComb (hashAddSmall UNIT_HASH)

fun char _ : char hasher0 =
    fn c => hashComb (hashAddSmall (Word.fromInt(Char.ord c)))

fun word _ : word hasher0 =
    fn w => hashComb (hashAdd w)

fun int _ : int hasher0 =
    fn i => hashComb (hashAddSmall (Word.fromInt i))

fun pair (h1:'a hasher) (h2:'b hasher) m : ('a*'b) hasher0 =
    fn (v1,v2) => fn s => h2 m v2 (h1 m v1 s)

fun list (h:'a hasher) m : 'a list hasher0 =
    fn nil => hashComb (hashAddSmall NIL_HASH)
     | x::xs => fn s => hashComb (list h m xs) (h m x s)

fun hashNum {maxDepth: int, maxLength: int}
            (h: 'a hasher) (v: 'a) : hash =
    #1(h {maxLength=maxLength} v (0w0,maxDepth))

fun hash (h: 'a hasher) (v: 'a) : hash =
    hashNum {maxDepth=12,maxLength=500} h v

fun stringHash (s:string) : hash =
    hashNum {maxDepth=12,maxLength=size s}
            string s

end
