
import Foundation

import AliasWonderland

@discardableResult
public func asyncZip<A,B>(
    _ f: @autoclosure AsyncProducer<A>,
    _ g: @autoclosure AsyncProducer<B>
) async -> (A,B) {

    async let a = f()
    async let b = g()

    return await (a,b)
}

@discardableResult
public func asyncZip<A,B,C>(
    _ f: @autoclosure AsyncProducer<A>,
    _ g: @autoclosure AsyncProducer<B>,
    _ h: @autoclosure AsyncProducer<C>
) async -> (A,B,C) {

    async let a = f()
    async let b = g()
    async let c = h()

    return await (a,b,c)
}

@discardableResult
public func asyncZip<A,B,C,D>(
    _ f: @autoclosure AsyncProducer<A>,
    _ g: @autoclosure AsyncProducer<B>,
    _ h: @autoclosure AsyncProducer<C>,
    _ i: @autoclosure AsyncProducer<D>
) async -> (A,B,C,D) {

    async let a = f()
    async let b = g()
    async let c = h()
    async let d = i()

    return await (a,b,c,d)
}

// MARK: - Zip With

@discardableResult
public func asyncZip<A,B,C>(
    _ f: @autoclosure AsyncProducer<A>,
    _ g: @autoclosure AsyncProducer<B>,
    with transform: @escaping Closure<A,B,C>
) async -> C {
    let (a,b): (A,B) = await asyncZip( await f() , await g() )
    return transform(a, b)
}

@discardableResult
public func asyncZip<A,B,C,D>(
    _ f: @autoclosure AsyncProducer<A>,
    _ g: @autoclosure AsyncProducer<B>,
    _ h: @autoclosure AsyncProducer<C>,
    with transform: @escaping Closure<A,B,C,D>
) async -> D {
    let (a,b,c): (A,B,C) = await asyncZip( await f() , await g(), await h() )
    return transform(a, b, c)
}

@discardableResult
public func asyncZip<A,B,C,D,E>(
    _ f: @autoclosure AsyncProducer<A>,
    _ g: @autoclosure AsyncProducer<B>,
    _ h: @autoclosure AsyncProducer<C>,
    _ i: @autoclosure AsyncProducer<D>,
    with transform: @escaping Closure<A,B,C,D,E>
) async -> E {
    let (a,b,c, d): (A,B,C,D) = await asyncZip( await f() , await g(), await h(), await i() )
    return transform(a, b, c, d)
}
