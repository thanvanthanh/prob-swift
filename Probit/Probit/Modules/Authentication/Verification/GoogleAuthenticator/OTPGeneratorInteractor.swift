//
//  OTPGeneratorInteractor.swift
//  Probit
//
//  Created by Thân Văn Thanh on 06/09/2022.
//  
//

import Foundation

class OTPGeneratorInteractor: PresenterToInteractorOTPGeneratorProtocol {
    
    // MARK: Properties
    var loginResponse: LoginModel?
    var presenter: InteractorToPresenterOTPGeneratorProtocol?
    var entity: InteractorToEntityOTPGeneratorProtocol?
    
    func login(username: String, password: String, totp: String) {
        entity?.login(username: username,
                      password: password,
                      totp: totp,
                      completionHandler: { [weak self] result in
            guard let `self` = self else { return }
            switch result {
            case .success(let model):
                self.loginResponse = model
                self.presenter?.loginComplete(email: username, password: password)
            case let .failure(error):
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
            case let .failure(error):
                self.presenter?.handerApiError(error: error)
            }
        })
    }
}
