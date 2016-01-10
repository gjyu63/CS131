(* function for checking whether A is a subset of B  *)

let rec subset a b = match a with
  | [] -> true
  | hd :: tl ->
     if (List.mem b hd) then subset tl b else false
;;

