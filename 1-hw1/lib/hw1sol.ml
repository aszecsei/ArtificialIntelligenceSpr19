(*==================================================
    CS:4420 Artificial Intelligence
    Spring 2019
    
    Homework 1
    
    Name: Sample Solution
  ==================================================*)

(*---------
   Part 1
  ---------*)

(* Problem 1 *)
let rec sum l =
  match l with 
  | [] -> 0
  | h :: t -> h + (sum t) 

(* Problem 2 *)
let rec pairsum l = 
  let padd (x1, y1) (x2, y2) = (x1 + x2, y1 + y2) in
  match l with 
  | [] -> (0, 0)
  | h :: t -> padd h (pairsum t) 

(* Problem 3 *)
let rec zip l1 l2 =
  match (l1, l2) with
  | ([], []) -> []
  | (h1 :: t1, h2 :: t2) -> (h1, h2) :: (zip t1 t2)
  | _ -> failwith "Input lists have different length"

(* Problem 4 *)
let rec drop x l =
  match l with
  | [] -> []
  | h :: t when h = x -> drop x t
  | h :: t  -> h :: (drop x t)

(* Problem 5 *)
let rec replaceAll x y l =
  match l with
  | [] -> []
  | h :: t when h = x -> y :: (replaceAll x y t)
  | h :: t  -> h :: (replaceAll x y t)

(* Problem 6 *)
let rec insert n l = 
  match l with 
  | [] -> [n]
  | h :: t when n <= h -> n :: h :: t 
  | h :: t -> h :: (insert n t) 

(* Problem 7 *)
let rec sort l = 
  match l with 
  | [] -> []
  | h :: t -> insert h (sort t)

 (* tail-recursive version *)
let rec sort l = 
  let rec sortAux l1 l2 =
    match l1 with 
    | [] -> l2
    | h :: t -> sortAux t (insert h l2)
  in
  sortAux l []

(* Problem 8 *)
(* helper function, removes last element of input list l when l is non-empty, 
   and raises an exception otherwhise *)
let rec removeLast l = 
  match l with
  | [] -> failwith "List is empty"
  | h :: [] -> []
  | h :: t -> h :: (removeLast t)

let rec middle l = 
  match l with
  | [] -> failwith "List is empty"
  (* l has 1 element *)
  | x :: [] -> x
  (* l has 2 elements *)
  | x :: y :: [] -> failwith "input list does not have middle"
  (* l has at least 3 elements *)
  | h :: t -> let l' = removeLast t in
              middle l' (* the middle of l, if any, is the same as the middle of l' *) 

(* Although the inplementation above does not use a length function, 
   solutions using it are acceptable. 
*)


(*---------
  Part2 
  ---------*)

type 'a btree = Empty | Node of 'a * ('a btree) * ('a btree)

(* Problem 1 *)
let rec size t =
  match t with 
  | Empty -> 0
  | Node (_, t1, t2) -> 1 + size t1 + size t2 

(* Problem 2 *)
let rec depth t =
  let max x y = if x < y then y else x in
  match t with 
  | Empty -> 0
  | Node (_, t1, t2) -> 1 + max (depth t1) (depth t2)

(* Problem 3 *)
let rec prune x t =
  match t with 
  | Empty -> Empty
  | Node (y, t1, t2) when y = x -> Node (y, Empty, Empty)
  | Node (y, t1, t2) -> Node (y, prune x t1, prune x t2)

(* Problem 4 *)
let rotateLeft t = 
  match t with
  | Node (y, t1, Node (x, t2, t3)) -> Node (x, Node (y, t1, t2), t3)
  | _ -> t

(* Problem 5 *)

(* the subtrees of an non-empty node are contained in a list *)
type 'a tree = Empty
             | Node of 'a * ('a tree list)
             
let rec size t =
  match t with 
  | Empty -> 0
  | Node (_, []) -> 1  
  | Node (x, t1 :: l) -> size t1 + size (Node (x, l)) 




