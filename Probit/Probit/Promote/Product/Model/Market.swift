
import Foundation

class Market: Codable, Identifiable, Hashable {
    let id, baseCurrencyID, quoteCurrencyID, minPrice: String?
    let maxPrice, priceIncrement, minQuantity, maxQuantity: String?
    let quantityPrecision: Int?
    let minCost, maxCost: String?
    let costPrecision: Int?
    let takerFeeRate, makerFeeRate: String?
    let showInUI, closed: Bool?
    var tickers: Ticker?
    
    enum CodingKeys: String, CodingKey {
        case id
        case baseCurrencyID = "base_currency_id"
        case quoteCurrencyID = "quote_currency_id"
        case minPrice = "min_price"
        case maxPrice = "max_price"
        case priceIncrement = "price_increment"
        case minQuantity = "min_quantity"
        case maxQuantity = "max_quantity"
        case quantityPrecision = "quantity_precision"
        case minCost = "min_cost"
        case maxCost = "max_cost"
        case costPrecision = "cost_precision"
        case takerFeeRate = "taker_fee_rate"
        case makerFeeRate = "maker_fee_rate"
        case showInUI = "show_in_ui"
        case closed
    }
    
    var identifier: String {
            return UUID().uuidString
        }
        
        public func hash(into hasher: inout Hasher) {
            return hasher.combine(identifier)
        }
        
        public static func == (lhs: Market, rhs: Market) -> Bool {
            return lhs.identifier == rhs.identifier
        }
    
    public func mapping(withTicker ticker: [Ticker]) {
        ticker.forEach {
            if id == $0.marketId {
                self.tickers = $0
            }
        }
    }
}
