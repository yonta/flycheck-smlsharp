(* nonexhaustive match warning *)
datatype t = A | B
val x = case A of A => 0
