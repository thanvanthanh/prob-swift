//
//  BuyCryptoServiceConfiguration.swift
//  Probit
//
//  Created by Thân Văn Thanh on 08/09/2022.
//

import Foundation
import Alamofire

enum BuyCryptoServiceConfiguration {
    case defaultFiatCurrency
    case listCrypto
    case cryptoPrice(fiat: String,
                     crypto: String)
    case paymentChanel(params: PamentChanelParameters)
    case checkout(params: PaymentCheckoutParams)
    case checkPayment(paymentId: String)
    
}

extension BuyCryptoServiceConfiguration: Configuration {
    var baseURL: String {
        switch self {
        default:
            return Constant.Server.baseAPIURL
        }
    }
    
    var path: String {
        switch self {
        case .defaultFiatCurrency:
            return "api/payment/v1/default_fiat_currency_override"
        case .listCrypto:
            return "api/payment/v1/list"
        case .cryptoPrice:
            return "api/payment/v1/price"
        case .paymentChanel:
            return "api/payment/v1/channel_new"
        case .checkout:
            return "api/payment/v1/checkout"
        case.checkPayment:
            return "api/payment/v1/check"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .listCrypto, .cryptoPrice, .paymentChanel, .checkPayment, .defaultFiatCurrency:
            return .get
        case .checkout:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .defaultFiatCurrency:
            return .requestParameters(parameters: [:])
        case .listCrypto:
            return .requestParameters(parameters: ["lang": AppConstant.localeId])
        case let .cryptoPrice(fiat, crypto):
            return .requestParameters(parameters: ["fiat": fiat,
                                                   "crypto": crypto])
        case let .paymentChanel(params):
            return .requestParameters(parameters: params.dictionary)
        case let .checkout(params):
            return .requestParameters(parameters: params.dictionary)
        case let .checkPayment(paymentId):
            return .requestParameters(parameters: ["payment_id": paymentId])
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .paymentChanel, .checkout, .checkPayment:
            return AppConstant.authorizationHeader
        default:
            return [:]
        }
    }
    
    var data: Data? {
        return nil
    }
    
}
