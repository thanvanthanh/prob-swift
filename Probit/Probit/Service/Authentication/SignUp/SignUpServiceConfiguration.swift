//
//  SignUpServiceConfiguration.swift
//  Probit
//
//  Created by Nguyen Quang on 05/09/2022.
//

import Foundation
import Alamofire

enum SignUpServiceConfiguration {
    case register(username: String,
                  password: String,
                  passwordConfirm: String,
                  agreements: Agreements,
                  referralCode: String?,
                  recaptcha: String?)
    case sendSignupMail(email: String)
    case signupProcess(code: String, email: String)
}

extension SignUpServiceConfiguration: Configuration {
    var baseURL: String {
        switch self {
        default:
            return Constant.Server.baseURL
        }
    }
    
    var path: String {
        switch self {
        case .register:
            return "api/accounts/v2/signup-request"
        case .sendSignupMail:
            return "api/accounts/v2/send-signup-mail"
        case .signupProcess:
            return "api/accounts/v2/signup-process"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .register, .sendSignupMail:
            return .post
        case .signupProcess:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .register(let userName,
                       let password,
                       let passwordConfirm,
                       let agreements,
                       let referralCode,
                       let recaptcha):
            var parameters: [String: Any] = ["email": userName,
                                             "password": password,
                                             "password_confirm": passwordConfirm,
                                             "lang": AppConstant.locale,
                                             "agreement": "1",
                                             "agreements": agreements.dictionary ?? [:],
                                             "referral_code": referralCode ?? "",
                                             "service": "global"]
            if let recaptcha = recaptcha {
                parameters["g-recaptcha-entv1-response"] = recaptcha
            }
            return .requestParameters(parameters: parameters)
        case .sendSignupMail(email: let email):
            return .requestParameters(parameters: ["email": email,
                                                   "lang": AppConstant.locale])
        case .signupProcess(let code, let email):
            return .requestParameters(parameters: ["code": code,
                                                   "email": email])
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
