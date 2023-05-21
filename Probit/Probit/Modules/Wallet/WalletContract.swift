
import Foundation

// MARK: View Output (Presenter -> View)
protocol PresenterToViewWalletProtocol {
    func bindData(_ items: [WalletCurrency])
    func showError(error: ServiceError)
    func showSuccess(message: String)
    var isAttached: Bool { get }
}

// MARK: View Input (View -> Presenter)
protocol ViewToPresenterWalletProtocol {
    var view: PresenterToViewWalletProtocol? { get set }
    var interactor: PresenterToInteractorWalletProtocol? { get set }
    var router: PresenterToRouterWalletProtocol? { get set }
    var currencies: [WalletCurrency] {get}
    var stakeCurrencies: [StakeCurrency] { get }
    func fetchData()
    func disconnect()
    func filterEmptyBalance(isHide: Bool)
    func openSearchCurrencyScreen()
    func reConnect()
    func clearWaletData()
    func viewDidLoad()
    func viewWillAppear()
    func viewWillDisappear()
}

// MARK: Interactor Input (Presenter -> Interactor)
protocol PresenterToInteractorWalletProtocol {
    var presenter: InteractorToPresenterWalletProtocol? { get set }
}

// MARK: Interactor Output (Interactor -> Presenter)
protocol InteractorToPresenterWalletProtocol {
}

// MARK: Router Input (Presenter -> Router)
protocol PresenterToRouterWalletProtocol {
    
}
