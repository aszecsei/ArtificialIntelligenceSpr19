let rec last l =
  match l with
  | [] -> None
  | x :: [] -> Some x
  | _hd :: tl -> last tl

let rec last_two l =
  match l with
  | [] -> None
  | _ :: [] -> None
  | x :: y :: [] -> Some (x, y)
  | _ :: tl -> last_two tl

let rec at k l =
  match k, l with
  | _, [] -> None
  | 1, v :: _ -> Some v
  | x, _ :: tl -> at (x-1) tl

let length l =
  let rec length_helper n l =
    match l with
    | [] -> n
    | _ :: t -> length_helper (n+1) t in
  length_helper 0 l

let rev l =
  let rec rev_helper acc l =
    match l with
    | [] -> acc
    | h :: t -> rev_helper (h :: acc) t in
  rev_helper [] l