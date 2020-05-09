import XCTest

import BlobStorageTests

var tests = [XCTestCaseEntry]()
tests += BlobStorageTests.allTests()
XCTMain(tests)
