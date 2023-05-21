//
//  Enviroment.swift
//  Probit
//
//  Created by Thân Văn Thanh on 21/11/2022.
//

import Foundation

enum Enviroment {
    case staging
    case production
}

extension Enviroment {
    
    var baseURL: String {
        switch self {
        case .staging:
            return "https://staging.probitglobal.com/"
        case .production:
            return "https://www.probit.com/"
        }
    }
    
    var socketBaseURL: String {
        return socketURL + socketCorePath
    }
    
    var accountURL: String {
        switch self {
        case .staging:
            return "https://accounts.staging.probitglobal.com/"
        case .production:
            return "https://accounts.probit.com/"
        }
    }
    
    var staticURL: String {
        switch self {
        case .staging:
            return "https://static.staging.probitglobal.com/"
        case .production:
            return "https://static.probit.com/"
        }
    }
    
    var socketURL: String {
        switch self {
        case .staging:
            return "wss://api.staging.probitglobal.com"
        case .production:
            return "wss://www.probit.com"
        }
    }
    
    var socketCorePath: String {
        switch self {
        case .staging:
            return "/api/exchange/v1/ws"
        case .production:
            return "/api/exchange/v1/ws"
        }
    }
}
