import XCTest
import AliasWonderland
import Zippy
import EitherSwift

final class ZipEitherTests: XCTestCase {

    func test_zip() {

        zip( eitherRightStringInt, .right(52) )
            .map { (leftRitht, rightRight) in
                XCTAssertEqual(leftRitht, eitherRightStringInt.right!)
                XCTAssertEqual(rightRight, 52)
            }
            .mapLeft { _ in
                XCTFail("For two right cases should return right case either!")
            }

        zip( eitherLeftStringInt, .right(52) )
            .mapLeft { (lefts: [String]) in
                let expctedLefts = [ eitherLeftStringInt.left! ]
                XCTAssertEqual(lefts, expctedLefts)
            }
            .map { _ in
                XCTFail("For either containig aby left case should return left case either!")
            }

        zip( .right(52), eitherLeftStringInt )
            .mapLeft { (lefts: [String]) in
                let expctedLefts = [ eitherLeftStringInt.left! ]
                XCTAssertEqual(lefts, expctedLefts)
            }
            .map { _ in
                XCTFail("For either containig aby left case should return left case either!")
            }

        zip( eitherLeftStringInt,  Either<String,Int>.left("caramba") )
            .mapLeft { (lefts: [String]) in
                let expctedLefts = [ eitherLeftStringInt.left!, "caramba" ]
                XCTAssertEqual(lefts, expctedLefts)
            }
            .map { _ in
                XCTFail("For either containig aby left case should return left case either!")
            }
    }

    func test_zipWith() {

        do {
            let sut: Closure< Either<String,Int>, Either<String,Int>, Either<[String],Z2>> = zip(with: Z2.init)

            let result: Either<[String], Z2> = sut( eitherRightStringInt, .right(52) )

            XCTAssertEqual(
                result,
                .right( Z2(a: eitherRightStringInt.right!, b: 52) )
            )
        }
    }
}

fileprivate struct Z2: Equatable {
    let a: Int; let b: Int
}

/// .left("left")
fileprivate let eitherLeftStringInt: Either<String,Int> = .left("left")

/// .right(42)
fileprivate let eitherRightStringInt: Either<String,Int> = .right(42)

