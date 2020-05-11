//
//  File.swift
//  
//
//  Created by bytedance on 2020/5/11.
//

import Foundation

struct LRU<T: Equatable, K: Hashable> {
    var capacity: Int
    internal var bucket: [K: T] = [:]
    internal var priority: [K] = []
    
    init(capacity: Int = 0) {
        self.capacity = capacity
    }
    
    mutating func put(key: K, item: T) {
        if priority.count >= capacity {
            let bucketIndex = priority.popLast()!
            bucket.removeValue(forKey: bucketIndex)
        }
        // remove existed key
        if let index = priority.firstIndex(of: key) {
            priority.remove(at: index)
        }
        
        priority.insert(key, at: 0)
        bucket[key] = item
    }
    
    mutating func get(key: K) -> T? {
        guard let value = bucket[key] else { return nil }
        
        let index = priority.firstIndex(of: key)!
        priority.remove(at: index)
        priority.insert(key, at: 0)
        
        return value
    }
    
    mutating func delete(key: K) {
        bucket.removeValue(forKey: key)
        guard let index = priority.firstIndex(of: key) else { return }
        priority.remove(at: index)
    }
    
    mutating func clean() {
        priority = []
        bucket = [:]
    }
}
