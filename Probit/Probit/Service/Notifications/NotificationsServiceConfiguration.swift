//
//  NotificationsServiceConfiguration.swift
//  Probit
//
//  Created by Thân Văn Thanh on 03/11/2022.
//

import Foundation

enum NotificationsServiceConfiguration {
    case register(deviceToken: String)
}

extension NotificationsServiceConfiguration: Configuration {
    var data: Data? {
        return nil
    }
    
    var baseURL: String {
        switch self {
        default:
            return Constant.Server.baseAPIURL
        }
    }
    
    var path: String {
        switch self {
        case .register:
            return "api/android/v1/device_token/register"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .register:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case let .register(deviceToken):
            return .requestParameters(parameters: ["device_token": deviceToken])
        }
    }
    
    var headers: [String : String]? {
        switch self {
        default:
            return AppConstant.authorizationHeader
        }
    }
    
}
