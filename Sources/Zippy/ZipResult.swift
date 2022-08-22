
import Foundation
import AliasWonderland

public func zip<A,B, E: Error>(
    _ a: Result<A,E>,
    _ b: Result<B,E>
) -> Result<(A,B), [E]> {
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

public func zip<A,B,Output, E: Error>(
    with f: @escaping Closure2I<A,B,Output>
)
-> (Result<A, E>, Result<B, E>)
-> Result<Output, [E]> {
    return { rla, rlb in
        zip(rla, rlb).map( f )
    }
}

// MARK: - Array of Errors

extension Array: Error where Element: Error {}
