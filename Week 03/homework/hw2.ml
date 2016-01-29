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

let rec get_list_length =
  let list_length = get_list_length in
  function
  | [] -> 0
  | hd :: tl -> 1 + list_length tl
;;

let rec get_prefixes n list =
  let rec split m l =
    let prefix =
      split in
    match l with
    | [] -> []
    | hd :: tl ->
       if ((m - 1) < 1) then []
       else hd :: prefix (m - 1) tl
  in if n < 2 then [] else split n list :: get_prefixes (n - 1) list
;;

let split list =
  get_prefixes (get_list_length list) list
;;

let rec check_rhs grammar rhs acceptor derivation fragment =
  if rhs = [] then acceptor derivation fragment
  else
    match fragment with
    | [] -> None
    | hd :: tl -> match rhs with
                  | [] -> None
                  | (N n) :: non_tail -> 
                     (matcher grammar n
                              (check_rhs grammar non_tail acceptor)
                              derivation fragment)
                  | (T t) :: terminal_tail ->
                     if hd = t 
                     then (check_rhs grammar terminal_tail acceptor
                                     derivation tl)
                     else None

and check_symbols grammar n rhs acceptor derivation fragment =
  if rhs = [] then None 
  else match rhs with
       | [] -> None
       | hd :: tl ->
          match (check_rhs grammar hd acceptor
                           (derivation @ [(n, hd)]) fragment)
          with
          | Some(a, b) ->
             Some(a, b)
          | None ->
             (check_symbols grammar
                          n tl acceptor derivation fragment)

and matcher grammar nt acceptor derivation fragment =
  (check_symbols grammar nt (grammar nt) acceptor derivation fragment)

let rec parse_prefix (start_symbol, grammar) acceptor fragment =
    (matcher grammar start_symbol acceptor [] fragment)
