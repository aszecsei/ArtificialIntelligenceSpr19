open OUnit
open Hw1

let suite =
  "Homework 1" >::: [
    "sum:empty" >:: (fun () ->
      let test_data = [] in
      let result = sum test_data in
      assert_equal 0 result;
    );

    "sum:full" >:: (fun () ->
      let test_data = [10; 3; 5] in
      let result = sum test_data in
      assert_equal 18 result;
    );

    "pairsum:empty" >:: (fun () ->
      let test_data = [] in
      let result = pairsum test_data in
      assert_equal (0, 0) result;
    );

    "pairsum:full" >:: (fun () ->
      let test_data = [(10,1); (3,0); (5,-2)] in
      let result = pairsum test_data in
      assert_equal (18, -1) result;
    );

    "zip" >:: (fun () ->
      let td1 = [4; 2; 5; 9] in
      let td2 = ["a"; "b"; "c"; "d"] in
      let result = zip td1 td2 in
      assert_equal [(4, "a"); (2, "b"); (5, "c"); (9, "d")] result
    );

    "drop:some matches" >:: (fun () ->
      let td = [2; 1; 3; 3; 2; 1] in
      let result = drop 2 td in
      assert_equal [1; 3; 3; 1] result
    );

    "drop:no matches" >:: (fun () ->
      let td = [2; 1; 3; 3; 2; 1] in
      let result = drop 5 td in
      assert_equal td result
    );

    "replaceAll" >:: (fun () ->
      let td = [2; 1; 3; 2; 1] in
      let result = replaceAll 2 22 td in
      assert_equal [22; 1; 3; 22; 1] result
    );

    "insert:3" >:: (fun () ->
      let td = [1; 3; 7; 8] in
      let result = insert 3 td in
      assert_equal td result
    );

    "insert:5" >:: (fun () ->
      let td = [1; 3; 7; 8] in
      let result = insert 5 td in
      assert_equal [1; 3; 5; 7; 8] result
    );

    "sort" >:: (fun () ->
      let td = [1; 3; 8; 7; 1; 5; 3] in
      let result = sort td in
      assert_equal [1; 3; 5; 7; 8] result
    );

    "middle" >:: (fun () -> 
      let td = ['A'; 'B'; 'C'; 'D'; 'E'] in
      let result = middle td in
      assert_equal 'C' result
    );

    "size" >:: (fun () ->
      let td = Node(1, Node(2, Empty, Empty), Node(3, Node(4, Empty, Empty), Empty)) in
      let result = size td in
      assert_equal 4 result
    );

    "depth" >:: (fun () ->
      let td = Node(1, Node(2, Empty, Empty), Node(3, Node(4, Empty, Empty), Empty)) in
      let result = depth td in
      assert_equal 3 result
    );
  ]

let _ = run_test_tt suite