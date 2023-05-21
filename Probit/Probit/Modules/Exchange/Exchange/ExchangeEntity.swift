//
//  ExchangeEntity.swift
//  Probit
//
//  Created by Nguyen Quang on 25/08/2022.
//

import UIKit

class ExchangeEntity: InteractorToEntityExchangeProtocol {
    
}

extension Array where Element == ExchangeTicker {
    func sortResult(with text: String) -> Self {
        if text.contains("/") || text.contains(find: "-") {
            return self.sorted { ticker1, ticker2 in
                ticker1.usdtVol > ticker2.usdtVol
            }
        } else {
            var baseContains = self.filter {
                guard let base = $0.baseCurrencyId else { return false }
                return base.lowercased().contains(find: text.lowercased())
            }.sorted { item1, item2 in
                if item1.baseId == text.lowercased() {
                    return true
                } else if item1.baseId.hasPrefix(text.lowercased()) && item2.baseId.hasPrefix(text.lowercased()) {
                    return item1.usdtVol > item2.usdtVol
                } else if !item1.baseId.hasSuffix(text.lowercased()) && !item2.baseId.hasSuffix(text.lowercased()) {
                    return item1.usdtVol > item2.usdtVol
                } else if item1.baseId.hasSuffix(text.lowercased()) && item2.baseId.hasSuffix(text.lowercased()) {
                    return item1.usdtVol > item2.usdtVol
                } else {
                    return false
                }
            }
            
            var ortherItems: [ExchangeTicker] = []
            for item in self {
                guard let id = item.id else { continue }
                if !(baseContains.compactMap({$0.id}).contains(id)) {
                    ortherItems.append(item)
                }
            }
            
            let sortList = ortherItems.sorted { item1, item2 in
                if item1.tokenName == text.lowercased() {
                    return true
                } else if item1.tokenName.hasPrefix(text.lowercased()) && item2.tokenName.hasPrefix(text.lowercased()) {
                    return item1.usdtVol > item2.usdtVol
                } else if !item1.tokenName.hasSuffix(text.lowercased()) && !item2.tokenName.hasSuffix(text.lowercased()) {
                    return item1.usdtVol > item2.usdtVol
                } else if item1.tokenName.hasSuffix(text.lowercased()) && item2.tokenName.hasSuffix(text.lowercased()) {
                    return item1.usdtVol > item2.usdtVol
                } else {
                    return false
                }
            }
            
            baseContains.append(contentsOf: sortList)
            return baseContains
        }
    }
}

class ExchangeTicker: Codable, CustomStringConvertible, Comparable {
    
    var description: String { return displayName ?? "" }
    var iconType: CurrencyIconType = .crypto
    var quoteRate: String = "-"
    var displayName: String?
    var usdtRate: String = "-"
    var changeRate: Double?
    var id: String?
    var baseCurrencyId: String?
    var quoteCurrencyId: String?
    var baseVolume: String?
    var quoteVolume: String?
    var change: String?
    var last: String?
    var makerFeeRate: String?
    var quantityPrecision: Int?
    var costPrecision: Int?
    var priceIncrement: String?
    var minPrice, maxPrice: String?
    var minCost, maxCost: String?
    var minQuantity, maxQuantity: String?
    
    var tickerColor: TickerColor {
        AppConstant.tickerColor
    }
    
    var baseId: String {
        return baseCurrencyId?.lowercased() ?? ""
    }
    
    var tokenName: String {
        return displayName?.lowercased() ?? ""
    }
    
    var usdtVol: Double {
        if let rate = changeRate{
            return rate * quoteVolume.value.asDouble()
        } else {
            return quoteVolume.value.asDouble()
        }
    }
    
    public func searchResult(searchText: String) -> Bool {
        guard let baseCurrencyID = baseCurrencyId,
              let quoteCurrencyID = quoteCurrencyId else {
            return false
        }
        
        let symbol = "\(baseCurrencyID)/\(quoteCurrencyID)"
        if searchText.contains("/") || searchText.contains("-") {
            let param = searchText.replacingOccurrences(of:"-", with: "/")
            if symbol.lowercased() == param.lowercased() {
                return true
            } else {
                if param.hasPrefix("/") && symbol.lowercased().hasSuffix(param.lowercased()){
                     return true
                } else if param.hasSuffix("/") && symbol.lowercased().hasPrefix(param.lowercased()) {
                    return true
                } else {
                    return false
                }
            }
        } else {
            if displayName.value.uppercased().contains(searchText.uppercased()) {
                return true
            } else if baseCurrencyID.uppercased().hasPrefix(searchText.uppercased()) {
                return true
            } else if baseCurrencyID.uppercased().contains(find: searchText.uppercased()){
                return true
            } else {
                return false
            }
        }
    }
    
    public func mapping(withTicker ticker: Ticker) {
        id = id == nil ? ticker.marketId : id
        quoteRate = ticker.last ?? "-"
        baseVolume = ticker.baseVolume
        quoteVolume = ticker.quoteVolume
        change = ticker.change
        last = ticker.last
    }
    
    public func mapping(withMarket market: Market) {
        baseCurrencyId = market.baseCurrencyID
        quoteCurrencyId = market.quoteCurrencyID
        makerFeeRate = market.makerFeeRate
        quantityPrecision = market.quantityPrecision
        costPrecision = market.costPrecision
        priceIncrement = market.priceIncrement
        minPrice = market.minPrice
        maxPrice = market.maxPrice
        minCost = market.minCost
        maxCost = market.maxCost
        minQuantity = market.minQuantity
        maxQuantity = market.maxQuantity
        id = market.id
    }
    
    public func mapping(withCurrencies currencies: [Currency]) {
        displayName = currencies.first(where: { $0.id == baseCurrencyId })?.displayName?.localized
    }
    
    func mapping(withUsdt usdt: Usdt) {
        quoteRate = usdt.rate
    }
    
    func change24Hr() -> Double? {
        guard let last = last?.doubleValue(),
              let change = change?.doubleValue() else { return nil }
        let value = change/(last - change) * 100
        return value
    }
    
    static func < (lhs: ExchangeTicker, rhs: ExchangeTicker) -> Bool {
        switch AppConstant.exchangeSortType {
        case .price:
            return lhs.quoteRate.asDouble() < rhs.quoteRate.asDouble()
        case .pair:
            return lhs.displayName.value < rhs.displayName.value
        case .vol:
            return lhs.usdtVol < rhs.usdtVol
        case .change:
            return lhs.change24Hr() ?? 0 < rhs.change24Hr() ?? 0
        }
    }
    
    static func > (lhs: ExchangeTicker, rhs: ExchangeTicker) -> Bool {
        switch AppConstant.exchangeSortType {
        case .price:
            return lhs.quoteRate.asDouble() > rhs.quoteRate.asDouble()
        case .pair:
            return lhs.displayName.value > rhs.displayName.value
        case .vol:
            return lhs.usdtVol > rhs.usdtVol
        case .change:
            return lhs.change24Hr() ?? 0 > rhs.change24Hr() ?? 0
        }
    }
    
    static func == (lhs: ExchangeTicker, rhs: ExchangeTicker) -> Bool {
        switch AppConstant.exchangeSortType {
        case .price:
            return lhs.quoteRate.asDouble() == rhs.quoteRate.asDouble()
        case .pair:
            return lhs.displayName.value == rhs.displayName.value
        case .vol:
            return lhs.usdtVol == rhs.usdtVol
        case .change:
            return lhs.change24Hr() ?? 0 == rhs.change24Hr() ?? 0
        }
    }
}

enum ExchangeSortType: Codable {
    case pair
    case price
    case change
    case vol
}

enum ExchangeSortCompare: Codable {
    case up
    case down
}

struct MenuBar {
    let name: String?
    let icon: UIImage?
    var isSelected: Bool
    var controller: UIViewController
    init(name: String?,
         icon: UIImage?,
         controller: UIViewController,
         isSelected: Bool = false) {
        self.name = name
        self.icon = icon
        self.isSelected = isSelected
        self.controller = controller
    }
}

extension Array where Element == ExchangeTicker {
    func global(with ids: [String]) -> Self {
        return self.filter { ids.contains( $0.id ?? "")}
    }
}

extension TickerColor {
    var buyColor: UIColor {
        switch self {
        case .option1: return UIColor.Basic.green
        case .option2: return UIColor.Basic.red
        }
    }
    
    var sellColor: UIColor {
        switch self {
        case .option1: return UIColor.Basic.red
        case .option2: return UIColor.Basic.blue
        }
    }
    
    var highlightSellColor: UIColor {
        switch self {
        case .option1: return UIColor(hexString: "C04A3E")
        case .option2: return UIColor.Basic.blue.withAlphaComponent(0.8)
        }
    }
    
    var highlightBuyColor: UIColor {
        switch self {
        case .option1: return UIColor(hexString: "0E9C60")
        case .option2: return UIColor(hexString: "C04A3E")
        }
    }
}

