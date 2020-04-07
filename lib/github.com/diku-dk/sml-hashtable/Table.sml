(* Polymorphic hash tables *)

structure Table :> TABLE =
struct

type ('k,'v) bucket = (word * 'k * 'v) list

type ('k,'v) table =
     {hash: 'k -> word,
      eq: 'k * 'k -> bool,
      buckets: (('k,'v) bucket) Array.array ref,
      size: int ref}

fun size (t : ('k,'v) table) : int = !(#size t)

fun new_buckets sz = Array.array (sz, nil)

fun new {hash: 'k -> word, eq: 'k * 'k -> bool} : ('k,'v) table =
    {hash=hash,
     eq=eq,
     buckets=ref (new_buckets 32),
     size=ref 0}

fun idx arrsz w =
    Word.toInt(Word.andb(Word.fromInt (arrsz-1),w))

fun maybeResize (t as {buckets,...} : ('k,'v) table) : int =
    let val arrsz = Array.length (!buckets)
    in if size t > arrsz  then
         let val new_arrsz = arrsz+arrsz
             val new_arr = new_buckets new_arrsz
             fun upd (t as (w,_,_)) =
                 let val i = idx new_arrsz w
                 in Array.update(new_arr,i,t::Array.sub(new_arr,i))
                 end
         in Array.app (List.app upd) (!buckets)
          ; buckets := new_arr
          ; new_arrsz
         end
       else arrsz
    end

(* operations on buckets *)
fun look eq k0 nil = NONE
  | look eq k0 ((_,k,v)::xs) =
    if eq(k0,k) then SOME v else look eq k0 xs

fun rem eq k0 acc nil = rev acc
  | rem eq k0 acc ((x as (_,k,_))::xs) =
    if eq(k0,k) then rev acc @ xs
    else rem eq k0 (x::acc) xs

fun add (k: 'k, v: 'v, t as {hash,eq,buckets,size}: ('k,'v) table) : unit =
    let val arrsz = maybeResize t
        val w = hash k
        val i = idx arrsz w
        val b = Array.sub(!buckets,i)
    in case look eq k b of
           SOME _ =>
           Array.update(!buckets, i, (w,k,v)::rem eq k nil b)
         | NONE =>
           ( Array.update(!buckets, i, (w,k,v) :: b)
           ; size := !size + 1 )
    end

fun lookup (t as {hash,eq,buckets,size}: ('k,'v) table) (k: 'k) : 'v option =
    let val arrsz = Array.length (!buckets)
    in look eq k (Array.sub(!buckets, idx arrsz (hash k)))
    end

fun delete ({hash,eq,buckets,size}: ('k,'v) table) (k: 'k) : unit =
    let val arrsz = Array.length (!buckets)
        val i = idx arrsz (hash k)
        val b = Array.sub(!buckets,i)
    in case look eq k b of
           SOME _ =>
           ( Array.update(!buckets, i, rem eq k nil b)
           ; size := !size - 1 )
         | NONE => ()
    end

fun list (t: ('k,'v) table) : ('k * 'v) list =
    Array.foldl (fn (b,acc) => List.map (fn (w,k,v) => (k,v)) b @ acc)
                nil (!(#buckets t))

fun app (f: 'k*'v -> unit) (t: ('k,'v) table) : unit =
    Array.app (List.app (fn (w,k,v) => f(k,v)))
              (!(#buckets t))

fun map (f: 'v -> 'r) ({hash,eq,buckets=ref a,size=ref sz}: ('k,'v) table)
    : ('k,'r) table =
      {hash=hash,eq=eq,size=ref sz,
       buckets=ref(Array.tabulate(Array.length a,
                                  fn i => List.map (fn (w,k,v) => (w,k,f v))
                                                   (Array.sub(a,i))))}

fun Map (f: 'k * 'v -> 'r) ({hash,eq,buckets=ref a,size=ref sz}: ('k,'v) table)
    : ('k,'r) table =
      {hash=hash,eq=eq,size=ref sz,
       buckets=ref(Array.tabulate(Array.length a,
                                  fn i => List.map (fn (w,k,v) => (w,k,f(k,v)))
                                                   (Array.sub(a,i))))}

fun totalSizes arr =
    Array.foldl (fn (b,acc) => List.length b + acc)
                0 arr

fun filter (p: 'k * 'v -> bool) (t: ('k,'v) table) : unit =
    let val arr = !(#buckets t)
    in Array.modify (List.filter (fn (w,k,v) => p (k,v))) arr
     ; #size t := totalSizes arr
    end

fun copy t = map (fn x => x) t

fun clear (t: ('k,'v) table) : unit =
    ( Array.modify (fn _ => nil) (!(#buckets t))
    ; #size t := 0 )

fun peekSameHash (t: ('k,'v) table) (k: 'k) : word * int =
    let val w = #hash t k
        val arr = !(#buckets t)
        val i = idx (Array.length arr) w
    in (w, List.length (Array.sub(arr,i)))
    end

fun bucketSizes (t: ('k,'v) table) : int list =
    Array.foldl (fn (b,acc) => List.length b :: acc)
                nil (!(#buckets t))


end
