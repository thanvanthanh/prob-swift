
import Foundation

typealias AddressCallback = (() -> Void)

// MARK: View Output (Presenter -> View)
protocol PresenterToViewWithdrawAmountProtocol: BaseViewProtocol {
    func showContract(withdrawConfig: ConfigWithdrawal?, dictionary: [String: String]?, platform: Platform?)
}

// MARK: View Input (View -> Presenter)
protocol ViewToPresenterWithdrawAmountProtocol {
    var view: PresenterToViewWithdrawAmountProtocol? { get set }
    var interactor: PresenterToInteractorWithdrawAmountProtocol? { get set }
    var router: PresenterToRouterWithdrawAmountProtocol? { get set }
    var currency: WalletCurrency? { get }

    func gotoAddressView(withdrawRequest: WithdrawRequest)
    func getConfiguration()
}

// MARK: Interactor Input (Presenter -> Interactor)
protocol PresenterToInteractorWithdrawAmountProtocol {
    var presenter: InteractorToPresenterWithdrawAmountProtocol? { get set }
    var currency: WalletCurrency? { get set }
    var withdrawalLimit: WithdrawLimit? { get set }
    var platformSelected: Platform? { get set}
    var networkFeeSelected: WithdrawalFee? { get set}
    var configuration: ConfigWdwarnModel? { get set}
    func getConfig(completed: @escaping() -> Void)
    func generateCurrentPlatformContract() -> ConfigWithdrawal?
}

// MARK: Interactor Output (Interactor -> Presenter)
protocol InteractorToPresenterWithdrawAmountProtocol {
}

// MARK: Router Input (Presenter -> Router)
protocol PresenterToRouterWithdrawAmountProtocol {
    func gotoAddressView(withdrawRequest: WithdrawRequest)
}
