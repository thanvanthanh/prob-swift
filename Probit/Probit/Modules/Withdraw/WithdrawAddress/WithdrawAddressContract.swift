
import Foundation

// MARK: View Output (Presenter -> View)
protocol PresenterToViewWithdrawAddressProtocol: BaseViewProtocol {
    func addressInvalid()
    func addressValid()
}

// MARK: View Input (View -> Presenter)
protocol ViewToPresenterWithdrawAddressProtocol {
    var view: PresenterToViewWithdrawAddressProtocol? { get set }
    var interactor: PresenterToInteractorWithdrawAddressProtocol? { get set }
    var router: PresenterToRouterWithdrawAddressProtocol? { get set }
    func gotoReviewDetailView()
    var withdrawRequest: WithdrawRequest? { get set }
    func addressInvalid()
    func addressValid()
    func validateAddress()
}

// MARK: Interactor Input (Presenter -> Interactor)
protocol PresenterToInteractorWithdrawAddressProtocol {
    var presenter: InteractorToPresenterWithdrawAddressProtocol? { get set }
    func validateAddress(request: WithdrawRequest)
}

// MARK: Interactor Output (Interactor -> Presenter)
protocol InteractorToPresenterWithdrawAddressProtocol {
    func addressInvalid()
    func addressValid()
}

// MARK: Router Input (Presenter -> Router)
protocol PresenterToRouterWithdrawAddressProtocol {
    func gotoReviewDetail(withdraw: WithdrawRequest)
}
