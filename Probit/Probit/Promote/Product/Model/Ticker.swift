//
//  Ticker.swift
//  Probit
//
//  Created by Nguyen Quang on 06/10/2022.
//

import Foundation

struct Ticker: Codable {
    let baseVolume: String?
    let change: String?
    let high: String?
    let last: String?
    let low: String?
    let quoteVolume: String?
    let time: String?
    let marketId: String?
    
    
    enum CodingKeys: String, CodingKey {
        case baseVolume = "base_volume"
        case change
        case high
        case last
        case low
        case quoteVolume = "quote_volume"
        case time
        case marketId = "market_id"
    }
    
    func change24Hr() -> Double? {
        guard let last = last?.doubleValue(),
              let change = change?.doubleValue() else { return nil }
        let value = change/(last - change) * 100
        return value
    }
}
