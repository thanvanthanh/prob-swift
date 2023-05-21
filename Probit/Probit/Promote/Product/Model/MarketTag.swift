//
//  MarketTag.swift
//  Probit
//
//  Created by Sotatek on 11/01/2023.
//

import Foundation

struct MarketTag: Codable {
    var id: String
    var type: String
    var applyTo: [String]
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case type = "type"
        case applyTo = "apply_to"
    }
}

extension Array where Element == MarketTag {
    func getDefiApplies(withTag tag: String) -> [String] {
        guard let defi = self.filter({ $0.id == tag }).first else { return [] }
        return defi.applyTo
    }
}

