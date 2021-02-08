(* compiler bug *)
functor F (A : sig type t end) :> sig type t end =
struct
  datatype ta = A of A.t
  datatype t = T of ta
end
structure S = F (type t = int)
