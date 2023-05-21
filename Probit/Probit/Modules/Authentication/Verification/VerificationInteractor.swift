//
//  VerificationInteractor.swift
//  Probit
//
//  Created by Thân Văn Thanh on 22/08/2022.
//  
//

import Foundation

class VerificationInteractor: PresenterToInteractorVerificationProtocol {
    // MARK: Properties
    var presenter: InteractorToPresenterVerificationProtocol?
    var entity: InteractorToEntityVerificationProtocol?
    var tfaState: TFAState?
    var withdrawRequest: WithdrawRequest? = nil
    var type: AuthenticationMethod = .email

    func signupProcess(code: String, email: String) {
        entity?.signupProcess(code: code,
                              email: email,
                              completionHandler: { [weak self] result in
            guard let `self` = self else { return }
            switch result {
            case .success:
                self.presenter?.signupComplete()
            case let .failure(error):
                self.presenter?.handerApiError(error: error)
            }
        })
    }
    
    func signUpResendOtp(email: String) {
        entity?.sendOTP(email: email, completionHandler: { [weak self] result in
            guard let `self` = self else { return }
            switch result {
            case .success:
                self.presenter?.sendOtpComplete()
            case .failure(_):
                self.presenter?.sendOtpFail()
                break
            }
        })
    }
    
    func login(username: String, password: String, emailCode: String) {
        entity?.login(username: username,
                      password: password,
                      emailCode: emailCode, completionHandler: { [weak self] result in
            guard let `self` = self else { return }
            switch result {
            case .success(let model):
                guard let accessToken = model.accessToken,
                      let refreshToken = model.refreshToken else { return }
                AppConstant.accessToken = accessToken
                AppConstant.tokenType = model.tokenType
                AppConstant.refreshToken = refreshToken
                self.presenter?.loginSuccessfully()
//                AppDelegate.shared.requestForNewToken()
            case let .failure(error):
                self.presenter?.handerApiError(error: error)
            }
        })
    }
    
    func excuteVerifyCode(code: String) {
        let sessionId = self.tfaState?.sessId ?? ""
        entity?.excuteVerifyCode(code: code, sessionId: sessionId, type: self.type, completionHandler: { [weak self] result in
            guard let `self` = self else { return }
            switch result {
            case let .success(response):
                let isSuccess = response.success ?? false
                if isSuccess {
                    self.presenter?.showVerificationResult(response: response)
                } else {
                    self.presenter?.handerApiError(error: ServiceError(issueCode: .SESSION_EXPIRE))
                }
            case let .failure(error):
                self.presenter?.handerApiError(error: error)
            }
        })
    }
    
    func excuteWithdraw(sessId: String) {
        guard var request = self.withdrawRequest else {
            self.presenter?.handerApiError(error: ServiceError(issueCode: .TOTP_INVALID))
            return
        }
        request.tfa_session_id = sessId
        entity?.excuteWithdraw(request: request, completionHandler: { [weak self] result in
            guard let `self` = self else { return }
            switch result {
            case .success(_):
                self.presenter?.withdrawSuccessful()
            case .failure(let error):
                self.presenter?.handerApiError(error: error)
            }
        })
    }
    
    func sendTFAEmail() {
        let sessionId = self.tfaState?.sessId ?? ""
        entity?.sendTFAEmail(sessionId: sessionId, completionHandler: {
            self.presenter?.resendingCodeSuccess()
        })
    }
    
    
    func sendTFASms() {
        let sessionId = self.tfaState?.sessId ?? ""
        entity?.sendTFASms(sessionId: sessionId, completionHandler: {
            self.presenter?.resendingCodeSuccess()
        })
    }
    
    func callTFAPhone() {
        let sessionId = self.tfaState?.sessId ?? ""
        entity?.callTFAPhone(sessionId: sessionId, completionHandler: {
            self.presenter?.resendingCodeSuccess()
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
