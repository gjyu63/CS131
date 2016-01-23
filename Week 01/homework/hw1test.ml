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
