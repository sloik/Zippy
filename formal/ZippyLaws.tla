---------------------------- MODULE ZippyLaws -----------------------------
(* Finite model of Sources/Zippy: zip / zipWith on Optional (arity 2..4),  *)
(* zip / zipWith on Either (accumulating Lefts into an array), and         *)
(* asyncZip (arity 2..4, with transform). Tuples are TLA+ sequences.       *)
(* NOTE: Zippy zips Optionals/Eithers/async producers, not sequences.      *)
(* Payloads range over a tiny carrier; transforms over the full function   *)
(* space, so each law holds for every possible closure.                    *)
EXTENDS Naturals, Sequences

CONSTANTS Vals,     \* carrier for payloads
          Mutant    \* "none" for the real semantics, otherwise a seeded bug

None      == [tag |-> "none"]
Some(x)   == [tag |-> "some", v |-> x]
Opts(S)   == {None} \cup {Some(x) : x \in S}
IsSome(o) == o.tag = "some"

\* ZipOptional.swift (guard let ... else { return .none })
Zip2(a, b) ==
  IF IsSome(a) /\ IsSome(b)
  THEN Some(<<a.v, b.v>>)
  ELSE IF Mutant = "zip_ignores_second" /\ IsSome(a) THEN Some(<<a.v, a.v>>)
  ELSE None
Zip3(a, b, c) ==
  IF IsSome(a) /\ IsSome(b) /\ IsSome(c) THEN Some(<<a.v, b.v, c.v>>) ELSE None
Zip4(a, b, c, d) ==
  IF IsSome(a) /\ IsSome(b) /\ IsSome(c) /\ IsSome(d)
  THEN Some(<<a.v, b.v, c.v, d.v>>) ELSE None
OMap(o, f) == IF IsSome(o) THEN Some(f[o.v]) ELSE None   \* Optional.map
ApplyT2(f, t) == f[t[1], t[2]]                          \* transform (a, b)

Lefts    == {[tag |-> "left",  v |-> x] : x \in Vals}
Rights   == {[tag |-> "right", v |-> x] : x \in Vals}
IsRight(e) == e.tag = "right"
IsLeft(e)  == e.tag = "left"
EMap(e, f) == IF IsRight(e) THEN [tag |-> "right", v |-> f[e.v]] ELSE e

\* ZipEither.swift: Left payloads are collected into an array, a then b.
EZip(a, b) ==
  IF IsRight(a) /\ IsRight(b) THEN [tag |-> "right", v |-> <<a.v, b.v>>]
  ELSE IF IsRight(a) /\ IsLeft(b) THEN [tag |-> "left", v |-> <<b.v>>]
  ELSE IF IsLeft(a) /\ IsRight(b)
       THEN [tag |-> "left", v |-> IF Mutant = "either_drops_right_left" THEN <<>> ELSE <<a.v>>]
  ELSE [tag |-> "left", v |-> <<a.v, b.v>>]

\* ZipAsync.swift: structured concurrency; the result is the tuple of the
\* producers' results, in argument order, whatever the scheduling.
AZip2(x, y)    == <<x, y>>
AZip3(x, y, z) == <<x, y, z>>
AZip4(x, y, z, w) == <<x, y, z, w>>

VARIABLES a, b, c, d, ea, eb
vars == <<a, b, c, d, ea, eb>>
Init == /\ a \in Opts(Vals) /\ b \in Opts(Vals)
        /\ c \in Opts(Vals) /\ d \in Opts(Vals)
        /\ ea \in Lefts \cup Rights /\ eb \in Lefts \cup Rights
Next == UNCHANGED vars
Spec == Init /\ [][Next]_vars

TypeOK == /\ a \in Opts(Vals) /\ b \in Opts(Vals) /\ c \in Opts(Vals) /\ d \in Opts(Vals)
          /\ ea \in Lefts \cup Rights /\ eb \in Lefts \cup Rights

\* --- Optional ---
OptNoneAbsorbs ==
  /\ (~IsSome(a) \/ ~IsSome(b)) => Zip2(a, b) = None
  /\ (~IsSome(a) \/ ~IsSome(b) \/ ~IsSome(c)) => Zip3(a, b, c) = None
  /\ (~IsSome(a) \/ ~IsSome(b) \/ ~IsSome(c) \/ ~IsSome(d)) => Zip4(a, b, c, d) = None
OptProjection ==
  /\ IsSome(Zip2(a, b)) => (Zip2(a, b).v[1] = a.v /\ Zip2(a, b).v[2] = b.v)
  /\ IsSome(Zip3(a, b, c)) =>
       (Zip3(a, b, c).v = <<a.v, b.v, c.v>>)
  /\ IsSome(Zip4(a, b, c, d)) =>
       (Zip4(a, b, c, d).v = <<a.v, b.v, c.v, d.v>>)
OptSomeIffAllSome ==
  /\ IsSome(Zip2(a, b)) <=> (IsSome(a) /\ IsSome(b))
  /\ IsSome(Zip3(a, b, c)) <=> (IsSome(a) /\ IsSome(b) /\ IsSome(c))
  /\ IsSome(Zip4(a, b, c, d)) <=> (IsSome(a) /\ IsSome(b) /\ IsSome(c) /\ IsSome(d))
\* Zipping a prefix first and then the rest gives the same flattened tuple.
OptZipAssociative ==
  /\ IsSome(Zip2(Zip2(a, b), c)) <=> IsSome(Zip3(a, b, c))
  /\ IsSome(Zip3(a, b, c)) => Zip2(Zip2(a, b), c).v = <<<<a.v, b.v>>, c.v>>
  /\ IsSome(Zip3(a, b, c)) => Zip3(a, b, c).v = <<a.v, b.v, c.v>>
OptZipWithIsMapOfZip ==
  \A f \in [Vals \X Vals -> Vals] :
    LET zw == IF IsSome(a) /\ IsSome(b) THEN Some(f[a.v, b.v]) ELSE None
    IN zw = OMap(Zip2(a, b), [t \in Vals \X Vals |-> f[t[1], t[2]]])
OptZipSwapSymmetry ==
  Zip2(a, b) = None <=> Zip2(b, a) = None

\* --- Either ---
EitherRightRight ==
  (IsRight(ea) /\ IsRight(eb)) => EZip(ea, eb) = [tag |-> "right", v |-> <<ea.v, eb.v>>]
EitherAccumulatesLefts ==
  /\ IsLeft(EZip(ea, eb)) <=> (IsLeft(ea) \/ IsLeft(eb))
  /\ IsLeft(EZip(ea, eb)) =>
       Len(EZip(ea, eb).v) = (IF IsLeft(ea) THEN 1 ELSE 0) + (IF IsLeft(eb) THEN 1 ELSE 0)
EitherLeftOrder ==
  (IsLeft(ea) /\ IsLeft(eb)) => EZip(ea, eb).v = <<ea.v, eb.v>>
EitherSingleLeftPayload ==
  /\ (IsLeft(ea) /\ IsRight(eb)) => EZip(ea, eb).v = <<ea.v>>
  /\ (IsRight(ea) /\ IsLeft(eb)) => EZip(ea, eb).v = <<eb.v>>
EitherZipWithIsMap ==
  \A f \in [Vals \X Vals -> Vals] :
    LET mapped == EMap(EZip(ea, eb), [t \in Vals \X Vals |-> f[t[1], t[2]]])
    IN IsRight(ea) /\ IsRight(eb) => mapped = [tag |-> "right", v |-> f[ea.v, eb.v]]

\* --- asyncZip ---
AsyncZipIsTuple ==
  \A x, y, z, w \in Vals :
    /\ AZip2(x, y) = <<x, y>>
    /\ AZip3(x, y, z) = <<x, y, z>>
    /\ AZip4(x, y, z, w) = <<x, y, z, w>>
AsyncProjection ==
  \A x, y, z \in Vals : AZip3(x, y, z)[1] = x /\ AZip3(x, y, z)[2] = y /\ AZip3(x, y, z)[3] = z
AsyncWithEqualsApply ==
  \A f \in [Vals \X Vals -> Vals] : \A x, y \in Vals :
    f[AZip2(x, y)[1], AZip2(x, y)[2]] = f[x, y]
=============================================================================
