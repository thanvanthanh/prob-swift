//
//  WithdrawVerificationInteractor.swift
//  Probit
//
//  Created by Đào Mỹ Đông on 01/12/2565 BE.
//  
//

import Foundation

class WithdrawVerificationInteractor: PresenterToInteractorWithdrawVerificationProtocol {
   
    // MARK: Properties
    var presenter: InteractorToPresenterWithdrawVerificationProtocol?
    var withdrawResponse: WithdrawVerificationResponse?
    var loginResponse: LoginModel?
    
    func login(parameter: TFALoginParameter) {
        TFAAPI.shared.login(parameter) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                AppConstant.lastEmail = parameter.username
                self.loginResponse = response
                self.presenter?.loginComplete(username: parameter.username, password: parameter.password)
            case .failure(let error):
                self.presenter?.handerApiError(error: error)
            }
        }
    }
    
    func sendTFAEmail(_ sessionId: String, completion: @escaping (Result<WithdrawSendEmailResponse, ServiceError>) -> Void){
        WithdrawVerificationAPI.shared.sendEmail(sessionId: sessionId, completionHandler: completion)        
    }
    
    func verifyTFA(parameter: TFAWithdrawParameter) {
        TFAAPI.shared.validateWithdraw(parameter) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                self.withdrawResponse = response
                self.presenter?.getWithdrawResponseSuccesed()
            case .failure(let error):
                self.presenter?.handerApiError(error: error)
            }
        }
    }
    
    func getProfileInfo() {
        HomeAPI().getProfileInfo { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let profile):
                AppConstant.profileInfo = profile
                self.presenter?.getProfileInfoComplete(isShowTermScreen: profile.isShowTermScreen)
            case .failure(let error):
                self.presenter?.handerApiError(error: error)
            }
        }
    }
    
    
    
}
