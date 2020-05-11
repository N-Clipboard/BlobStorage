//
//  File.swift
//  
//
//  Created by bytedance on 2020/5/9.
//

import Foundation

struct BlobContent: Codable {
    var createdAt: Date = Date()
    var filename: String
    internal var id: Int?

    init(name: String) {
        self.filename = name
    }
}

extension BlobContent: Equatable {
    static func == (left: BlobContent, right: BlobContent) -> Bool {
        left.filename == right.filename
    }
}
