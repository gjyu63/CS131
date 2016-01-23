(* function for checking whether A is a subset of B  *)

let rec subset a b = match a with
  | [] -> true
  | hd :: tl ->
     if (List.mem b hd) then subset tl b else false
;;

let equal_sets a b =
  if (subset a b) && (subset b a) then true else false;;

let rec set_union a b =
  let union = b in
  match a with
  | [] -> union
  | [x] -> if List.mem union x then union else x :: union
  | hd :: tl ->
     if List.mem union hd then set_union tl union else hd :: set_union tl union
;;

let rec set_intersection a b =
  let intersection = [] in
  match a with
  | [] -> intersection
  | [x] -> if List.mem b x then x :: intersection
           else intersection
  | hd :: tl ->
     if List.mem b hd then hd :: set_intersection tl b
     else
       set_intersection tl b
;;

(*  set_diff a b returns a list representing a−b *)
let rec set_diff a b =
  let difference = [] in
  match a with
  | [] -> difference
  | [x] -> if List.mem b x then difference else x :: difference
  | hd :: tl ->
     if List.mem b hd then set_diff tl b else hd :: set_diff tl b
;;

(* returns the computed fixed point for f with respect to x *)
let rec computed_fixed_point eq f x =
  if eq (f x) x then x
  else computed_fixed_point eq f (f x)
;;

(* returns the computed periodic point for f with period p and 
   with respect to x*)
let rec computed_periodic_point eq f p x =
  let rec call_f g n y =
    if n <= 1 then y else call_f g (n - 1) (g y)
  in let new_x = call_f f p x in 
     if eq new_x x then x
     else computed_periodic_point eq f p new_x
;;

(* Type defintion for grammars *)
type ('nonterminal, 'terminal) symbol =
  | N of 'nonterminal
  | T of 'terminal
;;
  
(* filter_blind_alleys *)
let filter_blind_alleys g =
  true
;;

(* test functions *)  
let rec get_terminal_symbols list =
  let set_symbols = [] in
  match list with
  | [] -> []
  | hd :: tl ->
     match hd with
     | (_, a) ->
        if List.mem set_symbols a then get_terminal_symbols tl
        else a :: get_terminal_symbols tl
;;

(* function for extracting rules in a grammar *)
let get_rules grammar =
  match grammar with
  | (_, a) -> a
;;

(* function for checking if termination *) 
let rec is_terminal rule =
  match rule with
  | T t -> true
  | N _ -> false
;;

let rec get_rules_with_terminals rules =
  match rules with 
  | [] -> []
  | hd :: tl ->
     match hd with 
     | n, list ->
        let rec add_all_terminals l =
          match l with
          | [] -> []
          | h2 :: t2 ->
             if is_terminal h2
                          then n :: add_all_terminals t2
                        else add_all_terminals t2
        in add_all_terminals list :: get_rules_with_terminals tl
;;
  
