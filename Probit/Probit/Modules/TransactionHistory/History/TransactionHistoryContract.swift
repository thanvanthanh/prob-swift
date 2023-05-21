
import Foundation

// MARK: View Output (Presenter -> View)
protocol PresenterToViewTransactionHistoryProtocol {
    func reloadData()
    func getDataSuccess()
    func loadDataPageView(page: Int?)
    func applyFilter()
}

// MARK: View Input (View -> Presenter)
protocol ViewToPresenterTransactionHistoryProtocol {
    var view: PresenterToViewTransactionHistoryProtocol? { get set }
    var interactor: PresenterToInteractorTransactionHistoryProtocol? { get set }
    var router: PresenterToRouterTransactionHistoryProtocol? { get set }
    var menus: [MenuBar] { get }
    var currentPage: Int { get }
    func viewDidLoad()
    func didSelectMenuItem(index: IndexPath)
    func applyFilter()
}

// MARK: Interactor Input (Presenter -> Interactor)
protocol PresenterToInteractorTransactionHistoryProtocol {
    var presenter: InteractorToPresenterTransactionHistoryProtocol? { get set }
    var menus: [MenuBar] { get set }
    var currentPage: Int { get set }
    var currency: WalletCurrency { get set }
    func getData()
    func didSelectMenuItem(index: IndexPath)
}

// MARK: Interactor Output (Interactor -> Presenter)
protocol InteractorToPresenterTransactionHistoryProtocol {
    func dataListDidFetch()
    func changeStateMenuSuccess()
}

// MARK: Router Input (Presenter -> Router)
protocol PresenterToRouterTransactionHistoryProtocol {
}
