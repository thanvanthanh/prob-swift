//
//  KycSelectCountryEntity.swift
//  Probit
//
//  Created by Bradley Hoang on 24/11/2022.
//

import Foundation

struct Alpha23Country: Codable {
    let alpha2: String
    let alpha3: String
    
    enum CodingKeys: String, CodingKey {
        case alpha2 = "alpha-2"
        case alpha3 = "alpha-3"
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.alpha2, forKey: .alpha2)
        try container.encode(self.alpha3, forKey: .alpha3)
    }
}
