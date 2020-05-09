import XCTest
@testable import BlobStorage

final class BlobStorageTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(BlobStorage().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
