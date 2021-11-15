open Ppxlib
open Builder

let eterm t = estring t

let term_kind kind =
  (match kind with
  | `Pre -> "Pre"
  | `Post -> "Post"
  | `XPost -> "XPost"
  | `Invariant -> "Invariant")
  |> lident
  |> fun c -> pexp_construct c None

let register ~register_name e =
  [%expr [%e e] |> Runtime.Errors.register [%e register_name]]

let violated_invariant kind ~term ~register_name =
  [%expr
    Runtime.Violated_invariant { term = [%e eterm term]; position = [%e kind] }]
  |> register ~register_name

let violated kind = violated_invariant (term_kind kind)

let violated_axiom ~register_name =
  register ~register_name [%expr Runtime.Violated_axiom]

let axiom_failure ~exn ~register_name =
  [%expr Runtime.Axiom_failure { exn = [%e exn] }] |> register ~register_name

let invariant_failure kind ~term ~exn ~register_name =
  [%expr
    Runtime.Specification_failure
      { term = [%e eterm term]; term_kind = [%e kind]; exn = [%e exn] }]
  |> register ~register_name

let spec_failure kind = invariant_failure (term_kind kind)

let unexpected_exn ~allowed_exn ~exn ~register_name =
  let allowed_exn = List.map estring allowed_exn |> elist in
  [%expr
    Runtime.Unexpected_exception
      { allowed_exn = [%e allowed_exn]; exn = [%e exn] }]
  |> register ~register_name

let uncaught_checks ~term ~register_name =
  [%expr Runtime.Uncaught_checks { term = [%e eterm term] }]
  |> register ~register_name

let unexpected_checks ~terms ~register_name =
  let terms = List.map eterm terms |> elist in
  [%expr Runtime.Unexpected_checks { terms = [%e terms] }]
  |> register ~register_name

let report ~register_name = [%expr Runtime.Errors.report [%e register_name]]
