(* function for checking whether A is a subset of B  *)

let rec subset a b = match a with
  | [] -> true
  | hd :: tl ->
     if (List.mem b hd) then subset tl b else false
;;

let equal_sets a b =
  if (subset a b) && (subset b a) then true else false;;

let set_union a b =
  let sorted_combined_list in
  
;;  

  
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
