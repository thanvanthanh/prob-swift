//
//  MarketTag.swift
//  Probit
//
//  Created by Sotatek on 11/01/2023.
//

import Foundation

struct MarketTagSuggestion: Codable {
    var id: String?
    var tags: [String]?
    var service: ServiceArea?
    var displayName: DisplayName?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case tags = "tags"
        case service = "service_area"
        case displayName = "display_name"
    }
    
    struct DisplayName: Codable {
        var enUs: String?
        var koKr: String?
        enum CodingKeys: String, CodingKey {
            case enUs = "en-us"
            case koKr = "ko-kr"
        }
    }
    
    enum ServiceArea: String, Codable {
        case global
        case korea
    }
}

extension Array where Element == MarketTagSuggestion {
    var defi: MarketTagSuggestion? {
        return self.filter { $0.displayName?.enUs?.lowercased() == "defi"}.first
    }
}
