//
//  WebViewMessage.swift
//  Probit
//
//  Created by Dang Nguyen on 15/12/2022.
//

import Foundation

enum WebViewMessageType {
    case unknown
    case requiredLogin
    case invalidToken
    case getToken
    case move
}

enum WebViewMessageRoute: String {
    case unknown
    case purchase
    case deposit
}

struct WebViewMessage {
    var message: String?
    
    func detectCallBackTtype() -> WebViewMessageType {
        guard let message = self.message else {
            return .unknown
        }
        var callbackType: WebViewMessageType
        switch message {
        case "getToken":
            callbackType = .getToken
        case "requestUserLogin":
            callbackType = .requiredLogin
        case "onInvalidToken":
            callbackType = .invalidToken
        case "move":
            callbackType = .move
        default:
            callbackType = .unknown
        }
        return callbackType
    }
}
