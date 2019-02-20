(*==================================================
    CS:4420 Artificial Intelligence
    Spring 2019

    Homework 2 -- Part A

    Name: <your name here>
  ==================================================*)

(*-------
  Prelude
  ------*)

(** Debugging aid **)
type flagsRec = { debug : bool }

(* set this flag to true when debugging your code 
   set it to false otherwise
*)
let flags = { debug = true } ;;

(*
// (require p f m) silently succeeds if the global flag 'flags.debug' 
// is false or the Boolean input 'p' is true.
// Otherwise, it fails and returns an error message constructed
// with strings 'f' and 's'.
// 'f' is expected to be the name of the function calling 'require'
// while 's' contains the actual error message.
*)
let require p f m =
  if flags.debug && not p then 
    failwith (f ^ ": " ^ m)
  else
    ()
;;

(* This module implements a priority queue. Priorities expressed
   as a floating point numbers, with lower values having higher priority.
   It is used in by the search procedure to store its fringe.
*)
module PQueue = struct
  exception Queue_is_empty
  type priority = float

  type 'a queue = E | N of priority * 'a * 'a queue * 'a queue

  let empty = E

  let isEmpty q = q = E

  let rec insert ip ie q =
    match q with
    | E -> N (ip, ie, E, E)
    | N (p, e, l, r) ->
      if ip <= p 
      then N (ip, ie, insert p e r, l)
      else N (p, e, insert ip ie r, l)

  let insertAll l q = 
    let rec insAll l q =
      match l with
      | [] -> q
      | (p, e) :: t -> insAll t (insert p e q)
    in

    insAll l q

  let top = function
    | E -> raise Queue_is_empty
    | N (_, e, _, _) -> e

  let rec removeTop = function
    | E -> raise Queue_is_empty
    | N (_, _, l, E) -> l
    | N (_, _, E, r) -> r
    | N (_p, _elt, (N (lp, le, _, _) as l),
         (N (rp, re, _, _) as r)) ->
      if lp <= rp
      then N (rp, le, removeTop l, r)
      else N (rp, re, l, removeTop r)

  let extract = function
    | E -> raise Queue_is_empty
    | N (p, e, _, _) as q -> (p, e, removeTop q)
end 
;;


(*--------------------
  Part A -- N-puzzle
  --------------------*)


(***********)
(** Board **)
(***********)

(*
// A position on the puzzle board is encoded just as a pair of integers
// Each coordinate ranges from 1 to n, where n is the square root of N+1.
// Position (1,1) is the top-leftmost position in the board.
*)
type pos = int * int

(* a puzzle tile is encoded just as an integer *)
type tile = int

(* converts positions to their string representation (for printing) *)     
let string_of_pos (x,y) = "(" ^ string_of_int x ^ "," ^ string_of_int y ^ ")"


(* This module is needed to generate maps that take positions as keys *)
module Pos = struct
  type t = pos
  let compare ((x0,y0):pos) ((x1,y1):pos) =
    match Pervasives.compare x0 x1 with
    | 0 -> Pervasives.compare y0 y1
    | c -> c
end

(* PosMap is a module for creating and manipulating maps 
   with positions as keys 
*)
module PosMap = Map.Make(Pos)

(* type of maps from positions to tiles *)
type posTileMap = tile PosMap.t

(* A board is encoded as an immutable record where the cells are stored
   in an immutable map from position to tiles  
*)
type board = { size: int; tiles: posTileMap }

(* 'value' returns the values at position 'p' in board 'b', returning 0
   if that position is unoccupied (ie, it is position of the empty tile)
*)
let value b (p: pos) =
  match PosMap.find_opt p b.tiles with
  | None -> 0
  | Some v -> v  

(* 'swap' returns a new board identical to 'b' except that
     the values at position 'p1' and 'p2' are swapped
*)
let swap b (p1: pos) (p2: pos) = 
  (* check that the input is legal *)
  let inbounds (i, j) = 0 < i && i <= b.size && 0 < j && j <= b.size in
  let _ = require (inbounds p1) "board.Sqwap" "first position is out of bounds" in
  let _ = require (inbounds p2) "board.Sqwap" "second position is out of bounds" in

  let t1 = PosMap.find_opt p1 b.tiles in
  let t2 = PosMap.find_opt p2 b.tiles in
  let tiles' =
    match (t1, t2) with
    | (Some v1, Some v2) -> b.tiles |> PosMap.add p1 v2 |> PosMap.add p2 v1
    | (Some v1, None)    -> b.tiles |> PosMap.remove p1 |> PosMap.add p2 v1
    | (None, Some v2)    -> b.tiles |> PosMap.add p1 v2 |> PosMap.remove p2
    | _                  -> b.tiles
  in
  { size = b.size; tiles = tiles' }



(* 'string_of_board' converts the board to a textual representation *)
let string_of_board b =
  let cellToString tiles r c = 
    match PosMap.find_opt (r,c) tiles with
    | None -> "  "
    | Some (n:tile) -> " " ^ string_of_int n
  in
  let rec rowToString tiles r c = 
    if c <= 0 then ""
    else (rowToString tiles r (c - 1)) ^ (cellToString tiles r c)
  in
  let rec rowsToString tiles r c = 
    if r <= 0 then ""
    else (rowsToString tiles (r - 1) c) ^
         " |" ^ (rowToString tiles r c) ^ " |\n"
  in
  let bar =  " +" ^ (String.make (2 * b.size) '-') ^ "-+\n" 
  in
  "\n" ^ bar ^ (rowsToString b.tiles b.size b.size) ^ bar


(* 'printBoard' prints the board to the standard output channel *)
let printBoard b = Printf.printf "%s\n" (string_of_board b)

(* Note: 
     A value b of type board represents a legal puzzle board in a problem 
     of size n iff 
     1) n = b.size > 0 
     2) b.tiles uniquely maps *each* non-empty tile in the n x n board 
        to a value in {1, ..., n}
     3) the position of the empty cell has no associated value in b.tiles
*)

(****************************
   Test code, copy and paste in the OCaml intepreter as needed

   (* sample map for a board *)
   +-------+
   | 2 8 3 |
   | 1 6 4 |
   | 7 5   |
   +-------+

   (* sample board *)
   let b1 = ...
   ;;

   printBoard b1
   ;;

   (* Boards are converted to strings that print like this:
   +-------+
   | 2 8 3 |
   | 1 6 4 |
   | 7 5   |
   +-------+
 *)

   (* new board generated from b *)
   let b2 = swap b1 (2,3) (3,3)
   ;;

   printBoard b2
   ;;
*)


(***********)
(** State **)
(***********)

(* A problem state is encoded as a record with a board and the position
   of the empty cell in the board
*)
type state = {board: board; emptyPos: pos}

(* Note: 
     A value s of type state represents a legal problem state iff 
     s.board is a legal board and (PosMap.find_opt s.board.tiles s.emptyPos) is None 
*)


(* string_of_state converts states are converted to strings that print like this:
     +-------+
     | 1 3 2 |
     | 4   7 |
     | 6 8 5 |
     +-------+
     (2,2)
*)
let string_of_state s = string_of_board s.board ^ " " ^ (string_of_pos s.emptyPos) ^ "\n"  

let printState s = Printf.printf "%s\n" (string_of_state s)

(******* test code
         (* sample state using previous board b *) 
         let s1 = {board = b1; emptyPos = (3,3)}
         ;;

         printState s1
         ;;
*)



(** Operators **)

(* Operators are represented by a discriminated union *)
type operator = Left | Right | Up | Down

(* The cost of applying an operator to a state is constant (one move) *)
let actionCost (_op: operator) (_s: state) = 1.0

(*-------------
   Problem A.1
  -------------*)

(* 'apply' attemps to apply the operator 'o' to input state
   it returns the next state, wrapped in 'Some' if the operator
   is applicable to state and returns 'None' otherwise 
*)

let apply { emptyPos = (r, c); board = b } o =
  let swapPos = match o with
    | Up -> (r-1, c)
    | Down -> (r+1, c)
    | Left -> (r, c-1)
    | Right -> (r, c+1) in
  try Some({ emptyPos = swapPos; board = (swap b (r,c) swapPos) })
  with _ -> None


(* test code

   (* a successor of the sample goal state *)
   let b = 
   match apply goalState Left with
   | Some x -> x
   | _ -> goalState
   ;;

   printState goalState
   ;;

   printState b
   ;;
*)

(** Solution Plan **)

(*  A solution plan is encoded as an immutable record with a field containing
    a list of the actions that lead from the initial state to a goal state
*)
type plan = { actions: operator list }


(* 'execute' executes the plan in 'p' starting from state 's' *)
let execute p s = 
  let rec exec s l =
    match l with 
    | [] -> s
    | op :: l' -> 
      match apply s op with
      | None -> failwith "Plan is infeasible"
      | Some s' -> exec s' l'
  in 
  exec s p.actions


(* test code

   let s1 = ...

   (* sample plan *)
   let p = {actions = [Left; Up; Right; Up; Left; Down]}

   (* sample execution *)
   let s2 = execute p s1
   ;;

   printState s1
   ;;
   printState s2
   ;;
*)

(*-------------
   Problem A.2
  -------------*)

(* Write a plan that goes from a state with the first configuration below
   to a state with the second. Verify that your plan is correct by running it

   +-------+ 
   | 1 6 2 |
   | 4   3 |
   | 7 5 8 | 
   +-------+

   +-------+
   | 1 2 3 |
   | 4 5 6 |
   | 7 8   |
   +-------+
*)

(* start state *)
(* replace with your definition 
   Hint: |> is your friend
*)
let startState = 
  { emptyPos = (2,2); board = { size = 3; tiles = PosMap.empty |>
                                                  PosMap.add (1,1) 1 |> PosMap.add (1,2) 6 |> PosMap.add (1,3) 2 |>
                                                  PosMap.add (2,1) 4 |>                       PosMap.add (2,3) 3 |>
                                                  PosMap.add (3,1) 7 |> PosMap.add (3,2) 5 |> PosMap.add (3,3) 8 } }

;;

(* Goal state *)
(* replace with your definition *)
let goalState = 
  { emptyPos = (3,3); board = { size = 3; tiles = PosMap.empty |>
                                                  PosMap.add (1,1) 1 |> PosMap.add (1,2) 2 |> PosMap.add (1,3) 3 |>
                                                  PosMap.add (2,1) 4 |> PosMap.add (2,2) 5 |> PosMap.add (2,3) 6 |>
                                                  PosMap.add (3,1) 7 |> PosMap.add (3,2) 8 } }
;;

(* fill in the list *)
let myPlan = 
  { actions = [Up; Right; Down; Left; Down; Right] }
;;

(* test code

   printState startState
   ;;
   printState (execute myPlan startState)
   ;;
*)


(** Heuristics **)

(*-------------
   Problem A.3
  -------------*)

(* 'misplacedTiles' takes a goal state 'gs' and a current state 'cs' and
   returns the number of misplaced tiles in 'cs' with respect to 'gs'
*)
(* complete your implementation by replacing 0 with your code 
   keep the first two lets.
*)
let misplacedTiles gs cs =
  let m = "input states have different sizes" in
  let _ = require (gs.board.size = cs.board.size) "misplacedTiles" m 
  in
  let rec sumMisplaced gs cs currentPos agg =
    let goalTile = PosMap.find_opt currentPos gs.board.tiles in
    let currTile = PosMap.find_opt currentPos cs.board.tiles in
    let newAgg = match goalTile with
      | None -> agg
      | tile -> if tile = currTile then agg else agg + 1 in
    match currentPos with
    | (1,1) -> newAgg
    | (r,1) -> sumMisplaced gs cs (r-1,gs.board.size) newAgg
    | (r,c) -> sumMisplaced gs cs (r,c-1) newAgg
  in
  sumMisplaced gs cs (gs.board.size,gs.board.size) 0


(* test code

   printState startState
   ;;
   printState goalState
   ;;

   misplacedTiles goalState startState
*)


(* Search procedure *)

(* nodes in the search space are encoded as records of this type *)
type node = {
  state: state;           (* state represented by the node *) 
  depth: int;             (* depth of the node in the search tree *)
  cost: float;            (* cost of reaching this node from the root *)
  parent: node option;    (* parent node in the tree (= None for a root node) *)
  action: operator option (* Operator used to generated this node from its 
                             parent (= None for a root node)
                          *) 
}

(* checks whether state 's' occorrs in the path from 'n' to the root node *)
let rec isInPath s n =
  match n with
  | None -> false
  | Some {state = s'; parent = n'; _} -> 
    (string_of_board s.board = string_of_board s'.board) || isInPath s n'

(* 'expand' takes a heuristic function 'f' and a node 'n',
   generates all the successors of 'n' in the search tree,
   and returns them in a list of pairs '(v, m)' where 'm' 
   is a successor of 'n' and 'v' is '(f v)'
*)
let expand f n = 
  let apply' n a = (apply n.state a, a) in
  let sl = List.map (apply' n) [Left; Right; Up; Down] in
  let rec exp l1 l2 =
    match l1 with
    | [] -> l2
    | (None, _) :: t -> exp t l2
    | (Some s, _a) :: t when isInPath s (Some n) -> exp t l2
    | (Some s, a) :: t -> 
      let ns = {state = s; depth = n.depth + 1; cost = n.cost +. actionCost a n.state;
                parent = Some n; action = Some a} in
      exp t ((f ns, ns) :: l2)
  in
  exp sl []

(* 'extractPlan' takes a node 'n' and returns in a list, in order, 
   the sequence of operators that have been applied to the root node
   to generate 'n' 
*)
let extractPlan n = 
  let rec ep n l = 
    match n with 
    | {parent = None; _} -> l
    | {parent = Some n; action = Some a; _} -> ep n (a :: l)  
    | _ -> failwith "Ill-formed state"
  in
  ep n []

(* 'treeSearch' implements a generic informed-search procedure parametrized 
    by an initial state 'initState', a heuristic function 'f' and a goal function 'isGoal'
   - 'f' takes a node and returns its value, used as its priority
   - 'isGoal' takes a node and returns true iff the node contains a goal state.
*)
let treeSearch initState f isGoal =
  let rec search (fringe : node PQueue.queue) = 
    if PQueue.isEmpty fringe then 
      failwith "Search failed"
    else
      let (_p, n, fringe1) = PQueue.extract fringe in
      if isGoal n then
        n
      else
        let fringe2 = PQueue.insertAll (expand f n) fringe1 in
        search fringe2
  in
  let rn = {state = initState; parent = None; action = None; depth = 0; cost = 0.0} in
  let rp = f rn in
  let fringe =  PQueue.insert rp rn PQueue.empty in 
  search fringe

(* specific implementatation of 'isGoal' that succeeds only for the 'goalState' given earlier *)
let isMyGoal n = (string_of_board n.state.board = string_of_board goalState.board)

(*-------------
   Problem A.4
  -------------*)

(* 'greedyBF' takes a node 'n' and returns the value of 'n'
   according to the greedy best-first heuristics where 
   h(n) is the the number of misplaced tiles.

   You may find the predefined conversion function 'float_of_int' useful.
*)
let greedyBF n = 
  float_of_int (misplacedTiles n.state goalState)

(* {actions =
    [Down; Right; Up; Up; Left; Right; Left; Down; Up; Right; Down; Down;
     Left; Left; Right; Right; Left; Up; Up; Right; Down; Left; Down; Right;
     Up; Down; Left; Left; Right; Right; Left; Left; Up; Down; Right; Right;
     Left; Up; Down; Right; Up; Down; Left; Left; Right; Right]}
*)

(* 'aStar' takes a node 'n' and returns the value of 'n'
   according to the A* first heuristics where
   h(n) is the the number of misplaced tiles.
*)
(*
{actions =
    [Up; Right; Down; Left; Left; Right; Down; Up; Right; Left; Down; Left;
     Right; Right; Up; Down; Left; Left; Right; Right]}
*)
let aStar n = 
  (float_of_int (misplacedTiles n.state goalState)) +. n.cost
;;


(* test code
   let n1 = treeSearch startState greedyBF isMyGoal
   let p1 = { actions = extractPlan n1 }
   ;;

   printState (execute p1 startState) ;;

   let n2 = treeSearch startState aStar isMyGoal
   let p2 = { actions = extractPlan n2 } 
   ;;
   printState (execute p2 startState) ;;

*)



(*-------------
   Problem A.5
  -------------*)
let manhattanDist gs cs =
  let m = "input states have different sizes" in
  let _ = require (gs.board.size = cs.board.size) "misplacedTiles" m in
  let manhattan (r1,c1) (r2,c2) =
    (abs (r1-r2)) + (abs (c1-c2)) in
  let findPos v b =
    let rec findPosHelper v b currentPos =
      match (PosMap.find_opt currentPos b.tiles) with
      | Some(value) when value = v -> currentPos
      | _ -> match currentPos with
        | (1,1) -> failwith "Tile not found"
        | (r,1) -> (findPosHelper v b (r-1,b.size))
        | (r,c) -> (findPosHelper v b (r,c-1)) in
    findPosHelper v b (b.size, b.size) in
  let rec sumManhattan gs cs currentPos agg =
    let goalTile = PosMap.find_opt currentPos gs.board.tiles in
    let newAgg = match goalTile with
      | None -> agg
      | Some(tile) -> agg + manhattan currentPos (findPos tile cs.board) in
    match currentPos with
    | (1,1) -> newAgg
    | (r,1) -> sumManhattan gs cs (r-1,gs.board.size) newAgg
    | (r,c) -> sumManhattan gs cs (r,c-1) newAgg
  in
  sumManhattan gs cs (gs.board.size,gs.board.size) 0
;;

let greedyBFM n = 
  float_of_int (manhattanDist n.state goalState)

(*
  [Up; Right; Down; Left; Down; Right; Up; Down; Left; Left; Right; Right;
   Left; Left; Up; Down; Right; Right; Left; Up; Down; Right; Up; Down; Left;
   Left; Right; Right]
*)

let aStarM n = 
  (float_of_int (manhattanDist n.state goalState)) +. n.cost

(*
  [Up; Right; Down; Left; Left; Right; Down; Right; Up; Down; Left; Left;
 Right; Right]
*)