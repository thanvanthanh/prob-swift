//
//  ExchangeModel.swift
//  Probit
//
//  Created by Nguyen Quang on 17/10/2022.
//

import Foundation

struct NewOrder: Codable {
    let id: String
    let userId: String
    let marketId: String
    let type: String
    let side: String
    let quantity: String?
    let limitPrice: String?
    let timeInForce: String?
    let filledCost: String?
    let filledQuantity: String?
    let openQuantity: String?
    let cancelledQuantity: String?
    let status: String?
    let time: String?
    let clientOrderId: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case marketId = "market_id"
        case type
        case side
        case quantity
        case limitPrice = "limit_price"
        case timeInForce = "time_in_force"
        case filledCost = "filled_cost"
        case filledQuantity = "filled_quantity"
        case openQuantity = "open_quantity"
        case cancelledQuantity = "cancelled_quantity"
        case status
        case time
        case clientOrderId = "client_order_id"
    }
}

extension Array where Element: OrderBook {
    var isOrderEmpty: Bool {
        return !self.map{$0.isEmpty}.contains(false)
    }
}

class OrderBook: Codable, CustomStringConvertible, Comparable {
    
    let side: String
    let price: String
    var quantity: String

    var total: String? = nil
    var totalMarket: String?
    var description: String { return "" }
    
    init() {
        side = "sell"
        price = ""
        quantity = ""
    }
    
    init(side: String) {
        self.side = side
        price = ""
        quantity = ""
        total = nil
    }
    
    var isEmpty: Bool {
        return price.isEmpty && quantity.isEmpty && total == nil
    }
    
    var orderSide: OrderSide {
        guard let side = OrderSide(rawValue: side) else { return .SELL }
        return side
    }
    
    func mapping(total: String) {
        self.total = total
    }
    
    func mapping(totalMarket: String) {
        self.totalMarket = totalMarket
    }
    
    func mapping(quantity: String) {
        self.quantity = quantity
    }
    
    static func < (lhs: OrderBook, rhs: OrderBook) -> Bool {
        return lhs.price.asDouble() > rhs.price.asDouble()
    }
    
    static func == (lhs: OrderBook, rhs: OrderBook) -> Bool {
        return lhs.price == rhs.price && lhs.orderSide == rhs.orderSide
    }
}

extension Array where Element == OrderBook {
    mutating func modified(with orders: [OrderBook]?){
        guard let data = orders else { return }
        data.forEach {
            if let index = self.firstIndex(of: $0) {
                self[index].mapping(quantity: $0.quantity)
            } else {
                self.append($0)
            }
        }
    }
}

struct CandleData: Codable {
    var data: CandleValue?

    enum CodingKeys: String, CodingKey {
        case data
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        data = try container.decode(CandleValue.self, forKey: .data)
    }
}

struct CandleValueOld: Codable {
    var market_id: String?
    var open: String?
    var close: String?
    var low: String?
    var high: String?
    var base_volume: String?
    var quote_volume: String?
    var start_time: String?
    var end_time: String?

    enum CodingKeys: String, CodingKey {
        case market_id, open, close, low, high, base_volume, quote_volume, start_time, end_time
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        market_id = try container.decode(String.self, forKey: .market_id)
        open = try container.decode(String.self, forKey: .open)
        close = try container.decode(String.self, forKey: .close)
        low = try container.decode(String.self, forKey: .low)
        high = try container.decode(String.self, forKey: .high)
        base_volume = try container.decode(String.self, forKey: .base_volume)
        quote_volume = try container.decode(String.self, forKey: .quote_volume)
        start_time = try container.decode(String.self, forKey: .start_time)
        end_time = try container.decode(String.self, forKey: .end_time)
    }
}

struct CandleValue: Codable {
    var s: String?
    var t: [Int64]?
    var o: [Double]?
    var h: [Double]?
    var l: [Double]?
    var c: [Double]?
    var v: [Double]?
}

struct RealtimeCandle: Codable {
    var marketId: String?
    var data: [String: CandleValueOld]?
    
    var interval: String? { data?.keys.first }
    
    enum CodingKeys: String, CodingKey {
        case marketId = "market_id"
        case data
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        marketId = try container.decode(String.self, forKey: .marketId)
        data = try container.decode([String: CandleValueOld].self, forKey: .data)
    }
}
