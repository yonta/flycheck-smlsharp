(* nonexhaustive match warning, with long file name *)
datatype t = A | B
val x = case A of A => 0
