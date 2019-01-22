open OUnit
open Problems

let suite =
  "99 Problems" >::: [
    "last:full list" >:: (fun () ->
      let test_data = [ "a" ; "b" ; "c" ; "d" ] in
      let result = last test_data in
      assert_equal (Some "d") result;
    );

    "last:empty list" >:: (fun () ->
      let test_data = [] in
      let result = last test_data in
      assert_equal None result;
    );

    "last_two:full list" >:: (fun () ->
      let test_data = [ "a" ; "b" ; "c" ; "d" ] in
      let result = last_two test_data in
      assert_equal (Some ("c", "d")) result;
    );

    "last_two:single element" >:: (fun () ->
      let test_data = [ "a" ] in
      let result = last_two test_data in
      assert_equal None result;
    );

    "last_two:empty list" >:: (fun () ->
      let test_data = [] in
      let result = last_two test_data in
      assert_equal None result;
    );

    "at:result" >:: (fun () ->
      let test_data = [ "a" ; "b" ; "c" ; "d" ] in
      let result = at 3 test_data in
      assert_equal (Some "c") result;
    );

    "at:out of bounds" >:: (fun () ->
      let test_data = [ "a" ] in
      let result = at 3 test_data in
      assert_equal None result;
    );

    "length:full" >:: (fun () ->
      let test_data = [ "a" ; "b" ; "c" ] in
      let result = length test_data in
      assert_equal 3 result;
    );

    "length:empty" >:: (fun () ->
      let test_data = [] in
      let result = length test_data in
      assert_equal 0 result;
    );

    "rev:full" >:: (fun () ->
      let test_data = ["a" ; "b" ; "c"] in
      let result = rev test_data in
      assert_equal ["c" ; "b" ; "a"] result;
    );
  ]

let _ = run_test_tt suite