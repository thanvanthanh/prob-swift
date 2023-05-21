
import Foundation

// MARK: - Currency
struct Currency: Codable {
    let id: String
    let displayName: LocalizableModel?
    let showInUI: Bool?
    let platform: [Platform]?
    let stakeable, unstakeable, autoStake: Bool?
    let autoStakeAmount: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case displayName = "display_name"
        case showInUI = "show_in_ui"
        case platform
        case stakeable, unstakeable
        case autoStake = "auto_stake"
        case autoStakeAmount = "auto_stake_amount"
    }
}

typealias LocalizableModel = [String: String]
extension LocalizableModel {
    var localized: String {
        return self[AppConstant.locale] ?? ""
    }
}

struct Platform: Codable {
    let id: String?
    let priority: Int?
    let deposit, withdrawal: Bool?
    let currencyID: String?
    let precision, minConfirmationCount: Int?
    let requireDestinationTag, allowWithdrawalDestinationTag: Bool?
    let displayName: PlatformCurrencyDisplayName?
    let minDepositAmount, minWithdrawalAmount: String?
    let withdrawalFee: [WithdrawalFee]?
    let depositFee: DepositFee?
    let suspendedReason: SuspendedReason?
    let depositSuspended, withdrawalSuspended: Bool?
    let platformCurrencyDisplayName: PlatformCurrencyDisplayName
    
    enum CodingKeys: String, CodingKey {
        case id, priority, deposit, withdrawal
        case currencyID = "currency_id"
        case precision
        case minConfirmationCount = "min_confirmation_count"
        case requireDestinationTag = "require_destination_tag"
        case allowWithdrawalDestinationTag = "allow_withdrawal_destination_tag"
        case displayName = "display_name"
        case minDepositAmount = "min_deposit_amount"
        case minWithdrawalAmount = "min_withdrawal_amount"
        case withdrawalFee = "withdrawal_fee"
        case depositFee = "deposit_fee"
        case suspendedReason = "suspended_reason"
        case depositSuspended = "deposit_suspended"
        case withdrawalSuspended = "withdrawal_suspended"
        case platformCurrencyDisplayName = "platform_currency_display_name"
    }
}

struct DepositFee: Codable {
}

struct PlatformCurrencyDisplayName: Codable {
    
    let name: LocalizableModel?
    let destinationTag: LocalizableModel?
}

enum SuspendedReason: String, Codable {
    case empty = ""
    case paused = "paused"
    case tokenSwap = "token_swap"
    case notSupported = "not_supported"
    case withdrawal_paused = "withdrawal_paused"
    case wallet_maintenance = "wallet_maintenance"
    case deposit_paused = "deposit_paused"
    case not_opened_yet = "not_opened_yet"
}

struct WithdrawalFee: Codable {
    let currencyID: String?
    var amount: String?
    let priority: Int?
    
    enum CodingKeys: String, CodingKey {
        case currencyID = "currency_id"
        case amount
        case priority
        
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        currencyID = try container.decode(String.self, forKey: .currencyID)
        do {
            amount = try container.decode(String.self, forKey: .amount)
        } catch DecodingError.typeMismatch {
            amount = try String(container.decode(Double.self, forKey: .amount))
        }
        
        do {
            priority = try container.decode(Int.self, forKey: .priority)
        } catch DecodingError.typeMismatch {
            priority = try Int(container.decode(String.self, forKey: .amount))
        }
    }
}

