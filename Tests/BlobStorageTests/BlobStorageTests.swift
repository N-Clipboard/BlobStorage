import XCTest
@testable import BlobStorage

final class BlobStorageTests: XCTestCase {
    var bs = try! BlobStorage(bundleName: "poor-branson.info.test")
    
    override func setUp() {
        
    }

    func testWrite() throws {
        guard let data = "a text".data(using: .utf8) else { XCTFail();return }
        let item = BlobContent(name: "first.txt")
        try bs?.save(item: item, data: data)
    }
    
    func testFetch() throws {
        guard let item = bs?.managed.first else { return }
        guard let data = bs?.fetch(item: item) else { XCTFail(); return }
        let content = String(data: data, encoding: .utf8)
        XCTAssertNotNil(content)
        XCTAssertTrue(content! == "a text")
    }
    
    func testRemove() throws {
        guard let first = bs?.managed.first else { return }
        try bs?.remove(item: first)
        XCTAssertFalse(FileManager.default.fileExists(atPath: bs!.workSpace.appendingPathComponent(first.filename).path))
        XCTAssertFalse(bs!.managed.contains(first))
    }

    static var allTests = [
        ("testWrite", testWrite),
        ("testFetch", testFetch),
        ("testRemove", testRemove)
    ]
}
