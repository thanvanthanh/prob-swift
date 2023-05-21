
import Foundation

class TransactionHistoryPresenter: ViewToPresenterTransactionHistoryProtocol {
    // MARK: Properties
    var view: PresenterToViewTransactionHistoryProtocol?
    var interactor: PresenterToInteractorTransactionHistoryProtocol?
    var router: PresenterToRouterTransactionHistoryProtocol?
    var menus: [MenuBar] { interactor?.menus ?? [] }
    
    var currentPage: Int {
        interactor?.currentPage ?? 0
    }
    
    func viewDidLoad() {
        interactor?.getData()
    }
    
    func didSelectMenuItem(index: IndexPath) {
        view?.loadDataPageView(page: index.row)
        interactor?.didSelectMenuItem(index: index)
    }
    
    func applyFilter() {
        view?.applyFilter()
        interactor?.getData()
    }
}

extension TransactionHistoryPresenter: InteractorToPresenterTransactionHistoryProtocol {
    func dataListDidFetch() {
        view?.getDataSuccess()
    }
    
    func changeStateMenuSuccess() {
        view?.reloadData()
    }
}
