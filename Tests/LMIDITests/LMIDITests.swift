import XCTest
@testable import LMIDI

final class LMIDITests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(LMIDI().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
