(*==================================================
    CS:4420 Artificial Intelligence
    Spring 2019
    
    Homework 1
    
    Name: Alic Szecsei
  ==================================================*)

(*---------
   Part 1
  ---------*)

(* Problem 1 *)
let sum l =
  let rec sum_helper l agg =
    match l with
    | [] -> agg
    | h :: t -> sum_helper t (agg + h) in
  sum_helper l 0


(* Problem 2 *)
let pairsum l =
  let rec pairsum_helper l (agg1, agg2) =
    match l with
    | [] -> (agg1, agg2)
    | (h1, h2) :: t -> pairsum_helper t (h1 + agg1, h2 + agg2) in
  pairsum_helper l (0, 0)

(* Problem 3 *)
let rec zip l1 l2 =
  match (l1, l2) with
  | ([], []) -> []
  | (_, []) -> failwith "list length mismatch"
  | ([], _) -> failwith "list length mismatch"
  | (h1 :: t1, h2 :: t2) -> (h1, h2) :: zip t1 t2

(* Problem 4 *)
let rec drop v l =
  match l with
  | [] -> []
  | h :: t -> if h == v then drop v t else h :: drop v t

(* Problem 5 *)
let rec replaceAll x y l =
  match l with
  | [] -> []
  | h :: t -> if h == x then y :: replaceAll x y t else h :: replaceAll x y t

(* Problem 6 *)
let rec insert i l =
  match l with
  | [] -> i :: []
  | h :: t -> if h == i then h :: t else if i < h then i :: h :: t else h :: insert i t

(* Problem 7 *)
let rec sort l =
  match l with
  | [] -> []
  | h :: t -> insert h (sort t)

(* Problem 8 *)
let rec middle l =
  let rec reverse l =
    match l with
    | [] -> []
    | h :: t -> reverse t @ [h] in
  match l with
  | [] -> failwith "list does not have a middle"
  | h :: [] -> h
  | _ :: t -> match (reverse t) with
              | [] -> failwith "should never happen"
              | _ :: [] -> failwith "list does not have a middle"
              | _ :: t -> middle t


(*---------
  Part2 
  ---------*)

type 'a btree = Empty | Node of 'a * ('a btree) * ('a btree)

(* Problem 1 *)
let rec size t =
  match t with
  | Empty -> 0
  | Node(_, l, r) -> 1 + size l + size r

(* Problem 2 *)
let rec depth t =
  match t with
  | Empty -> 0
  | Node(_, l, r) -> 1 + (if depth l < depth r then depth r else depth l)

(* Problem 3 *)
let rec prune x t =
  match t with
  | Empty -> Empty
  | Node(v, l, r) -> if v == x then Node(v, Empty, Empty) else Node(v, prune x l, prune x r)

(* Problem 4 *)
let rotateLeft t =
  match t with
  | Node(y, t1, Node(x, t2, t3)) -> Node(x, Node(y, t1, t2), t3)
  | _ -> t

(* Problem 5 *)
type 'a tree = TNode of 'a * (('a tree) list)

let rec size t =
  let rec size_helper lt =
    match lt with
    | [] -> 0
    | h :: t -> (size h) + (size_helper t) in
  match t with
  | TNode(_, l) -> 1 + size_helper l