# Formal model (TLA+)

`ZippyLaws.tla` is a finite TLA+ model of the public semantics of `Sources/Zippy`:
`zip` / `zipWith` on `Optional` (arity 2 to 4 modelled), `zip` / `zipWith` on `Either`
(Lefts accumulate into an array), and `asyncZip` (arity 2 to 4). Payloads range over
`Vals = {0, 1}`; transforms range over the whole finite function space, so each law holds for
every closure. Tuples are TLA+ sequences; `Optional`/`Either` are tagged records.

Note: despite the name, Zippy zips `Optional`s, `Either`s and async producers, not sequences, so
there is no "length = min" law to model.

| Invariant | Swift API it abstracts |
|---|---|
| `TypeOK` | domain of the model variables |
| `OptNoneAbsorbs`, `OptSomeIffAllSome` | `zip(_:_:)`, 3- and 4-ary: any `nil` gives `nil` |
| `OptProjection` | zipped tuple components equal the inputs, in order |
| `OptZipAssociative` | nested 2-ary zip is `some` exactly when the flat 3-ary zip is |
| `OptZipWithIsMapOfZip` | `zipWith(f)(a, b) == zip(a, b).map(f)` |
| `OptZipSwapSymmetry` | `zip(a, b)` is `nil` iff `zip(b, a)` is `nil` |
| `EitherRightRight` | `zip(.right, .right)` gives `.right((a, b))` |
| `EitherAccumulatesLefts`, `EitherLeftOrder`, `EitherSingleLeftPayload` | `.left([l])` for one Left, `.left([l1, l2])` in argument order for two |
| `EitherZipWithIsMap` | `zip(with: f)` is `zip(...).map(f)` |
| `AsyncZipIsTuple`, `AsyncProjection`, `AsyncWithEqualsApply` | `asyncZip` result is the tuple of results in argument order; `with:` applies the transform to them |

## Abstractions

Only Optional zip is modelled up to arity 4 (the code goes to 10 with identical structure).
Concurrency is abstracted: `asyncZip` is modelled as its deterministic result tuple, so the
async invariants are close to definitional and only guard the argument-order contract; they
do not check scheduling, cancellation or autoclosure evaluation. `Either` zip has no 3-ary form.

## Non-vacuity

Each `ZippyLaws.<mutant>.cfg` seeds one bug through the `Mutant` constant and names the
invariant that must catch it (`\* EXPECT_VIOLATION: ...`):

- `zip_ignores_second`: zip returns `some` when only `a` is `some` (caught by `OptNoneAbsorbs`).
- `either_drops_right_left`: a Left in the first slot with a Right second loses its payload
  (caught by `EitherSingleLeftPayload`).

`run_tlc.sh` fails if a mutant passes.

## Running

Local runs and CI use the shared Oracle queue through `formal/run_tlc.sh`.
They require an installed, authorized `tla-queue` client and configured access to
the maintainer-operated Oracle backend. Ask the maintainer for client setup and
access; public repository access does not provide queue access.

Run from the repository root after that setup:

```sh
TLA_JAR=/path/to/tla2tools-1.7.4.jar formal/run_tlc.sh   # needs Java 11+ on Oracle
```

`TLA_JAR` and optional `JAVA` overrides refer to **Oracle-side tools**. The example
JAR path must already exist on Oracle; leave the overrides unset to use the remote
defaults. For this check, do not run Java/TLC locally, install or download a local
toolchain (including with `mise`), or use direct SSH as a fallback. A missing
client, unavailable queue, incomplete run, or nonzero wrapper exit is not a
verification pass.

The script checks the jar's SHA-256 against the pinned tla2tools 1.7.4. CI runs it on a
self-hosted Oracle ARM64 runner, only on pushes to the default branch or by manual dispatch
(`.github/workflows/oracle-tla.yml`). The Swift build and tests stay on hosted macOS.

## Limits

The model describes the *intended* semantics, read by hand from the Swift sources. It does not
prove the Swift code conforms; the XCTest suite covers the code. If the Swift behaviour
changes, update the model in the same PR.
