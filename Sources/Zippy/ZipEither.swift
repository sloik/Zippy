
import Foundation

import AliasWonderland
import EitherSwift

public func zip<A,B,L>(
    _ a: Either<L, A>,
    _ b: Either<L, B>
) -> Either<[L], (A,B)> {
    switch (a, b) {
    case (.right(let a), .right(let b)):
        return .right((a, b))

    case (.right, .left(let l)):
        return .left([l])

    case (.left(let l), .right):
        return .left([l])

    case (.left(let l1), .left(let l2)):
        return .left([l1, l2])
    }
}

// MARK: - Zip With

public func zip<A,B,C,D>(
    with f: @escaping Closure2I<A,B,C>
)
-> (Either<D,A>, Either<D,B>)
-> Either<[D],C> {
    return { eda, ebd in
        zip(eda, ebd).map( f )
    }
}
