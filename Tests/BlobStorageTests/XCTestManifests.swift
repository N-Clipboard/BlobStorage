import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(BlobStorageTests.allTests),
        testCase(LRUTests.allTests)
    ]
}
#endif
