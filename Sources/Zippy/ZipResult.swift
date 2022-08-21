
import Foundation
import AliasWonderland

public func zip<A,B>(
    _ a: Result<A,Error>,
    _ b: Result<B,Error>
) -> Result<(A,B), [Error]> {
    switch (a, b) {
    case (.success(let a), .success(let b)):
        return .success((a, b))

    case (.success, .failure(let error)):
        return .failure([error])

    case (.failure(let error), .success):
        return .failure([error])

    case (.failure(let aError), .failure(let bError)):
        return .failure([aError, bError])
    }
}

// MARK: - Zip With

public func zip<A,B,Output>(
    with f: @escaping Closure2I<A,B,Output>
)
-> (Result<A, Error>, Result<B,Error>)
-> Result<Output, [Error]> {
    return { rla, rlb in
        zip(rla, rlb).map( f )
    }
}

// MARK: - Array of Errors

extension Array: Error where Element: Error {}
