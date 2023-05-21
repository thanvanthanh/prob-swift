//
//  APIErrorManager.swift
//  Probit
//
//  Created by Beacon on 31/08/2022.
//

import Foundation

class APIErrorManager {
    static func handleError(statusCode: Int) {
         switch statusCode {
             case 401:
             //Invalid Session
             break
             case -1009, -1005:
             //No internet
             break
             case -1000, -1001, -1002, -1003:
             //Can't Connect to server
             break
             default:
             //Log Error
             break
         }
    }
}
