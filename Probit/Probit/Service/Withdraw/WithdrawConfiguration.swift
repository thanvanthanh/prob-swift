
import Foundation

enum WithdrawServiceConfiguration {
    case withdraw(currency_id: String,
                  platform_id: String,
                  fee_currency_id: String,
                  address: String,
                  destination_tag: String,
                  amount: String,
                  tfa_session_id: String)
    
    case validateWalletAddress(currency_id: String,
                               platform_id: String,
                               address: String,
                               destinationTag: String)
}

extension WithdrawServiceConfiguration: Configuration {
    var baseURL: String {
        switch self {
        default:
            return Constant.Server.baseAPIURL
        }
    }
    
    var path: String {
        switch self {
        case .withdraw:
            return "api/exchange/v1/withdrawal"
        case .validateWalletAddress:
            return "api/exchange/v1/check_withdrawal_address"
        }
    }
    
    var method: HTTPMethod {
        return .post
    }
    
    var task: Task {
        switch self {
            case .withdraw(let currencyId, let platformId, let feeCurrencyId, let address, let tag, let amount, let tfaSessionId):
                var param: [String: Any] = ["currency_id": currencyId,
                                        "platform_id": platformId,
                                        "fee_currency_id": feeCurrencyId,
                                        "address": address,
                                        "destination_tag": tag,
                                        "amount": amount]
                if !tfaSessionId.isEmpty {
                    param["tfa_session_id"] = tfaSessionId
                }
                return .requestParameters(parameters: param)
        case .validateWalletAddress(let currencyId, let platformId,let address, let tag):
            let param: [String: Any] = ["currency_id": currencyId,
                                        "platform_id": platformId,
                                        "address": address,
                                        "destination_tag": tag]
            return .requestParameters(parameters: param)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        default:
            return [:]
        }
    }
    
    var data: Data? {
        return nil
    }
}
