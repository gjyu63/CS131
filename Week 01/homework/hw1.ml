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
     if List.mem union hd then set_union tl b else hd :: set_union tl b
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

(* filter_blind_alleys *)
let filter_blind_alleys g =
  true
;;
    
(* ------------------------------------------------------------------------- *)
(* ------------------------------ tests ------------------------------------ *) 
                        
(* tests for subset function  *)
let my_subset_test_0 = subset [] [1;2;3;4;5];; (* true *)
let my_subset_test_1 = subset [2;3] [1;2;3;4;5];; (* true *)
let my_subset_test_2 = subset [1;2;3;4;5] [1;2;3;4;5];; (* true *)
let my_subset_test_3 = not (subset [6] [1;2;3;4;5]);; (* false  *)
let my_subset_test_4 = not (subset [6;1;2] [1;2;3;4;5]);; (* false *)
let my_subset_test_5 = subset [] [];; (* true *)

(* tests for equal_sets function *)
let my_equal_sets_test_0 = equal_sets [] [];; (* true *)
let my_equal_sets_test_1 = equal_sets [1] [1];; (* true *)
let my_equal_sets_test_2 = equal_sets [1;1] [1];; (* true *)
let my_equal_sets_test_3 = equal_sets [1] [1;1;1];; (* true *)
let my_equal_sets_test_4 = equal_sets [1;2;3] [1;2;3];; (* true *)
let my_equal_sets_test_5 = equal_sets [1;1;2] [1;2;2;2;2];; (* true *)
let my_equal_sets_test_6 = not (equal_sets [1] [2]);; (* false *)
let my_equal_sets_test_7 = not (equal_sets [1] []);; (* false *)
let my_equal_sets_test_8 = not (equal_sets [] [1]);; (* false *)

(* tests for set_union function *)
let my_set_union_test1 = set_union [] [];; (* [] *)
let my_set_union_test2 = set_union [1] [];; (* [1] *)
let my_set_union_test3 = set_union [] [1];; (* [1] *)
let my_set_union_test4 = set_union [1] [1];; (* [1] *)
let my_set_union_test5 = set_union [1;2;3] [1];; (* [1;2;3] *)
let my_set_union_test6 = set_union [1;2;3;4;5;6] [1;2;6];; (* [1;2;3;4;5;6] *)
let my_set_union_test7 = set_union [] [1;2;3;4;5;6];; (* [1;2;3;4;5;6]  *)

(* tests for set_intersection function *)
let my_set_intersection_test0 = set_intersection [] [];;      (* [] *)
let my_set_intersection_test1 = set_intersection [] [1];;     (* [] *)
let my_set_intersection_test2 = set_intersection [] [1];;     (* [] *)
let my_set_intersection_test3 = set_intersection [2;3] [];;   (* [] *)
let my_set_intersection_test4 = set_intersection [] [2;3;4];; (* [] *)
let my_set_intersection_test5 = set_intersection [1;2;3;4] [1;2];; (* 1,2 *)
let my_set_intersection_test6 = set_intersection [1] [1];;    (* 1 *)
let my_set_intersection_test7 = set_intersection [1;2;3;4;5] [1;2];; (* 1,2 *)
let my_set_intersection_test8 = set_intersection [5;5;5] [5];;(* 5 *)

(* tests for set_diff *)
let my_set_difference_test0 = set_diff [] [];; (* [] *)
let my_set_difference_test1 = set_diff [1] [];; (* [1] *)
let my_set_difference_test2 = set_diff [1;2;3;4] [];; (* [1;2;3;4] *)
let my_set_difference_test3 = set_diff [1;2] [1];; (* [2] *)
let my_set_difference_test4 = set_diff [1;2;3;4] [1;2;3;4];; (* [] *)
let my_set_difference_test5 = set_diff [] [1;2;3;4];; (* [] *)

(* tests for computed_fixed_point *)
let my_computed_fixed_point_test0 = computed_fixed_point
                                      (=) (fun x -> x) 0;;
let my_computed_fixed_point_test1 = computed_fixed_point
                                      (=) (fun x -> x /. 2.) 2.;;
let my_computed_fixed_point_test2 = computed_fixed_point
                                      (=) (fun x -> x *. x) 2. ;;

(* tests for computed_periodic_point *)

let computed_periodic_point_test0 =
  computed_periodic_point (=) (fun x -> x / 9) 2 (-1);;
