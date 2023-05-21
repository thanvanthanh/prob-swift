
import Foundation

class WithdrawReviewPresenter: ViewToPresenterWithdrawReviewProtocol {    
    var withdrawRequest: WithdrawRequest?

    // MARK: Properties
    var view: PresenterToViewWithdrawReviewProtocol?
    var interactor: PresenterToInteractorWithdrawReviewProtocol?
    var router: PresenterToRouterWithdrawReviewProtocol?
    
    required init(withdraw: WithdrawRequest) {
        self.withdrawRequest = withdraw
    }
    
    func excuteWithdraw() {
        guard let request = self.withdrawRequest else { return }
        view?.showLoading()
        interactor?.excuteWithdraw(request: request)
    }
}

extension WithdrawReviewPresenter: InteractorToPresenterWithdrawReviewProtocol {
    func showWithdrawResult(response: WithdrawVerificationResponse?) {
        view?.hideLoading()
        guard let tfaState = response,
              let state = response?.state else { return }

        let firstMethod = state.policy?.methods?.first ?? ""
        switch firstMethod {
            case AuthenticationMethod.totp.rawValue, AuthenticationMethod.sms.rawValue:
                VerifyOTPToWithdrawRouter().showScreen(tfaState: tfaState, withdrawRequest: withdrawRequest)
            case AuthenticationMethod.email.rawValue:
            self.interactor?.sendTFAEmail(sessionId: tfaState.state?.sessId ?? "")
            VerificationRouter().showScreen(email: AppConstant.lastEmail ?? "", type: .withdraw, tfaState: state, withdrawRequest: withdrawRequest)
            case AuthenticationMethod.u2f.rawValue:
            guard let request = response?.u2fRequest,
                  let purpose = response?.state?.metadata?.purpose,
                  let sessId = response?.state?.sessId,
                  let userId = response?.state?.userId else { break }
            WithdrawVerificationRouter()
                .showScreen(withArgument: .withdraw(WithDrawParameter(withdrawlRequest: withdrawRequest,
                                                                      u2fRequest: request,
                                                                      purpose: purpose,
                                                                      sessId: sessId,
                                                                      userId: userId)))
            default:
                router?.popToRootView()
                break
        }

    }
    
    func withdrawFail(error: ServiceError) {
        view?.hideLoading()
    }
}
