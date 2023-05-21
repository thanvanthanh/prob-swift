
import Foundation

// MARK: View Output (Presenter -> View)
protocol PresenterToViewWithdrawReviewProtocol: BaseViewProtocol {
   
}

// MARK: View Input (View -> Presenter)
protocol ViewToPresenterWithdrawReviewProtocol {
    var view: PresenterToViewWithdrawReviewProtocol? { get set }
    var interactor: PresenterToInteractorWithdrawReviewProtocol? { get set }
    var router: PresenterToRouterWithdrawReviewProtocol? { get set }
    var withdrawRequest: WithdrawRequest? { get set }
    func excuteWithdraw() 
}

// MARK: Interactor Input (Presenter -> Interactor)
protocol PresenterToInteractorWithdrawReviewProtocol {
    var presenter: InteractorToPresenterWithdrawReviewProtocol? { get set }
    var entity: InteractorToEntityWithdrawProtocol? { get set }
    func excuteWithdraw(request: WithdrawRequest)
    func sendTFAEmail(sessionId: String)
}

// MARK: Interactor Output (Interactor -> Presenter)
protocol InteractorToPresenterWithdrawReviewProtocol {
    func showWithdrawResult(response: WithdrawVerificationResponse?)
    func withdrawFail(error: ServiceError)
}

// MARK: Router Input (Presenter -> Router)
protocol PresenterToRouterWithdrawReviewProtocol {
    func popToRootView()
}

protocol InteractorToEntityWithdrawProtocol {
    func excuteWithdraw(request: WithdrawRequest, completionHandler: @escaping (Result<WidthdrawResponse, ServiceError>) -> Void)
    func getTFAMethod(request: WithdrawRequest, completionHandler: @escaping (Result<WithdrawVerificationResponse, ServiceError>) -> Void)
    func sendTFAEmail(sessionId: String)
}
