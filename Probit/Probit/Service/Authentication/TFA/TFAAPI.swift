//
//  TFAAPI.swift
//  Probit
//
//  Created by Sotatek on 28/12/2022.
//

import Foundation

protocol TFAAPIProtocol {
    func login( _ parameters: TFALoginParameter,
                completionHandler: @escaping (Result<LoginModel, ServiceError>) -> Void)
}

class TFAAPI: BaseAPI<TFAServiceConfiguration>, TFAAPIProtocol {
    
    private override init() {}
    
    private static let _shared = TFAAPI()
    static var shared: TFAAPI { return _shared }
    
    func login(_ parameters: TFALoginParameter, completionHandler: @escaping (Result<LoginModel, ServiceError>) -> Void) {
        
        self.fetchData(
            configuration: .login(parameters),
            responseType: LoginModel.self,
            completionHandler: completionHandler)
    }
    
    func validateWithdraw(_ parameters: TFAWithdrawParameter,
                          completionHandler: @escaping (Result<WithdrawVerificationResponse, ServiceError>) -> Void) {
        self.fetchData(
            configuration: .withDraw(parameters),
            responseType: WithdrawVerificationResponse.self,
            completionHandler: completionHandler)
    }
}

