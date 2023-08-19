//
//  Encodable+.swift
//  MVVM-Framework-iOS
//
//  Created by KYUBO A. SHIM on 2023/08/19.
//

import Foundation

extension Encodable {
    
    public func asParameter() throws -> [String: Any] {
        let data = try JSONEncoder().encode(self)
        guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                as? [String: Any] else {
            throw NSError()
        }
        return dictionary
    }
}
