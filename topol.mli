(** Topological sort **)

exception Cykliczne
(** exception raised in case that dependencies are cyclic **)

val topol : ('a * 'a list) list -> 'a list
(** for a list [(a1, [a11, a12, ...]); ...] where elements [a11, a12, ...]
    are dependent on a1 etc. returns list of elements sorted topologically **)
