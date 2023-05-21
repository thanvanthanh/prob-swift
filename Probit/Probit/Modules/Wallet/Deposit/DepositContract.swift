
import Foundation

// MARK: View Output (Presenter -> View)
protocol PresenterToViewDepositProtocol {
    func hideLoading()
    func showLoading()
    func showError(error: ServiceError)
    func showSuccess(message: String)
    func updateUI()
}

// MARK: View Input (View -> Presenter)
protocol ViewToPresenterDepositProtocol {
    var view: PresenterToViewDepositProtocol? { get set }
    var interactor: PresenterToInteractorDepositProtocol? { get set }
    var router: PresenterToRouterDepositProtocol? { get set }
    func viewDidLoad()
}

// MARK: Interactor Input (Presenter -> Interactor)
protocol PresenterToInteractorDepositProtocol {
    var presenter: InteractorToPresenterDepositProtocol? { get set }
    var depositAddress: DepositAddress? { get }
    var configDeposit: ConfigDeposit? { get }
    var walletCurrency: WalletCurrency { get }
    var platformSelected: Platform? { get set}
    var idPlatformSelected: String? { get set}
    var configWdwarnModel: ConfigWdwarnModel? { get }
    func getData()
}

// MARK: Interactor Output (Interactor -> Presenter)
protocol InteractorToPresenterDepositProtocol {
    func handerApiError(error: ServiceError)
    func getDataSuccess()
}

// MARK: Router Input (Presenter -> Router)
protocol PresenterToRouterDepositProtocol {
}
