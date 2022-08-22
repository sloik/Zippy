import XCTest
import Zippy
import AliasWonderland

final class ZipResultTests: XCTestCase {

    func test_zip() {

        _ = zipResult( resultSuccess, .success( 52 ) )
            .map { (zipped: (Int,Int)) -> Void in
                XCTAssertEqual(zipped.0, try!resultSuccess.get() )
                XCTAssertEqual(zipped.1, 52)
            }
            .mapError { _ -> ZipResultError in
                XCTFail("Two success cases shoul zip to a success!")
                return ZipResultError.boom
            }

        _ = zipResult( resultFailure, .success( 52 ) )
            .map { (zipped: (Int,Int)) -> Void in
                XCTFail("Should return failure when zipping with any failure case!")
            }
            .mapError { errors -> ZipResultError in
                XCTAssertEqual(
                    errors,
                    [ZipResultError.ups]
                )

                return ZipResultError.boom
            }

        _ = zipResult( .success( 52 ), resultFailure )
            .map { (zipped: (Int,Int)) -> Void in
                XCTFail("Should return failure when zipping with any failure case!")
            }
            .mapError { errors -> ZipResultError in
                XCTAssertEqual(
                    errors,
                    [ZipResultError.ups]
                )

                return ZipResultError.boom
            }

        _ = zipResult( resultFailure, .failure( .boom ) )
            .map { (zipped: (Int,Int)) -> Void in
                XCTFail("Should return failure when zipping with any failure case!")
            }
            .mapError { errors -> ZipResultError in
                XCTAssertEqual(
                    errors,
                    [ZipResultError.ups, .boom]
                )

                return ZipResultError.boom
            }
    }

    func test_zipWith() {

        do {
            let sut: (<Result<Int,ZipResultError>,Result<Int,ZipResultError>) -> Result<Z2,ZipResultError> = zip(with: Z2.init)

            let result: Result<Z2,ZipResultError> = sut( resultSuccess, Result<Int, ZipResultError>.success( 52 ) )

            XCTAssertEqual( result, Result<Int,ZipResultError>.success( Z2(a: 42, b: 52) ) )
        }

    }

}

fileprivate struct Z2: Equatable {
    let a: Int; let b: Int
}

fileprivate enum ZipResultError: Error, Equatable {
    case ups
    case boom
}

fileprivate let resultSuccess: Result<Int,ZipResultError> = .success( 42 )

fileprivate let resultFailure: Result<Int,ZipResultError> = .failure( ZipResultError.ups )

