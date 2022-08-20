
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
