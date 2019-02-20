open OUnit
open Hw2

let suite =
  "Homework 2" >::: [
    "apply" >:: (fun () ->
        let b1 = {
          size = 3;
          tiles = PosMap.empty |>
                  PosMap.add (1,1) 2 |> PosMap.add (1,2) 8 |> PosMap.add (1,3) 3 |>
                  PosMap.add (2,1) 1 |> PosMap.add (2,2) 6 |> PosMap.add (2,3) 4 |>
                  PosMap.add (3,1) 7 |> PosMap.add (3,2) 5
        } in
        let b2 = {
          size = 3;
          tiles = PosMap.empty |>
                  PosMap.add (1,1) 2 |> PosMap.add (1,2) 8 |> PosMap.add (1,3) 3 |>
                  PosMap.add (2,1) 1 |> PosMap.add (2,2) 6 |> PosMap.add (2,3) 4 |>
                  PosMap.add (3,1) 7                       |> PosMap.add (3,3) 5
        } in
        let result = apply { emptyPos = (3,3); board = b1 } Left in

        let state = match result with
          | Some(state) -> state
          | None -> assert_failure "Application was thought to be invalid" in

        assert_equal (string_of_state state) (string_of_state { emptyPos = (3,2); board = b2})
      );

    "plan" >:: (fun () ->
        assert_equal (string_of_state (execute myPlan startState)) (string_of_state goalState)
      );

    "sumMisplaced 0" >:: (fun () ->
        assert_equal (misplacedTiles goalState (execute myPlan startState)) 0
      );

    "sumMisplaced 5" >:: (fun () ->
        assert_equal (misplacedTiles goalState startState) 5
      );

    "heuristics" >:: (fun () ->
        let n1 = treeSearch startState greedyBF isMyGoal in
        let p1 = { actions = extractPlan n1 } in

        (* printState (execute p1 startState); *)

        let n2 = treeSearch startState aStar isMyGoal in
        let p2 = { actions = extractPlan n2 } in
        (* printState (execute p2 startState); *)

        assert_equal (string_of_state (execute p2 startState)) (string_of_state (execute p1 startState));
        assert_equal (string_of_state (execute p2 startState)) (string_of_state goalState);
      );

    "manhattan" >:: (fun () ->
        let n1 = treeSearch startState greedyBFM isMyGoal in
        let p1 = { actions = extractPlan n1 } in

        (* printState (execute p1 startState); *)

        let n2 = treeSearch startState aStarM isMyGoal in
        let p2 = { actions = extractPlan n2 } in
        (* printState (execute p2 startState); *)

        assert_equal (string_of_state (execute p2 startState)) (string_of_state (execute p1 startState));
        assert_equal (string_of_state (execute p2 startState)) (string_of_state goalState);
      );
  ]

let _ = run_test_tt suite