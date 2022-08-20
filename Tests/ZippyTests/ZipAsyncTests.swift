import XCTest
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
}

fileprivate func asyncString(_ s: String) async -> String {

    let wait = 1...3
    let nanosecondsInsecond = 1_000_000_000
    let waitTime = UInt64(nanosecondsInsecond * wait.randomElement()!)

    try! await Task.sleep(nanoseconds:  waitTime / 1_000)

    return s
}
