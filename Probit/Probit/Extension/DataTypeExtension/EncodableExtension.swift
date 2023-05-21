//
//  EncodableExtension.swift
//  Probit
//
//  Created by Beacon on 31/08/2022.
//

import Foundation

extension Encodable {
    var dictionary: [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
    }
    
    func toJSONData() -> Data? {
        return try? JSONEncoder().encode(self)
    }
}
