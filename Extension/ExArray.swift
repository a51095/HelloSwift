//
//  ExArray.swift
//  HelloSwift
//
//  Created by well on 2023/3/23.
//

import Foundation

extension Array where Element: Codable {
    /// 深拷贝
    var deepCopy: Self {
        do {
            let jsonData = try JSONEncoder().encode(self)
            return try JSONDecoder().decode([Element].self, from: jsonData)
        } catch {
            fatalError("Decode failed. \(error)")
        }
    }
}

