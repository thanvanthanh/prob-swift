//
//  TFAServiceConfiguration.swift
//  Probit
//
//  Created by Sotatek on 28/12/2022.
//

import Foundation

enum TFAServiceConfiguration {
    case login(TFALoginParameter)
    case withDraw(TFAWithdrawParameter)
}

extension TFAServiceConfiguration: Configuration {
    
    var baseURL: String {
        switch self {
        case .login:
            return Constant.Server.baseURL
        case .withDraw:
            return Constant.Server.baseAPIURL
        }
    }
    
    var path: String {
        switch self {
        case .login:
            return "token"
        case .withDraw:
            return "api/security/v1/tfa_validate_new"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .login, .withDraw:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .login(let argument):
            let parameters: [String: Any] = argument.toDictionary
            return .requestParameters(parameters: parameters)
        case .withDraw(let parameter):
            let parameters: [String: Any] = parameter.toDictionary
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
