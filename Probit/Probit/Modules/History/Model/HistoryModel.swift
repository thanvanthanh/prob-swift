//
//  HistoryModel.swift
//  Probit
//
//  Created by Đào Mỹ Đông on 10/10/2565 BE.
//

import Foundation
import UIKit

struct OrderDataEntry: Codable {
    var id, userID, marketID, type: String?
    var side, quantity, limitPrice, timeInForce: String?
    var filledCost, filledQuantity, openQuantity, cancelledQuantity: String?
    var status, time, clientOrderID: String?
    var cost: String?
    
    var price: Double {
        return limitPrice?.asDouble() ?? 0
    }
    
    var quantityValue: Double {
        return quantity?.asDouble() ?? 0
    }
    
    var quoteValue: Double {
        guard let limitPriceDouble = limitPrice?.asDouble() else { return 0 }
        return limitPriceDouble * quantityValue
    }
    
    var sideOrder: OrderSide {
        guard let _side = side else { return .BUY }
        if _side.lowercased() == "sell" {
            return .SELL
        } else {
            return .BUY
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case marketID = "market_id"
        case type, side, quantity
        case limitPrice = "limit_price"
        case timeInForce = "time_in_force"
        case filledCost = "filled_cost"
        case cost
        case filledQuantity = "filled_quantity"
        case openQuantity = "open_quantity"
        case cancelledQuantity = "cancelled_quantity"
        case status, time
        case clientOrderID = "client_order_id"
    }
}


struct OrderDataMiniModel: Codable {
    var marketID,
        orderID,
        limitOpenQuantity: String?

    enum CodingKeys: String, CodingKey {
        case marketID = "market_id"
        case orderID = "order_id"
        case limitOpenQuantity = "limit_open_quantity"
    }
}

enum OrderStatus: String {
    case OPEN = "open"
    case CANCELLED = "cancelled"
    case FILLED = "filled"

}

enum OrderType: String {
    case LIMIT = "limit"
    case MARKET = "market"
}

enum TimeInForce: String {
    case GTC = "gtc"
    case IOC = "ioc"
    case FOK = "fok"
    case GTCPO = "gtcpo"
}

enum OrderSide: String {
    case BUY = "buy"
    case SELL = "sell"
    
    var title: String {
        switch self {
        case .BUY:
            return "Buy"
        case .SELL:
            return "Sell"
        }
    }
    
    func getColorBG(_ status: OrderStatus?) -> UIColor {
        switch status {
        case .CANCELLED:
            return UIColor(hexString: "#7B7B7B").withAlphaComponent(0.1)
        default:
            if self == .BUY {
                return AppConstant.tickerColor.buyColor.withAlphaComponent(0.1)
            } else {
                return AppConstant.tickerColor.sellColor.withAlphaComponent(0.1)
            }
        }
    }
    
    func getColorMain(_ status: OrderStatus?) -> UIColor {
        switch status {
        case .CANCELLED:
            return UIColor(hexString: "#7B7B7B")
        default:
            if self == .BUY {
                return AppConstant.tickerColor.buyColor
            } else {
                return AppConstant.tickerColor.sellColor
            }
        }
    }
}

class OrderDataModel {
    var id, userID, marketID: String?
    var quantity, limitPrice: String?
    var filledCost, filledQuantity: String?
    var timeInForce: TimeInForce?
    var openQuantity, cancelledQuantity: String?
    var status: OrderStatus?
    var side: OrderSide?
    var type: OrderType?
    var time: Date
    var clientOrderID: String?
    init(entry: OrderDataEntry) {
        self.id = entry.id
        self.userID = entry.userID
        self.marketID = entry.marketID
        self.quantity = entry.quantity
        self.limitPrice = entry.limitPrice
        self.timeInForce = TimeInForce(rawValue: entry.timeInForce ?? "")
        self.filledCost = entry.filledCost
        self.filledQuantity = entry.filledQuantity
        self.openQuantity = entry.openQuantity
        self.cancelledQuantity = entry.cancelledQuantity
        self.status = OrderStatus(rawValue: entry.status ?? "")
        self.side = OrderSide(rawValue: entry.side ?? "")
        self.type = OrderType(rawValue: entry.type ?? "")
        self.time = entry.time?.toDate() ?? Date()
        self.clientOrderID = entry.clientOrderID
    }
}

// MARK: - Datum
struct TradeHistoryEntry: Codable {
    var id, orderID, side, feeAmount: String?
    var feeCurrencyID, status, price, quantity: String?
    var cost, time, marketID: String?
    enum CodingKeys: String, CodingKey {
        case id
        case orderID = "order_id"
        case side
        case feeAmount = "fee_amount"
        case feeCurrencyID = "fee_currency_id"
        case status, price, quantity, cost, time
        case marketID = "market_id"
    }
}

class TradeHistoryModel {
    var id, orderID, feeAmount: String?
    var feeCurrencyID, status, price, quantity: String?
    var cost, marketID: String?
    var time: Date
    var side: OrderSide?
    init(entry: TradeHistoryEntry) {
        self.id = entry.id
        self.orderID = entry.orderID
        self.side = OrderSide(rawValue: entry.side ?? "")
        self.feeAmount = entry.feeAmount
        self.feeCurrencyID = entry.feeCurrencyID
        self.status = entry.status
        self.price = entry.price
        self.quantity = entry.quantity
        self.cost = entry.cost
        self.time = entry.time?.toDate() ?? Date()
        self.marketID = entry.marketID
    }
}

enum DateRateType: CaseIterable {
    case ONE_DAY
    case ONE_WEEK
    case ONE_MONTH
    case THREE_MONTH
    
    var title: String {
        switch self {
        case .ONE_DAY:
            return "filter_1day".Localizable()
        case .ONE_WEEK:
            return "filter_7days".Localizable()
        case .ONE_MONTH:
            return "filter_1month".Localizable()
        case .THREE_MONTH:
            return "filter_3months".Localizable()
        }
    }
    
    func getStartDate() -> Date{
        switch self {
        case .ONE_DAY:
            return Date().startOfDay
        case .ONE_WEEK:
            return Date().nextDate(number: -6).startOfDay
        case .ONE_MONTH:
            return Date().previousMonth.startOfDay
        case .THREE_MONTH:
            return Date().addMonth(number: -3).startOfDay
        }
    }
    
    func getEndDate() -> Date {
        return Date().endOfDay
    }
}

struct SearchFilterModel {
    var startTime: Date
    var endTime: Date
    var limit: Int
    var baseCurrency: Currency?
    var quoteCurrency: Currency?
    var dateRate: [DateRateType]
    var dateRateSelected: DateRateType?
    
    init(limit: Int,
         baseCurrency: Currency? = nil,
         quoteCurrency: Currency? = nil,
         dateRate: [DateRateType] = DateRateType.allCases,
         dateRateSelected: DateRateType? = nil) {
        self.limit = limit
        self.baseCurrency = baseCurrency
        self.quoteCurrency = quoteCurrency
        self.dateRate = dateRate
        self.dateRateSelected = dateRateSelected
        if let date = dateRateSelected {
            self.startTime = date.getStartDate()
            self.endTime = date.getEndDate()
        } else {
            self.startTime = Date().previousMonth.startOfDay
            self.endTime = Date().endOfDay
        }
    }
    
    mutating func updateDateRateSelected(dateType: DateRateType?) {
        self.dateRateSelected = dateType
        if let dateType = dateType {
            self.startTime = dateType.getStartDate()
            self.endTime = dateType.getEndDate()
        }
    }
}
