import XCTest
import AliasWonderland
import Zippy
import SnapshotTesting

final class ZipAsyncTests: XCTestCase {

    override func setUp() {
        super.setUp()

        SnapshotTesting.isRecording = false
    }

    func test_zips_snapshosts() async -> Void {

        do {
            let result = await asyncZip(
                await asyncString("a"),
                await asyncString("b")
            )

            assertSnapshot(
                matching: result,
                as: .dump
            )
        }

        do {
            let result = await asyncZip(
                await asyncString("a"),
                await asyncString("b"),
                await asyncString("c")
            )

            assertSnapshot(
                matching: result,
                as: .dump
            )
        }

        do {
            let result = await asyncZip(
                await asyncString("a"),
                await asyncString("b"),
                await asyncString("c"),
                await asyncString("d")
            )

            assertSnapshot(
                matching: result,
                as: .dump
            )
        }
    }

    func test_zipWith() async {

        do {
            struct Z2: Equatable { let a: String; let b: String }

            let result: Z2 = await asyncZip(
                await async(string: "lorem"),
                await async(string: "ipsum"),
                with: Z2.init
            )

            XCTAssertEqual(
                result,
                Z2(a: "lorem", b: "ipsum")
            )
        }

        do {
            struct Z3: Equatable { let a: String; let b: String; let c: String }

            let result: Z3 = await asyncZip(
                await async(string: "lorem"),
                await async(string: "ipsum"),
                await async(string: "sit"),
                with: Z3.init
            )

            XCTAssertEqual(
                result,
                Z3(a: "lorem", b: "ipsum", c: "sit")
            )
        }

        do {
            struct Z4: Equatable { let a: String; let b: String; let c: String; let d: String }

            let startTime = Date()

            let result = await asyncZip(
                await async(string: "lorem", seconds: 2),
                await async(string: "ipsum", seconds: 2),
                await async(string: "sit", seconds: 2),
                await async(string: "dolor", seconds: 2),
                with: Z4.init
            )

            let endTime = Date()

            let testRunTime = endTime.timeIntervalSince(startTime)

            XCTAssertEqual(result, Z4(a: "lorem", b: "ipsum", c: "sit", d: "dolor"))
            XCTAssert(
                testRunTime < 2.0 * 1.11,
                "Zipping should run concurently! Test runn took: \(testRunTime)"
            )
        }
    }
}

fileprivate func asyncString(_ s: String) async -> String {

    await async(string: s, seconds: 0)
}

fileprivate func async(string s: String, seconds: Int = 1) async ->  String {
    let nanosecondsInsecond = 1_000_000_000
    let waitTime = UInt64(nanosecondsInsecond * seconds)

    try! await Task.sleep(nanoseconds:  waitTime)

    return s
}
