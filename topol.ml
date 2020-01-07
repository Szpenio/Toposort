(** PROJECT: Topological Sorting **)
(** Author: Antoni Koszowski **)

(** polymorphic map **)
open PMap;;

(** exception raised in case that dependencies are cyclic **)
exception Cykliczne

(** for a list [(a1, [a11, a12, ...]); ...] where elements [a11, a12, ...]
    are dependent on a1 etc. returns list of elements sorted topologically **)
let topol l =
  let count = ref 0 in
  let nodes = ref [] in
  let sorted = ref [] in
  let degree = ref empty in
  let neighbours = ref empty in
  begin
    (** determining degree (number of earlier elements); list of neighbours
        for each element represented as a node; overall number of elements **)
    List.iter (fun (x, lst)->
        if exists x !degree then
          neighbours := add x (lst @ find x !neighbours) !neighbours
        else (
          nodes := x::!nodes;
          count := !count + 1;
          degree := add x 0 !degree;
          neighbours := add x lst !neighbours
        )
      ) l;
    List.iter (fun (_, lst) ->
        List.iter (fun h ->
            if exists h !degree then
              degree := add h (find h !degree + 1) !degree
            else (
              degree := add h 1 !degree;
              count := !count + 1)
          ) lst
      ) l;
    (** recursive removal of nodes with degree equal 0; decreasing degree
        of their neighbours by 1; decreasing counter of elements on the sorted
        list by 1; in case that not all elements are put on the topologically
        sorted list there is cyclic dependency - raises exception **)
    let rec pom x deg =
      if deg = 0 then (
        count := !count - 1;
        sorted := x::!sorted;
        degree := add x (-1) !degree;
        if exists x !neighbours then
          List.iter (fun h ->
              let pdeg = find h !degree - 1 in
              degree := add h pdeg !degree;
              if pdeg = 0 then pom h pdeg
            ) (find x !neighbours)
      ) in
    List.iter (fun h -> pom h (find h !degree)) !nodes;
    if !count = 0 then !sorted |> List.rev else raise Cykliczne
  end
