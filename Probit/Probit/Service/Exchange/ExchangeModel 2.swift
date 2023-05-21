//
//  ExchangeModel.swift
//  Probit
//
//  Created by Nguyen Quang on 17/10/2022.
//

import Foundation

class OrderBook: Codable, CustomStringConvertible, Comparable {
    let side: String
    let price: String
    var quantity: String
    
    var total: String? = nil
    var description: String { return "" }
    
    var orderSide: OrderSide {
        guard let side = OrderSide(rawValue: side) else { return .SELL }
        return side
    }
    
    func mapping(total: String) {
        self.total = total
    }
    
    func mapping(quantity: String) {
        self.quantity = quantity
    }
    
    static func < (lhs: OrderBook, rhs: OrderBook) -> Bool {
        return lhs.price.asDouble() > rhs.price.asDouble()
    }
    
    static func == (lhs: OrderBook, rhs: OrderBook) -> Bool {
        return true
    }
}
