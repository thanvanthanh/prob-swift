
import Foundation

enum WithdrawVerificationConfiguration {
    case twoFactorAuthentication(message: String)
    case tfaStartNewV1(purpose: PURPOSE)
    case tfaStartNew(purpose: PURPOSE, authnDetails: [String: String]?)
    case validateCode(code: String, sessionId: String, type: AuthenticationMethod)
    case sendTFAEmail(sessionId: String)
    case sendTFASms(sessionId: String)
    case callTFAPhone(sessionId: String)
}

extension WithdrawVerificationConfiguration: Configuration {
    var baseURL: String {
        switch self {
        case .tfaStartNew:
            return Constant.Server.baseURL
        default:
            return Constant.Server.baseAPIURL
        }
    }
    
    var path: String {
        switch self {
        case .twoFactorAuthentication, .tfaStartNewV1:
            return "api/security/v1/tfa_start_new"
        case .validateCode:
            return "api/security/v1/tfa_validate_new"
        case .sendTFAEmail:
            return "api/security/v1/tfa_send_email"
        case .sendTFASms:
            return "api/security/v1/tfa_send_sms"
        case .callTFAPhone:
            return "api/security/v1/tfa_send_phone"
        case .tfaStartNew:
            return "api/accounts/v2/tfa_start_new"
        }
    }
    
    var method: HTTPMethod {
        return .post
    }
    
    var task: Task {
        switch self {
            case .twoFactorAuthentication(let message):
                let param: [String: Any] = ["purpose": "withdrawal_request",
                                            "authnDetails": ["type": "json", "message": message]]
                return .requestParameters(parameters: param)
        case .validateCode(let code, let sessionId, let type):
            let tfaType: String = type.rawValue
            let param: [String: Any] = [tfaType: ["code": code],
                                        "sessId": sessionId]
            return .requestParameters(parameters: param)
        case .sendTFAEmail(let sessionId):
            let param: [String: Any] = ["sessId": sessionId]
            return .requestParameters(parameters: param)
        case .sendTFASms(let sessionId):
            let param: [String: Any] = ["sessId": sessionId]
            return .requestParameters(parameters: param)
        case .callTFAPhone(let sessionId):
            let param: [String: Any] = ["sessId": sessionId]
            return .requestParameters(parameters: param)
        case .tfaStartNew(let purpose,let authnDetails):
            var param: [String: Any] = ["purpose": purpose.rawValue]
            param["authnDetails"] = authnDetails ?? ""
            return .requestParameters(parameters: param)
        case .tfaStartNewV1(let purpose):
            let param: [String: Any] = ["purpose": purpose.rawValue]
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
