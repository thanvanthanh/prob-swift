
import Foundation

// MARK: View Output (Presenter -> View)
protocol PresenterToViewVerifyOTPToWithdrawProtocol: BaseViewProtocol {
   func popToRootView()
    func otpInvalid(error: ServiceError)
}

// MARK: View Input (View -> Presenter)
protocol ViewToPresenterVerifyOTPToWithdrawProtocol {
    var view: PresenterToViewVerifyOTPToWithdrawProtocol? { get set }
    var interactor: PresenterToInteractorVerifyOTPToWithdrawProtocol? { get set }
    var router: PresenterToRouterVerifyOTPToWithdrawProtocol? { get set }
    
    func validateCode(code: String) 
}

// MARK: Interactor Input (Presenter -> Interactor)
protocol PresenterToInteractorVerifyOTPToWithdrawProtocol {
    var presenter: InteractorToPresenterVerifyOTPToWithdrawProtocol? { get set }
    var entity: InteractorToVerifyCodeEntityProtocol? { get set }
    var withdrawRequest: WithdrawRequest? { get set }
    var tfaState: WithdrawVerificationResponse? { get set }
    func excuteVerifyCode(code: String, sessionId: String)
    func sendTFAEmail(sessionId: String)
    func sendTFASms(sessionId: String)
    func callTFAPhone(sessionId: String)
}

// MARK: Interactor Output (Interactor -> Presenter)
protocol InteractorToPresenterVerifyOTPToWithdrawProtocol {
    func showVerificationResult(response: WithdrawVerificationResponse?)
    func verifyCodeFail(error: ServiceError)
    func withdrawSuccessful()
}

// MARK: Router Input (Presenter -> Router)
protocol PresenterToRouterVerifyOTPToWithdrawProtocol {
    func gotoVerificationViaEmail(tfaState: TFAState, type: AuthenticationMethod, request: WithdrawRequest)
    func gotoSuccessFulScreen()
}

protocol InteractorToVerifyCodeEntityProtocol {
    func excuteVerifyCode(code: String, sessionId: String, completionHandler: @escaping (Result<WithdrawVerificationResponse, ServiceError>) -> Void)
    func excuteWithdraw(request: WithdrawRequest, completionHandler: @escaping (Result<WidthdrawResponse, ServiceError>) -> Void)
    func sendTFAEmail(sessionId: String)
    func sendTFASms(sessionId: String)
    func callTFAPhone(sessionId: String)
}
