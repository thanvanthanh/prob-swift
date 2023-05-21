
import Foundation

protocol CurrencyType {
    var id: String? { get set}
    var iconType: CurrencyIconType { get set}
    static func generator(_ id: String, _ type: CurrencyIconType) -> CurrencyType
    init()
}

extension CurrencyType {
    static func generator(_ id: String, _ type: CurrencyIconType) -> CurrencyType {
        var obj = self.init()
        obj.id = id
        obj.iconType = type
        return obj
    }
}

class WalletCurrency: Codable, CurrencyType {
    var iconType: CurrencyIconType = .crypto
    var id: String?
    var displayName: String?
    var total: Double = 0
    var available: Double = 0
    var usdtRate: Double?
    var markets: [Market] = []
    var stakeEvent: StakeEventModel?
    var currency: Currency?
    var userBalace: UserBalance?
    var fixedRate: Double?
    var platform: [Platform] = []
    var usdtValue: Double = 0
    
    required init() { }
    
    public func mapping(_ with: ExchangeRate) {
        if let rate = with.data.usdt.first(where: { $0.currencyID == id }) {
            usdtRate = rate.rate.doubleValue()
        }
    }
    
    public func mapping(_ with: UserBalance) {
        self.userBalace = with
        if let totalValue = with.total.doubleValue() {
            total = totalValue
        }
        if let availableValue = with.available.doubleValue() {
            available = availableValue
        }
    }
    
    public func mapping(_ with: Currency) {
        self.currency = with
        self.id = with.id
        self.displayName = with.displayName?.localized
        self.platform = with.platform ?? []
    }
    
    public func mapping(_ with: StakeEventModel) {
        self.stakeEvent = with
    }
    
    public func mapping(_ with: [Market]) {
        self.markets = with.filter({
            $0.baseCurrencyID == id
        })
    }
}
