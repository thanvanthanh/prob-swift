
import Foundation


struct StakeCurrency: Codable {
    var currencyId: String?
        var stakeable, unstakeable, autoStake: Bool?
        var autoStakeAmount: String?
        var period: [Int]?
        var totalAmount: String?
        var capAmount, minAmount, maxAmount: String?
        var config: Config?

        enum CodingKeys: String, CodingKey {
            case currencyId = "currency_id"
            case stakeable, unstakeable
            case autoStake = "auto_stake"
            case autoStakeAmount = "auto_stake_amount"
            case period
            case totalAmount = "total_amount"
            case capAmount = "cap_amount"
            case minAmount = "min_amount"
            case maxAmount = "max_amount"
            case config
        }
}

// MARK: - Config
struct Config: Codable {
    var global: Global?
    var overridePerPeriod: [String: OverridePerPeriod]?

    enum CodingKeys: String, CodingKey {
        case global
        case overridePerPeriod = "override_per_period"
    }
}

// MARK: - Global
struct Global: Codable {
    var totalAmount: String?
    var capAmount, minAmount, maxAmount: String?
    enum CodingKeys: String, CodingKey {
        case totalAmount = "total_amount"
        case capAmount = "cap_amount"
        case minAmount = "min_amount"
        case maxAmount = "max_amount"
    }
}

// MARK: - OverridePerPeriod
struct OverridePerPeriod: Codable {
    
}
