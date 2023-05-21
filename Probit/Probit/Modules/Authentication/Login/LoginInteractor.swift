//
//  LoginInteractor.swift
//  Probit
//
//  Created by Thân Văn Thanh on 22/08/2022.
//  
//

import Foundation

class LoginInteractor: PresenterToInteractorLoginProtocol {
    
    // MARK: Properties
    var presenter: InteractorToPresenterLoginProtocol?
    var entity: InteractorToEntityLoginProtocol?
    var loginResponse: LoginModel?
    
    func login(username: String, password: String) {
        entity?.login(username: username.asTrimmed,
                      password: password,
                      completionHandler: { [weak self] result in
            guard let `self` = self else { return }
            switch result {
            case .success(let model):
                AppConstant.lastEmail = username
                self.loginResponse = model
                self.presenter?.loginComplete(email: username, password: password)
            case .failure(let error):
                self.presenter?.handerApiError(error: error)
            }
        })
    }
    
    func getProfileInfo() {
        entity?.getProfileInfo(completionHandler: { [weak self] result in
            guard let `self` = self else { return }
            switch result {
            case .success(let model):
                AppConstant.profileInfo = model
                self.presenter?.getProfileInfoComplete(isShowTermScreen: model.isShowTermScreen)
            case .failure(let error):
                self.presenter?.handerApiError(error: error)
            }
        })
    }
    
    func startTFA(completion: @escaping (Result<WithdrawVerificationResponse, ServiceError>) -> Void) {
        entity?.startTFA(completion: completion)
    }
}
