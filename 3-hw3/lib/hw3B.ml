(*==================================================
    CS:4420 Artificial Intelligence
    Spring 2019
    
    Homework 3 - Part B
    
    Name: Alic Szecsei

  ==================================================*)

(*---------------------------- 
   Useful auxiliary functions 
  ---------------------------*)

(* Revoves from list l all elements that satisfy predicate p *) 
let remove p l = List.filter (fun x -> not (p x)) l

(* '(listToString f l)' converts list 'l' to its string representation
   by convering the list elements using 'f'
 *)
let listToString f = function
  | [] -> "[]"
  | h :: t -> 
    let s = List.fold_left (fun a x -> a ^ "; " ^ f x) (f h) t in
    "[" ^ s ^ "]"


(*------------------ 
   Clauses and CNFs 
  -----------------*)

(* Type lit consists of integer values standing for propositional literals
   If n>0 stands for a propositional variable p,
   then -n stands for the logical negation of p
   Zero stands for the logical constant True
*)
type lit = int

(* Clauses are sorted lists of literals.
   They stand for the disjunction of their elements where each element
   stands for a positive or negative literal, depending on its sign. 
   This also means that the empty clause stands for False.
   The elements are expected to be in strictly increasing order.
 *)
type clause = lit list

(* a cnf is a list of clauses, standing for their conjunction
 *)
type cnf = clause list


(* Converts its input clause 'c' to its string representation 
   as a list of integers
 *)
let clauseToString c = listToString string_of_int c


(* Converts a cnf, a list of clauses 'cs', to its string representation 
   as a list of list of integers
 *)
let cnfToString cs = listToString clauseToString cs


(* This type models possible answers to a query 
   to a knowledge base
 *)
type queryAnswer = Yes | No | Unknown


(* This type models possible answers given
   by a resolution-based procedure
 *)
type resolAnswer = Sat |  Unsat | Stop


(*------------------------ 
   Functions over clauses 
  -----------------------*)

(* empty clause *)
let isEmpty (c: clause) = c = []

(* All functions below that take clauses as input
   assumes that the literals in the clause are
   in stricly increasing order.
*)

(* Returns true iff literal n occurs in clause c *)
let rec contains (c: clause) n = 
  match c with 
  | [] -> false
  | h :: t when n < h -> false
  | h :: t when n = h -> true
  | h :: t            -> contains t n


(* Returns an extension of clause c that contains
   n and all the elements of c 
*)
let rec insert n (c: clause) = 
  match c with 
  | [] -> [n]
  | h :: t when n < h -> n :: c
  | h :: t when n = h -> c
  | h :: t            -> h :: (insert n t)

(* Merges two clauses into a single one
   (while not introducing repetitions)
*)
let merge (c1: clause) (c2: clause) = 
  List.fold_left (fun c n -> insert n c) c2 c1


(*
  ===========
  Problem 1.1
  ===========
*)
(* Returns true iff clause c1 subsumes clause c2
 *) 
let subsumes (c1: clause) (c2: clause) = 
  List.fold_left (fun agg li -> agg && (contains c2 li)) true c1

(*
subsumes [-3; -1] [-3; -1]
subsumes [-3; -1] [-3; -2; -1; 5]
not (subsumes [-3; -1] [-3; 6])
*)

(*
  ===========
  Problem 1.2
  ===========
*)
(* Returns true iff clause c1 subsumes clause c2
   but not the other way around
 *) 
let psubsumes (c1: clause) (c2: clause) = 
  (subsumes c1 c2) && not (subsumes c2 c1)

(*
not (psubsumes [-3; -1] [-3; -1])
psubsumes [-3; -1] [-3; -2; -1; 5]
*)


(*
  ===========
  Problem 1.3
  ===========
*)
(* Returns true iff some clause of cnf cs subsumes clause c
 *) 
let setSubsumes (cs: cnf) (c: clause) = 
  List.exists (fun co -> subsumes co c) cs

(*
setSubsumes [[-3; -1]; [-3; 5]] [-3; 5; 6]
*)

(*
  ===========
  Problem 1.4
  ===========
*)
(* Returns true iff clause c1 contains the true literal or a literal and its complement
 *) 
let isaTautology c = 
  (contains c 0) || List.exists (fun v -> (contains c (-1 * v))) c

(*
isaTautology [-3; -1; 0; 6]
isaTautology [-3; -1; 3; 6]
not (isaTautology [-3; -1; 2; 6])
*)


(*-------------------------- 
   CNF conversion functions 
  --------------------------*)


(* Type of propositions, as in Part A *)
type id = int
type prop = True
          | False
          | P of id
          | Not of prop
          | Or of prop * prop
          | And of prop * prop
          | Impl of prop * prop
          | Iff of prop * prop

(* returns true iff the input proposition is 
   a propositional variable or a negated proposition
 *)
let isAtomNeg = function
  | P _
  | Not _ -> true
  |     _ -> false

(* Converts the input proposition to its its string representation
   with infix logical symbols (and parentheses as needed)
 *)
let rec propToString p =
  let wrap s = "(" ^ s ^ ")" in
  let bin op p1 p2 =
    let s1 = propToString p1 in
    let s2 = propToString p2 in
    let s1' = if isAtomNeg p1 then s1 else wrap s1 in
    let s2' = if isAtomNeg p2 then s2 else wrap s2 in
    String.concat " " [s1'; op; s2']
  in
  match p with
  | True -> "True"
  | False -> "False"
  | P i -> "P" ^ string_of_int i
  | Not p ->
    let s = propToString p in
    "~" ^ (if isAtomNeg p then s else wrap s)
  | Or (p1, p2) -> bin "v" p1 p2
  | And (p1, p2) -> bin "^" p1 p2
  | Impl (p1, p2) -> bin "=>" p1 p2
  | Iff (p1, p2) -> bin "<=>" p1 p2

(*
let p1 = Impl(And(P 1, Or(P 2, P 3)), Not (Iff(P 1,  P 3)))
let s1 = propToString p1 
*)

(*
  ===========
  Problem 2.1
  ===========
*)
(* Takes a proposition and returns an equivalent one
   with no applications of 'Iff'
 *)
let rec elimIff (p: prop) =  
  match p with
  | Iff (p1, p2) -> And (Impl (elimIff p1, elimIff p2), Impl (elimIff p2, elimIff p1))
  | Not p -> Not (elimIff p)
  | Or (p1, p2) -> Or (elimIff p1, elimIff p2)
  | And (p1, p2) -> And (elimIff p1, elimIff p2)
  | Impl (p1, p2) -> Impl (elimIff p1, elimIff p2)
  | v -> v

(*
let p2 = elimIff p1 
*)

(*
  ===========
  Problem 2.2
  ===========
*)
(* Takes a proposition with no applications of 'Iff' and
   returns an equivalent one with no applications of 'Impl'
 *)
let rec elimImpl (p: prop) =  
  match p with
  | Impl (p1, p2) -> Or (And (elimImpl p1, elimImpl p2), Not (elimImpl p1))
  | Not p -> Not (elimImpl p)
  | Or (p1, p2) -> Or (elimImpl p1, elimImpl p2)
  | And (p1, p2) -> And (elimImpl p1, elimImpl p2)
  | v -> v

(*
let p3 = elimImpl p2
*)

(*
  ===========
  Problem 2.3
  ===========
*)
(* Takes a proposition with no applications of 'Iff' and 'Impl', and
   returns an equivalent one in negation normal form (NNF) where
   all applications of 'Not', if any, apply to a propositional variable
 *)
let rec pushNot (p: prop) =  
  let rec pushNotHelper (pr: prop) v =
    match pr with
    | Not p -> pushNotHelper p (not v)
    | Or (p1, p2) when v -> Or (pushNotHelper p1 v, pushNotHelper p2 v)
    | Or (p1, p2) when not v -> And (pushNotHelper p1 v, pushNotHelper p2 v)
    | And (p1, p2) when v -> And (pushNotHelper p1 v, pushNotHelper p2 v)
    | And (p1, p2) when not v -> Or (pushNotHelper p1 v, pushNotHelper p2 v)
    | P i -> if v then P i else Not (P i)
    | True -> if v then True else False
    | False -> if v then False else True
    | v -> v in
  pushNotHelper p true

(*
let p4 = pushNot p3
*)

(*
  ===========
  Problem 2.4
  ===========
*)
(* Takes a proposition in NNF with no applications of 'Iff' and 'Impl', 
   and returns one where no applications of 'And' occur within an
   application of 'Or'
 *)
let rec distributeOr (p: prop) =  
  match p with
  | And (p1, p2) -> 
    And (distributeOr p1, distributeOr p2)
   (* Add here cases where Or directly applies to an And *)
  | Or (And (p1, p2), p3) -> distributeOr (And (Or (p3, p1), Or (p3, p2)))
  | Or (p1, And (p2, p3)) -> distributeOr (And (Or (p1, p2), Or (p1, p3)))


  | Or (p1, p2) -> 
    let p' = Or (distributeOr p1, distributeOr p2) in
    if p = p' then 
      p 
    else
      distributeOr p'
  | _ -> p

(*
let p5 = distributeOr p4
*)

(* Takes as input a proposition list 'l' and a proposition 'p' in NNF
   with no applications of 'Iff' and 'Impl' and where no applications 
   of 'And' occur within an application of 'Or'.
   It returns a list that adds to 'l' the maximal subterms of 'p'
   that start with an application of 'Or'. 
 *)
let rec flattenAnd l p =  
  match p with
  | And (p1, p2) -> flattenAnd (flattenAnd l p1) p2
  | True -> l
  | _ -> p :: l

(*
let l1 = flattenAnd [] p5
*)

(* Takes as input a clause 'c' and a proposition 'p' in that
   contains only applications or 'Or', 'Not', 'True' and 'False'.
   It returns a clause that adds to 'c' all the signed ids of
   each literals in 'p' except for 'False'. 
 *)
let rec flattenOr (c: clause) p =  
  match p with
  | Or (p1, p2) -> flattenOr (flattenOr c p1) p2
  | P i -> insert i c
  | Not (P i) -> insert (-i) c
  | False -> c
  | True -> insert 0 c
  | _ -> assert false (* error case, should not happen *)

(*
let p6 = List.hd l1
let _ = propToString p6
let c = flattenOr [] p6

let _ = List.map propToString l1
let cs = List.map (flattenOr []) l1
*)


(* Takes a proposition and returns its conjunctive normal form 
   as a list of clauses
*)
let cnf (p: prop) : cnf = 
  p |> elimIff
    |> elimImpl
    |> pushNot
    |> distributeOr
    |> flattenAnd []
    |> List.map (flattenOr [])

(*
let cs = cnf p1
*)


(*---------------------- 
   Resolution functions 
  ----------------------*)

(*
  ===========
  Problem 3.1
  ===========
*)
(* Takes a non-zero literal 'n', a clause 'c1' containing 'n', and
   a clause 'c2' containing '-n' and returns the resolvent of 
   the two clauses with pivot 'n'
 *)
let resolve (n: lit) (c1: clause) (c2: clause) : clause = 
  remove (fun x -> (x = n) || (x = -n)) (merge c1 c2)

(*
[-3; -1; 1] = resolve (-2) [-3; -2; -1] [-3; 1; 2]
[-3; -2; 2] = resolve (-1) [-3; -2; -1] [-3; 1; 2]
*)

(* Takes two clause 'c1' and 'c2' and a cnf 'cs' and returns 
   a cnf that adds to 'cs' all the resolvents, if any, of 
   the two clauses
 *)
let resolvents (c1: clause) (c2: clause) (cs: cnf) : cnf = 
  let res c1 c2 cs l = 
    if contains c2 (-l) then (resolve l c1 c2) :: cs
    else cs
  in  
    List.fold_left (res c1 c2) cs c1  

(*
let c = resolvents [-3; -2; -1] [-3; 2; 1] []
*)

(* Takes a clause 'c1' and a cnf 'cs' and returns 
   a cnf that adds to 'cs' all the resolvents, if any, 
   between 'c1' and each clause of 'cs'
 *)
let allResolvents (c1: clause) (cs: cnf) = 
  List.fold_left (fun cs2 c2 -> resolvents c1 c2 cs2) [] cs

(*
let c = allResolvents [-3; -2; -1] [[-3; 2; 1]]

let cs = allResolvents [-3; -1] [[-3; -1; 3]; [-3; -1; 1]; [-3; -1; 1; 3]; [-3; -2; -1];
   [-3; -2; -1; 3]; [-2; -1; 1]; [-2; -1; 1; 3]]
*)


(* Takes a cnf 'cs' and a positive integer 'n'.
   It returns 'Unsat' if it can prove 'cs' unsatisfiable 
   by resolution within 'n' iterations of the procedure.
   It returns 'Sat' if it can prove 'cs' satifiable 
   by resolution within 'n' iterations.
   It returns 'Stop' if it cannot prove 'cs' satifiable
   or unsatisfiable within 'n' iterations.
 *)
let resolution cs n = 
  let rec repeat ncs pcs ocs n =
  (* uncomment the next two lines if you want to see a trace of the derivation proces
    Printf.printf "new = %s \npro = %s \nold = %s\n\n" 
      (cnfToString ncs) (cnfToString pcs) (cnfToString ocs); 
  *)
    if n <= 0 then Stop
    else
    let n' = n - 1 in 
    match ncs with 
    | c :: _    when isEmpty c -> Unsat
    | c :: ncs' when isaTautology c 
                 ||  setSubsumes pcs c 
                 ||  setSubsumes ocs c -> 
      repeat ncs' pcs ocs n'
    | c :: ncs' ->
      let pcs = remove (psubsumes c) pcs in
      let ocs = remove (psubsumes c) ocs in
      repeat ncs' (c :: pcs) ocs n'
    | [] -> 
      match pcs with 
      | [] -> Sat
      | c :: pcs' -> 
        let ncs' = allResolvents c ocs in
        repeat ncs' pcs' (c :: ocs) n'
  in
  repeat cs [] [] n


(*
  ===========
  Problem 3.2
  ===========
*)
(* Takes a list 'kb' of proposition, a proposition 'p', and 
   a positive integer 'n'.
   It returns 'Yes' if it can prove by resolution in 'n' iterations
   that 'kb' entails 'p'.
   It returns 'No' if it can prove by resolution in 'n' iterations
   that 'kb' does not entail 'p'.
   It returns 'Unknown' if it cannot prove by resolution in 'n' iterations
   whether 'kb' entails 'p' or not.
 *)
let prove (kb: prop list) (a: prop) (n: int) = 
  let ands = List.fold_left (fun agg li -> And (agg, li)) True kb in
  let counterexample = And (ands, Not a) in
  let cn = cnf counterexample in
  let res = resolution cn n in
  match res with
  | Unsat -> Yes
  | Sat -> No
  | Stop -> Unknown

(*
let (p,   q,   r,   s,   t)  =
    (P 1, P 2, P 3, P 4, P 5) ;;

(prove [p] p 10) = Yes ;;
(prove [Or (p, q); Not q] p 10) = Yes ;;
(prove [Or (p, q); Not q] p 3) = Unknown;;
(prove [Or (p, q); Not r] p 10) = No ;;

(prove [And (p, And (q, r)); And(s, t)] (And (q, t)) 20) = Yes ;;
(prove [Impl (p, q); Impl (r, s)] (Impl (And (p, r), And (q, r))) 20) = Yes ;;
(prove [Impl (p, q); Impl (r, s)] (Impl (And (p, r), And (q, s))) 10) = Unknown ;;
(prove [Iff (Impl (p, q), r); And (Impl (s, Not p), t); Impl (And(Not s, t), q)] r 40) = Yes ;;
*)


(*
  =============
  Problem 4.1-5
  =============
*)
(* You may use these variables to construct the needed propositions *)
let a = P 1
let b = P 2
let c = P 3
let d = P 4
;;

(* Explain here how you answered the problem's questions using 'prove' and report your answer

prove shows whether a list of propositions entails another proposition; here we're given the
entailment of False |= True, so the query is:
let p1 = prove [False] True 10;;
Yes

Here we're asked if (a and not a) entails False. This is essentially asking if the set is unsatisfiable;
if any value satisfied (a and not a) then the entailment would fail. So,
let p2 = prove [a; Not a] False 10;;
Yes

Here, we're asked if (a and b) entails (a iff b). We simply plug them into prove:
let p3 = prove [a; b] (Iff (a, b)) 30;;
Yes

This time, we're asked if a set is unsatisfiable. Again, we check if it entails false; if so, we know
the set of constraints is unsatisfiable.
let p4 = prove [Or (a, b); Impl (a, d); Impl (c, d); Not d; Iff (b, c)] False 40;;
Yes

We're asked if a formula is correct; here, we start with no assumptions and see if the formula can be
verified. If so, it must be true in all situations.
let p5 = prove [] (Impl (a, Impl (b, a))) 40;;
Yes

*)


(*
  ===========
  Problem 5.1
  ===========
*)

(* use these variables to construct the needed propositions *)
let mythical = P 1
let immortal = P 2
let mammal = P 3
let horned = P 4
let magical = P 5

(* If the unicorn is mythical then it is immortal *)
let f1 = Impl (mythical, immortal)

(* If the unicorn is not mythical then it is a mortal mammal *)
let f2 = Impl (Not mythical, And (Not immortal, mammal))

(* If the unicorn is either immortal or a mammal (or both) then it is horned *)
let f3 = Impl (Or (immortal, mammal), horned)

(* The unicorn is magical if it is horned *)
let f4 = Impl (horned, magical)

let kb = [f1; f2; f3; f4]

(*
  ===========
  Problem 5.2
  ===========
*)

(* Explain here how you answers the problem's questions using 'prove' and report your answer

We can use kb to express all of the propositions we need. After this, we check if any individual
proposition must be true.

The unicorn might be mythical or not; we're not guaranteed either.
prove kb mythical 40;;
No

The unicorn is magical because it must be horned, as we see below.
prove kb magical 40;;
Yes

The unicorn must be horned; it must be a mammal if it is not mythical, and it must be immportal if it is mythical.
If the unicorn is either immortal or a mammal, it is horned. Thus, regardless of whether the unicorn is mythical,
it must be horned.
prove kb horned 40;;
Yes

*)







