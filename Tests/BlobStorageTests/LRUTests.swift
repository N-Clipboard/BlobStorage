//
//  File.swift
//  
//
//  Created by bytedance on 2020/5/11.
//

import XCTest
@testable import BlobStorage

final class LRUTests: XCTestCase {
    var lru = LRU<String, Int>(capacity: 3)
    
    override func setUp() {
        lru.put(key: 12, item: "lalala")
        lru.put(key: 2, item: "fafafa")
        lru.put(key: 3, item: "qqqqq")
    }
    
    override func tearDown() {
        lru.clean()
    }

    func testPut() {
        XCTAssert(lru.priority.count == 3)
        XCTAssert(lru.priority.first == 3)
    }
    
    func testOverFlow() {
        lru.put(key: 4, item: "adsfasdfqwe")
        XCTAssert(lru.priority.count == 3)
        XCTAssert(lru.priority.first == 4)
        XCTAssert(lru.priority.last == 2)
    }

    func testGetExisted() {
        let _ = lru.get(key: 12)
        XCTAssert(lru.priority.first == 12)
    }
    
    func testDelete() {
        lru.delete(key: 12)
        XCTAssertFalse(lru.priority.contains(12))
        XCTAssertFalse(lru.bucket.keys.contains(12))
    }
    
    static var allTests = [
        ("testPut", testPut)
    ]
}
