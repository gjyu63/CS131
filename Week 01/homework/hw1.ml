(* function for checking whether A is a subset of B  *)
let rec subset a b =
  match a with
  | [] -> true
  | hd_a :: tl_a -> 
    match b with
    | [] -> true
    | hd_b :: tl_b -> if hd_a = hd_b then subset tl_a b else false
;;

