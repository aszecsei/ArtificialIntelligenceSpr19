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

        assert_equal state { emptyPos = (3,2); board = b2}
      );

    "plan" >:: (fun () ->
        let result = execute myPlan startState in
        assert_equal goalState.emptyPos result.emptyPos
      );

    "sumMisplaced 0" >:: (fun () ->
        let result = execute myPlan startState in
        assert_equal (misplacedTiles goalState result) 0
      );

    "sumMisplaced 5" >:: (fun () ->
        assert_equal (misplacedTiles goalState startState) 5
      );
  ]

let _ = run_test_tt suite