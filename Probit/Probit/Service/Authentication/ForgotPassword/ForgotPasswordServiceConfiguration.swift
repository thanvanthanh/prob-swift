//
//  ForgotPasswordServiceConfiguration.swift
//  Probit
//
//  Created by Nguyen Quang on 08/09/2022.
//

import Foundation
import Alamofire

enum ForgotPasswordServiceConfiguration {
    case forgotPassword(email: String, recaptcha: String?)
    case sendMail(email: String)
    case checkMailCode(_ code: String, email: String)
    case processForgotPassword(requestModel: ForgotPasswordProcessRequestModel)
}

extension ForgotPasswordServiceConfiguration: Configuration {
    var data: Data? {
        return nil
    }
    
    var baseURL: String {
        switch self {
        default:
            return Constant.Server.baseURL
        }
    }
    
    var path: String {
        switch self {
        case .forgotPassword:
            return "api/accounts/v2/forgot-password/request"
        case .sendMail:
            return "api/accounts/v2/forgot-password/send-mail"
        case .checkMailCode:
            return "api/accounts/v2/forgot-password/check-mail-code"
        case .processForgotPassword:
            return "api/accounts/v2/forgot-password/process"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        default:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case let .forgotPassword(email, recaptcha):
            var parameters: [String: Any] = ["email": email]
            if let recaptcha = recaptcha {
                parameters["g-recaptcha-entv1-response"] = recaptcha
            }
            
            return .requestParameters(parameters: parameters)
            
        case let .sendMail(email):
            return .requestParameters(parameters: ["email": email,
                                                   "lang": AppConstant.localeId.lowercased(),
                                                   "service": "global"])
            
        case let .checkMailCode(code, email):
            let parameters: [String: Any] = ["email": email,
                                             "code": code,
                                             "service": "global"]
            return .requestParameters(parameters: parameters)
            
        case let .processForgotPassword(requestModel):
            let parameters = requestModel.dictionary ?? [:]
            return .requestParameters(parameters: parameters)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        default:
            return [:]
        }
    }
}
