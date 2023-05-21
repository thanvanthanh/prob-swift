//
//  DepositConfiguration.swift
//  Probit
//
//  Created by Nguyen Quang on 03/02/2023.
//
//https://static.staging.probitglobal.com/ua-cfg/explorer-urls-core.json
import Foundation

enum DepositConfiguration {
    case explorerCoreDeposit
}

extension DepositConfiguration: Configuration {
    var baseURL: String {
        switch self {
        default:
            return Constant.Server.baseStaticURL
        }
    }
    
    var path: String {
        switch self {
        case .explorerCoreDeposit:
            return "ua-cfg/explorer-urls-core.json"
        }
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var task: Task {
        switch self {
        case .explorerCoreDeposit:
            return .requestPlain
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
