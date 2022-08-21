import XCTest
import Zippy
import SnapshotTesting

fileprivate let a: Int? = 1
fileprivate let b: Int? = 2
fileprivate let c: Int? = 3
fileprivate let d: Int? = 4
fileprivate let e: Int? = 5
fileprivate let f: Int? = 6
fileprivate let g: Int? = 7
fileprivate let h: Int? = 8
fileprivate let i: Int? = 9
fileprivate let j: Int? = 0

final class ZipTests: XCTestCase {

    override func setUp() {
        super.setUp()

        SnapshotTesting.isRecording = false
    }

    func test_zips() {
        XCTAssertNotNil( zip(a, b, c, d, e, f, g, h, i, j) )
        XCTAssertNotNil( zip(a, b, c, d, e, f, g, h, i) )
        XCTAssertNotNil( zip(a, b, c, d, e, f, g, h) )
        XCTAssertNotNil( zip(a, b, c, d, e, f, g) )
        XCTAssertNotNil( zip(a, b, c, d, e, f) )
        XCTAssertNotNil( zip(a, b, c, d, e) )
        XCTAssertNotNil( zip(a, b, c, d) )
        XCTAssertNotNil( zip(a, b, c) )
        XCTAssertNotNil( zip(a, b) )
    }

    func test_zips_snapshosts() {
        assertSnapshot(matching: zip(a, b, c, d, e, f, g, h, i, j), as: .dump)
        assertSnapshot(matching: zip(a, b, c, d, e, f, g, h, i), as: .dump)
        assertSnapshot(matching: zip(a, b, c, d, e, f, g, h), as: .dump)
        assertSnapshot(matching: zip(a, b, c, d, e, f, g), as: .dump)
        assertSnapshot(matching: zip(a, b, c, d, e, f), as: .dump)
        assertSnapshot(matching: zip(a, b, c, d, e), as: .dump)
        assertSnapshot(matching: zip(a, b, c, d), as: .dump)
        assertSnapshot(matching: zip(a, b, c), as: .dump)
        assertSnapshot(matching: zip(a, b), as: .dump)
    }

    func test_zipWith() {

        struct Z2 { let a: Int; let b: Int }
        XCTAssertNotNil( zipWith( Z2.init )(a,b) )

        struct Z3 { let a: Int; let b: Int; let c: Int }
        XCTAssertNotNil( zipWith( Z3.init )(a,b,c) )

        struct Z4 { let a: Int; let b: Int; let c: Int; let d: Int }
        XCTAssertNotNil( zipWith( Z4.init )(a,b,c,d) )

        struct Z5 { let a: Int; let b: Int; let c: Int; let d: Int; let e: Int }
        XCTAssertNotNil( zipWith( Z5.init )(a,b,c,d,e) )
    }
}
