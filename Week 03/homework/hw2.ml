(* get left hand sides helper function *)
let rec get_lhs =
  (* function that checks for duplicate *)
  let rec is_duplicate item list = match list with
  | [] -> false
  | hd :: tl -> if (item = hd) then true
                else is_duplicate item tl in

  (* function for retrieving expressions in a tuple *)
  let return_expression = function
    | (a, b) -> a in

  (* main function for retrieving expressions *)
  function     | [] -> []
               | hd :: tl ->
                  match hd, tl with
                  | (l, r) ->
                     let lhs = get_lhs tl in
                     let curr_expr = return_expression(l) in

                     (* check to see if the expression is a duplicate *)
                     if (is_duplicate curr_expr lhs) then lhs
                     (* if it isn't then add it to our list of expressions *)
                     else curr_expr :: lhs
;;

(* collect rules *)
let rec collect_rhs r lhs = 
     (* helper for extracting rule *)
     let get_rule = function
       | (a, b) -> b in

     let get_category = function
       | (a, b) -> a in     
     (* helper for matching left side*)
     let matches_lhs a b = (a = b) in

     match r with
     | [] -> []
     | hd :: tl ->
        let rules = collect_rhs tl lhs in
        if (matches_lhs lhs (get_category hd)) then (get_rule hd) :: rules
        else rules 
;;  

(* convert grammar function *)
let convert_grammar = function
  | (a, b) -> (a, collect_rhs b)
;;
