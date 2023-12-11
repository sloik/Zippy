
import Foundation

import AliasWonderland

// https://hoogle.haskell.org/?hoogle=zip

// MARK: Zip on Optionals
@discardableResult
public func zip<A, B>(
    _ a: A?,
    _ b: B?
) -> (A, B)? {
    guard
        let a = a, let b = b
    else { return .none }

    return (a,b)
}

@discardableResult
public func zipWith<A,B,C>(_ f: @escaping Closure<A,B,C>) -> Closure<A?,B?,C?> {
    return { a, b in
        zip(a,b).map( f )
    }
}

@discardableResult
public func zip<A, B, C>(
    _ a: A?,
    _ b: B?,
    _ c: C?
) -> (A, B, C)? {
    guard
        let a = a, let b = b, let c = c
    else { return .none }

    return (a,b,c)
}

@discardableResult
public func zipWith<A,B,C,D>(_ f: @escaping Closure<A,B,C,D>) -> Closure<A?,B?,C?,D?> {
    return { a, b, c in
        zip(a,b,c).map( f )
    }
}

@discardableResult
public func zip<A, B, C, D>(
    _ a: A?,
    _ b: B?,
    _ c: C?,
    _ d: D?
) -> (A, B, C, D)? {
    guard
        let a = a, let b = b, let c = c, let d = d
    else { return .none }

    return (a,b,c,d)
}

@discardableResult
public func zipWith<A,B,C,D,E>(_ f: @escaping Closure<A,B,C,D,E>) -> Closure<A?,B?,C?,D?,E?> {
    return { a, b, c, d in
        zip(a,b,c, d).map( f )
    }
}

@discardableResult
public func zip<A, B, C, D, E>(
    _ a: A?,
    _ b: B?,
    _ c: C?,
    _ d: D?,
    _ e: E?
) -> (A, B, C, D, E)? {
    guard
        let a = a, let b = b, let c = c, let d = d, let e = e
    else { return .none }

    return (a,b,c,d,e)
}

@discardableResult
public func zipWith<A,B,C,D,E,F>(_ f: @escaping Closure<A,B,C,D,E,F>) -> Closure<A?,B?,C?,D?,E?,F?> {
    return { a, b, c, d, e in
        zip(a,b,c,d,e).map( f )
    }
}

@discardableResult
public func zip<A, B, C, D, E, F>(
    _ a: A?,
    _ b: B?,
    _ c: C?,
    _ d: D?,
    _ e: E?,
    _ f: F?
) -> (A, B, C, D, E, F)? {
    guard
        let a = a, let b = b, let c = c, let d = d, let e = e, let f = f
    else { return .none }

    return (a,b,c,d,e,f)
}

@discardableResult
public func zip<A, B, C, D, E, F, G>(
    _ a: A?,
    _ b: B?,
    _ c: C?,
    _ d: D?,
    _ e: E?,
    _ f: F?,
    _ g: G?
) -> (A, B, C, D, E, F, G)? {
    guard
        let a = a, let b = b, let c = c, let d = d, let e = e, let f = f, let g = g
    else { return .none }

    return (a,b,c,d,e,f,g)
}

@discardableResult
public func zip<A, B, C, D, E, F, G, H>(
    _ a: A?,
    _ b: B?,
    _ c: C?,
    _ d: D?,
    _ e: E?,
    _ f: F?,
    _ g: G?,
    _ h: H?
) -> (A, B, C, D, E, F, G, H)? {
    guard
        let a = a, let b = b, let c = c, let d = d, let e = e, let f = f, let g = g, let h = h
    else { return .none }

    return (a,b,c,d,e,f,g,h)
}

@discardableResult
public func zip<A, B, C, D, E, F, G, H, I>(
    _ a: A?,
    _ b: B?,
    _ c: C?,
    _ d: D?,
    _ e: E?,
    _ f: F?,
    _ g: G?,
    _ h: H?,
    _ i: I?
) -> (A, B, C, D, E, F, G, H, I)? {
    guard
        let a = a, let b = b, let c = c, let d = d, let e = e, let f = f, let g = g, let h = h, let i = i
    else { return .none }

    return (a,b,c,d,e,f,g,h,i)
}

@discardableResult
public func zip<A, B, C, D, E, F, G, H, I, J>(
    _ a: A?,
    _ b: B?,
    _ c: C?,
    _ d: D?,
    _ e: E?,
    _ f: F?,
    _ g: G?,
    _ h: H?,
    _ i: I?,
    _ j: J?
) -> (A, B, C, D, E, F, G, H, I, J)? {
    guard
        let a = a, let b = b, let c = c, let d = d, let e = e, let f = f, let g = g, let h = h, let i = i, let j = j
    else { return .none }

    return (a,b,c,d,e,f,g,h,i,j)
}

// MARK: -
