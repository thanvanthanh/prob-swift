//
//  VerificationPresenter.swift
//  Probit
//
//  Created by Thân Văn Thanh on 22/08/2022.
//  
//

import Foundation

class VerificationPresenter: ViewToPresenterVerificationProtocol {

    // MARK: Properties
    var email: String?
    var password: String?
    var type: AuthScreenFrom?
    var view: PresenterToViewVerificationProtocol?
    var interactor: PresenterToInteractorVerificationProtocol?
    var router: PresenterToRouterVerificationProtocol?
    private var timer: Timer?
    
    func viewWillAppear() {
        guard interactor?.tfaState?.expireTs != nil else { return }
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(runTimer), userInfo: nil, repeats: true)
    }
    
    func viewWillDisappear() {
        self.distroyTimer()
    }
    
    func navigateToInputPin() {
        router?.navigateToTerms()
    }
    
    func signupProcess(code: String) {
        guard let email = email else { return }
        view?.showLoading()
        interactor?.signupProcess(code: code, email: email)
    }
    
    func login(emailCode: String) {
        guard let email = email, let password = password else { return }
        view?.showLoading()
        interactor?.login(username: email,
                          password: password,
                          emailCode: emailCode)
    }
    
    func verifyWithdrawCode(code: String) {
        view?.showLoading()
        interactor?.excuteVerifyCode(code: code)
    }
    
    func signUpResendOtp() {
        view?.showLoading()
        
        if let email = email, !email.isEmpty {
            interactor?.signUpResendOtp(email: email)
        } else {
            switch interactor?.type {
            case .email:
                interactor?.sendTFAEmail()
            case .sms:
                interactor?.sendTFASms()
            case .phone:
                interactor?.callTFAPhone()
            default:
                break
            }
        }
    }
    
    func getProfileInfo() {
        view?.showLoading()
        interactor?.getProfileInfo()
    }
    
    func navigateToHelpEmail() {
        router?.navigateToHelpEmail()
    }
    
    func popToRootView() {
        router?.popToRootView()
    }
    
    func reLogin() {
        router?.reLogin()
    }
    
    private func distroyTimer() {
        self.timer?.invalidate()
        self.timer = nil
    }
    
    @objc
    func runTimer() {
        guard let expireTs = self.interactor?.tfaState?.expireTs else { return }
        let expireDate = Date(timeIntervalSince1970: TimeInterval(expireTs/1000))
        print(expireDate.stringFromDateGMT())
        if Date() >= expireDate {
            distroyTimer()
            if type == .withdraw && view?.didInputOTP == false {
                self.view?.showAlertExpire() { [weak self] in
                    guard let `self` = self else { return }
                    self.router?.backToReviewWithdraw()
                }
                return
            }
            
            if type == .signIn && view?.didInputOTP == false {
                self.view?.showAlertExpire() { [weak self] in
                    guard let `self` = self else { return }
                    self.router?.reLogin()
                }
                return
            }
        }
        
    }
}

extension VerificationPresenter: InteractorToPresenterVerificationProtocol {
    
    // SignUp
    func signupComplete() {
        view?.hideLoading()
        router?.navigateToSignUpComplete()
    }
    
    func sendOtpComplete() {
        view?.hideLoading()
        view?.resendOtp()
    }
    
    func sendOtpFail() {
        view?.hideLoading()
        view?.sendOTPFail()
    }

    // Sign In
    func loginSuccessfully() {
        view?.hideLoading()
        getProfileInfo()
    }
    
    func showVerificationResult(response: WithdrawVerificationResponse) {
        guard let state = response.state else { return }
        let numberOfPassedMethods = state.methodStates?.count ?? 0
        let numberOfMethods = state.policy?.methods?.count ?? 0
        if numberOfMethods > numberOfPassedMethods  {
            let nextMethod = state.policy?.methods?[numberOfPassedMethods] ?? ""
            view?.hideLoading()
            switch nextMethod {
                case AuthenticationMethod.totp.rawValue, AuthenticationMethod.sms.rawValue:
                    VerifyOTPToWithdrawRouter().showScreen(tfaState: response)
                case AuthenticationMethod.u2f.rawValue:
                    break
                default:
                    interactor?.excuteWithdraw(sessId: state.sessId ?? "")
                    break
            }
            return
        }
        interactor?.excuteWithdraw(sessId: state.sessId ?? "")
    }
    
    func resendingCodeSuccess() {
        view?.hideLoading()
    }
    
    func withdrawSuccessful() {
        view?.hideLoading()
        WithdrawSuccessfulRouter().showScreen()
    }
    
    func getProfileInfoComplete(isShowTermScreen: Bool) {
        view?.hideLoading()
        guard isShowTermScreen else {
            view?.navigateToHome()
            return
        }
        self.router?.navigateToTerms()
    }
    
    
    func handerApiError(error: ServiceError) {
        view?.hideLoading()
        view?.otpInvalid(error: error)
    }
}
