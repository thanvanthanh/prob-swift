//
//  LoginService.swift
//  Probit
//
//  Created by Beacon on 31/08/2022.
//

import Foundation
import Alamofire

enum LoginServiceConfiguration {
    case login(username: String,
               password: String,
               recaptcha: String?,
               emailCode: String?,
               totp: String?)
    case refreshToken
}

extension LoginServiceConfiguration: Configuration {
    
    var baseURL: String {
        switch self {
        default:
            return Constant.Server.baseURL
        }
    }
    
    var path: String {
        switch self {
        case .login, .refreshToken:
            return "token"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .login, .refreshToken:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .login(let userName, let password, let recaptcha, let emailCode, let totp):
            
            var parameters: [String: Any] = ["client_id": "probit-login",
                                             "device_id": AppConstant.deviceUUID,
                                             "grant_type": "password",
                                             "username": userName,
                                             "password": password]
            if let recaptcha = recaptcha {
                parameters["g-recaptcha-entv1-response"] = recaptcha
            }
            if let emailCode = emailCode {
                parameters["email_code"] = emailCode
            }
            if let totp = totp {
                parameters["totp"] = totp
            }
            return .requestParameters(parameters: parameters)
        case .refreshToken:
            let parameters: [String: Any] = ["grant_type": "refresh_token",
                                             "refresh_token": AppConstant.refreshToken ?? "",
                                             "app_link": false]
            return .requestParameters(parameters: parameters)
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
