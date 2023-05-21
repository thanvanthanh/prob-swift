
import Foundation
import UIKit

struct ExchangeRate: Codable {
    let channel: String
    let reset: Bool
    let data: Rate
}

// MARK: - Rate
struct Rate: Codable {
    let usdt: [Usdt]
    enum CodingKeys: String, CodingKey {
        case usdt = "USDT"
    }
}

// MARK: - Usdt
struct Usdt: Codable {
    let currencyID, rate: String
    enum CodingKeys: String, CodingKey {
        case currencyID = "currency_id"
        case rate
    }
}

struct MarketData: Codable {
    let marketId: String
    let ticker: Ticker?
    let recentTrades: [RecentTrade]?
    let orderBooks0: [OrderBook]?
    let orderBooks1: [OrderBook]?
    let orderBooks2: [OrderBook]?
    let orderBooks3: [OrderBook]?
    let orderBooks4: [OrderBook]?

    enum CodingKeys: String, CodingKey {
        case marketId = "market_id"
        case ticker
        case recentTrades = "recent_trades"
        case orderBooks0 = "order_books_l0"
        case orderBooks1 = "order_books_l1"
        case orderBooks2 = "order_books_l2"
        case orderBooks3 = "order_books_l3"
        case orderBooks4 = "order_books_l4"
    }
}

struct RecentTrade: Codable {
    let id: String
    let price: String
    let quantity: String
    let side: String
    let time: String
    let tickDirection: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case price
        case quantity
        case side
        case time
        case tickDirection = "tick_direction"
    }
    var date: Date? {
        time.toDate("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", timeZone: TimeZone(secondsFromGMT: 0))
    }
    
    var orderSide: OrderSide {
        guard let side = OrderSide(rawValue: side) else { return .SELL }
        return side
    }
    
    var orderTickDirection: TickDirection {
        guard let side = TickDirection(rawValue: tickDirection) else { return .DOWN }
        return side
    }
}

enum TickDirection: String {
    case UP = "up"
    case DOWN = "down"
    case ZEROUP = "zeroup"
    case ZERODOWN = "zerodown"
    case ZERO = "zero"
    var color: UIColor {
        let tickerColor = AppConstant.tickerColor
        switch self {
        case .DOWN, .ZERODOWN:
            return  tickerColor.sellColor
        case .UP, .ZEROUP, .ZERO:
            return  tickerColor.buyColor
        }
    }
    
    var icon: UIImage? {
        switch self {
        case .DOWN, .ZERODOWN:
            return UIImage(named: "ico_sell")
        case .UP, .ZEROUP, .ZERO:
            return UIImage(named: "ico_buy")
        }
    }
}

    
