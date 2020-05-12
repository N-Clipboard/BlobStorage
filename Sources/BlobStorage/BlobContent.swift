//
//  File.swift
//  
//
//  Created by bytedance on 2020/5/9.
//

import Foundation

public struct BlobContent: Codable {
    var createdAt: Date = Date()
    var filename: String
    internal var id: Int?

    public init(name: String) {
        self.filename = name
    }
}

extension BlobContent: Equatable {
    public static func == (left: BlobContent, right: BlobContent) -> Bool {
        left.filename == right.filename
    }
}
