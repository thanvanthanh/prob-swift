
import Foundation

class VerifyOTPToWithdrawPresenter: ViewToPresenterVerifyOTPToWithdrawProtocol {
    // MARK: Properties
    var view: PresenterToViewVerifyOTPToWithdrawProtocol?
    var interactor: PresenterToInteractorVerifyOTPToWithdrawProtocol?
    var router: PresenterToRouterVerifyOTPToWithdrawProtocol?
    
    func validateCode(code: String) {
        view?.showLoading()
        let sessionId = interactor?.tfaState?.state?.sessId ?? ""
        interactor?.excuteVerifyCode(code: code, sessionId: sessionId)
    }
}

extension VerifyOTPToWithdrawPresenter: InteractorToPresenterVerifyOTPToWithdrawProtocol {
    func showVerificationResult(response: WithdrawVerificationResponse?) {
        view?.hideLoading()
        guard let tfaState = response, let state = response?.state else { return }
        let numberOfPassedMethods = state.methodStates?.count ?? 0
        let numberOfMethods = state.policy?.methods?.count ?? 0
        if numberOfMethods > numberOfPassedMethods  {
            let nextMethod = state.policy?.methods?[numberOfPassedMethods] ?? ""
            switch nextMethod {
                case AuthenticationMethod.totp.rawValue:
                    VerifyOTPToWithdrawRouter().showScreen(tfaState: tfaState, withdrawRequest: interactor?.withdrawRequest)
                case AuthenticationMethod.email.rawValue:
                    if let request = self.interactor?.withdrawRequest {
                        self.interactor?.sendTFAEmail(sessionId: state.sessId ?? "")
                        router?.gotoVerificationViaEmail(tfaState: state, type: .email, request: request)
                    }
                case AuthenticationMethod.sms.rawValue:
                    if let request = self.interactor?.withdrawRequest {
                        self.interactor?.sendTFASms(sessionId: state.sessId ?? "")
                        router?.gotoVerificationViaEmail(tfaState: state, type: .sms, request: request)
                    }
                    break
                case AuthenticationMethod.phone.rawValue:
                    if let request = self.interactor?.withdrawRequest {
                        self.interactor?.callTFAPhone(sessionId: state.sessId ?? "")
                        router?.gotoVerificationViaEmail(tfaState: state, type: .phone, request: request)
                    }
                    break
                case AuthenticationMethod.u2f.rawValue:
                    break
                default:
                    router?.gotoSuccessFulScreen()
                    break
            }
            return
        }
        router?.gotoSuccessFulScreen()
    }
    
    func withdrawSuccessful() {
        router?.gotoSuccessFulScreen()
    }
    
    func verifyCodeFail(error: ServiceError) {
        view?.hideLoading()
        view?.otpInvalid(error: error)
    }
}
