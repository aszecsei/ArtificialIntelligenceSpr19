(*==================================================
    CS:4420 Artificial Intelligence
    Spring 2019
    
    Homework 3 - Part A
    
    Name: Alic Szecsei

  ==================================================*)



type id = int

type interpr = id list 

type prop = True 
          | False
          | P of id
          | Not of prop
          | Or of prop * prop
          | And of prop * prop
          | Impl of prop * prop
          | Iff of prop * prop

type answer = Yes | No | Unknown

(* Problem 1.1 *)

let rec meaning i p = 
  match p with
  | True -> true
  | False -> false
  | P (id) -> (List.mem id i)
  | Not (prop) -> not (meaning i prop)
  | Or (p1, p2) -> ((meaning i p1) || (meaning i p2))
  | And (p1, p2) -> ((meaning i p1) && (meaning i p2))
  | Impl (p1, p2) -> (not ((not (meaning i p2)) && (meaning i p1)))
  | Iff (p1, p2) -> ((meaning i p1) && (meaning i p2)) || ((not (meaning i p1)) && (not (meaning i p2)))

(* test code
meaning [0;1] (Iff (P 0, P 1)) ;;
meaning [0] (Iff (P 0, P 1))  ;;
*)

(* Problem 1.2 *)

let vars p = 
  let rec vars_helper p l =
    match p with
    | True -> l
    | False -> l
    | P (id) -> if (List.mem id l) then l else id :: l
    | Not (prop) -> vars_helper prop l
    | Or (p1, p2) -> vars_helper p1 (vars_helper p2 l)
    | And (p1, p2) -> vars_helper p1 (vars_helper p2 l)
    | Impl (p1, p2) -> vars_helper p1 (vars_helper p2 l)
    | Iff (p1, p2) -> vars_helper p1 (vars_helper p2 l) in
  vars_helper p []


(* test code
vars (Iff (Impl (P 0, P 2), And (P 1, P 2))) ;;
*)

(* (sublists l) returns the list of all the sublists of l
*)
let rec sublists l =
  match l with 
  | [] -> [[]]
  | h :: t -> 
    let s = sublists t in
      s @ (List.map (fun l -> h :: l) s)


(* test code
sublists [1; 2; 3] ;;
*)
(* (satisfies p i) returns true iff 'p' is true in 'i'
*)
let satifies i p = meaning i p

(* (isValid p) returns Yes iff 'p' is a valid proposition
*)
let isValid p =
  let interpretations = sublists (vars p) in
  if List.for_all (fun i -> satifies i p) interpretations then 
    Yes
  else
    No 

(* test code
isValid (Iff (Or (P 1, Not (P 1)), Not False))
*)

(* Problem 1.3 *)

let isUnsat p = 
  let interpretations = sublists (vars p) in
  if List.exists (fun i -> satifies i p) interpretations then 
    No
  else
    Yes
  


(* Problem 1.4 *)

let entails ps p =
  let interpretations = sublists (vars p) in
  if List.exists (fun i -> (List.for_all (fun x -> satifies i x) ps) && not (satifies i p)) interpretations then
    No
  else
    Yes


(* test code
entails [P 1; P 2; P 3] (Or (P 2, P 5))
entails [P 1; P 2; P 3] (Or (P 8, P 5))
*)

(* Problem 1.5 *)

let areEquiv p1 p2 = 
  if (entails [p1] p2 == Yes) && (entails [p2] p1 == Yes) then Yes else No



(* Problem 2.1 *)

(* 

You could construct a variable for each statement. For example,

let modusPonens = entails [(Impl (P 1) (P 2)); (P 1)] (P 2)

If the entailment holds, then we've confirmed for any values of alpha (P 1) and beta (P 2), that
if alpha implies beta and alpha is true, then beta is also true.

*)

