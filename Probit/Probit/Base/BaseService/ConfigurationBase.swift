//
//  ConfigurationBase.swift
//  Probit
//
//  Created by Beacon on 31/08/2022.
//

import Foundation
import Alamofire

enum HTTPMethod: String {
    case get    = "GET"
    case post   = "POST"
    case put    = "PUT"
    case delete = "DELETE"
}


enum Task {
    case requestPlain
    case requestParameters(parameters: [String: Any], encoding: ParameterEncoding = URLEncoding.default)
}


protocol Configuration {
    var baseURL: String {get}
    var path: String {get}
    var method: HTTPMethod {get}
    var task: Task {get}
    var headers: [String: String]? {get}
    var data: Data? { get }
}

struct ServiceError: Error {
    let issueCode: IssueCode
    var message: String {
        return issueCode.message
    }
    static var urlError: ServiceError {
        return ServiceError(issueCode: IssueCode.CUSTOM_MES(message: "URL is wrong"))
    }
    static var notFoundData: ServiceError {
        return ServiceError(issueCode: IssueCode.CUSTOM_MES(message: "Not found Data"))
    }
    
    static var parseError: ServiceError {
        return ServiceError(issueCode: IssueCode.CUSTOM_MES(message: "Parse Model Error"))
    }
    
    static var jsonError: ServiceError {
        return ServiceError(issueCode: IssueCode.CUSTOM_MES(message: "Response is not JSON"))
    }
    
    static var somethinkWrong: ServiceError {
        return ServiceError(issueCode: IssueCode.CUSTOM_MES(message: "error_message_something_went_wrong".Localizable()))
    }
}

// MARK: - Issue
final class Issue: Codable {
    let error: String?
    let errorFields: String?
    let errorDescription: String?
    let errorCode: String?
    let details: [String:String]?
    enum CodingKeys: String, CodingKey {
        case error
        case errorFields = "error_fields"
        case errorDescription = "error_description"
        case errorCode
        case details
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        error = (try? container.decode(String.self, forKey: .error)).value
        errorCode = (try? container.decode(String.self, forKey: .errorCode)).value
        errorDescription = (try? container.decode(String?.self, forKey: .errorDescription))
        details = try? container.decode(Dictionary?.self, forKey: .details)
        if let errorFields = try? container.decode(String?.self, forKey: .errorFields) {
            self.errorFields = errorFields
        } else {
            self.errorFields = try? container.decode([String].self, forKey: .errorFields).first
        }
    }
}

enum IssueCode {
    case UNAUTHORIZED
    case UNAUTHORIZED_USER
    case WRONG_CODE
    case ALREADY_SIGNED_UP
    case TOTP_INVALID
    case EMAIL_INVALID
    case EMAIL_FORMAT
    case EMAIL_SYNTAX
    case CODE
    case INTERNAL_SERVER_ERROR
    case NO_WALLET_FOR_TESTNET
    case NOT_ENOUGH_BALANCE
    case INVALID_ARGUMENT
    case SESSION_EXPIRE
    case USED_PASSWORD
    case CUSTOM_MES(message: String)
    case SESSION_NOT_FOUND
    case WRONG_HARDKEY
    case EMPTY_CODE

    static func initValue(value: String) -> IssueCode {
        switch value.uppercased() {
        case "UNAUTHORIZED_USER":
            return .UNAUTHORIZED_USER
        case "WRONG_CODE":
            return .WRONG_CODE
        case "ALREADY_SIGNED_UP":
            return .ALREADY_SIGNED_UP
        case "TOTP_INVALID":
            return .TOTP_INVALID
        case "EMAIL_INVALID":
            return .EMAIL_INVALID
        case "EMAIL_FORMAT":
            return .EMAIL_FORMAT
        case "CODE":
            return .CODE
        case "INTERNAL_SERVER_ERROR":
            return .INTERNAL_SERVER_ERROR
        case "NOT_FOUND_DEPOSIT_ADDRESS":
            return .NO_WALLET_FOR_TESTNET
        case "NOT_ENOUGH_BALANCE":
            return .NOT_ENOUGH_BALANCE
        case "INVALID_ARGUMENT":
            return .INVALID_ARGUMENT
        case "SESSION_EXPIRE":
            return .SESSION_EXPIRE
        case "EMAIL_SYNTAX":
            return .EMAIL_SYNTAX
        case "SESSION_NOT_FOUND":
            return .SESSION_NOT_FOUND
        case "USED_PASSWORD":
            return .USED_PASSWORD
        case "UNAUTHORIZED":
            return .UNAUTHORIZED
        case "EMPTY_CODE":
            return .EMPTY_CODE
        default:
            if value.asTrimmed.isEmpty {
                return .CUSTOM_MES(message: "error_message_something_went_wrong".Localizable())
            }
            return .CUSTOM_MES(message: value)
        }
    }
    
    var message: String {
        switch self {
        case .UNAUTHORIZED_USER:
            return "alert_signin_failed_unauth".Localizable()
        case .WRONG_CODE:
            return "fragment_tfasms_genericfailure".Localizable()
        case .UNAUTHORIZED:
            return "fragment_tfasms_genericfailure".Localizable()
        case .ALREADY_SIGNED_UP:
            return "fragment_signupemailcheckup_alreadysignedup".Localizable()
        case .TOTP_INVALID, .SESSION_EXPIRE:
            return "expire_code".Localizable()
        case .EMAIL_INVALID:
            return "fragment_signupemailpassword_invalidemailsyntax".Localizable()
        case .EMAIL_FORMAT:
            return "fragment_signupemailpassword_invalidemailsyntax".Localizable()
        case .CODE:
            return "fragment_signupemailpassword_nonexistantreferral".Localizable()
        case .INTERNAL_SERVER_ERROR:
            return "delegatelogin_errordialog_content".Localizable()
        case .NO_WALLET_FOR_TESTNET:
            return "No wallet account available for ETH testnet"
        case .NOT_ENOUGH_BALANCE:
            return "alert_order_failed_notenoughbalance".Localizable()
        case .INVALID_ARGUMENT:
            return "activity_order_invalidinput".Localizable()
        case .EMAIL_SYNTAX:
            return "alert_signin_failed_unauth_unexpectedwarn".Localizable()
        case .USED_PASSWORD:
            return "forgot_password_pleaseinput_different_former_password".Localizable()
        case .CUSTOM_MES(let message):
            return message
        case .SESSION_NOT_FOUND:
            return "expire_code".Localizable()
        case .WRONG_HARDKEY:
            return "fragment_tfau2f_genericfailure".Localizable()
        case .EMPTY_CODE:
            return "commom_field_can_not_empty".Localizable()
        }
    }
}

extension IssueCode {
    private static func issueCode(fromCode code: String) -> IssueCode {
        return initValue(value: code.uppercased())
    }
}
