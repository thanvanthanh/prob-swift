
import Foundation

struct GetUserBalanceResponse: Codable {
    let data: [UserBalance]
}

struct UserBalance: Codable, Equatable {
    var currencyID, total, available: String
    
    var totalValue: Double {
        guard let value = total.doubleValue() else { return 0.0 }
        return value
    }
    
    var availableValue: Double {
        guard let value = available.doubleValue() else { return 0.0 }
        return value
    }

    enum CodingKeys: String, CodingKey {
        case currencyID = "currency_id"
        case total, available
    }
    
    public static func == (lhs: UserBalance, rhs: UserBalance) -> Bool {
        return lhs.currencyID == rhs.currencyID && lhs.total == rhs.total && lhs.available == rhs.available
    }
}
