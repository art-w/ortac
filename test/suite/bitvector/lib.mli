type t = { size : int; mutable mask : int }
(*@ invariant 0 <= size <= 63
    invariant 0 <= mask < pow 2 size *)

(*@ predicate mem (i: integer) (bv: t) = logand bv.mask (pow 2 i) <> 0 *)

val create : int -> t
(*@ bv = create n
    requires 0 <= n <= 63
    ensures bv.size = n
    ensures forall i. 0 <= i < n -> not (mem i bv) *)

val add : int -> t -> unit
(*@ add i bv
      checks 0 <= i < bv.size
      modifies bv
      ensures forall j. 0 <= j < bv.size ->
                mem j bv <-> i = j \/ mem j (old bv) *)

val mem : int -> t -> bool
(*@ b = mem i bv
    checks 0 <= i < bv.size
    ensures b <-> mem i bv *)
