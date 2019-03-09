open OUnit
open Hw3

let suite =
  "Homework 3" >::: [
    "meaning 1" >:: (fun () ->
      let r = meaning [1;2] (And (P 1, P 2)) in
      assert_equal r true
    );

    "meaning 2" >:: (fun () ->
      let r = meaning [1] (And (P 1, P 2)) in
      assert_equal r false
    );

    "vars 1" >:: (fun () ->
      let r = vars (And (P 1, Not (P 2))) in
      assert_equal r [1; 2]
    );

    "vars 2" >:: (fun () ->
      let r = vars (And (P 1, Or (P 2, P 1))) in
      assert_equal r [2; 1]
    );

    "isUnsat 1" >:: (fun () ->
      let r = isUnsat (And (P 1, Not (P 1))) in
      assert_equal r Yes
    );

    "isUnsat 2" >:: (fun () ->
      let r = isUnsat (And (P 1, Or (Not (P 1), P 2))) in
      assert_equal r No
    );

    "entails 1" >:: (fun () ->
      let ps = [And (P 1, P 2)] in
      let p = Or (P 1, P 2) in
      let r = entails ps p in
      assert_equal r Yes
    );

    "entails 2" >:: (fun () ->
      let ps = [Or (P 1, P 2)] in
      let p = And (P 1, P 2) in
      let r = entails ps p in
      assert_equal r No
    );

    "areEquiv 1" >:: (fun () ->
      let prop1 = Not (And (P 1, P 2)) in
      let prop2 = Or (Not (P 1), Not (P 2)) in
      let r = areEquiv prop1 prop2 in
      assert_equal r Yes
    );

    "areEquiv 2" >:: (fun () ->
      let prop1 = Not (And (P 1, P 2)) in
      let prop2 = And (Not (P 1), Not (P 2)) in
      let r = areEquiv prop1 prop2 in
      assert_equal r No
    );
  ]

let _ = run_test_tt suite
