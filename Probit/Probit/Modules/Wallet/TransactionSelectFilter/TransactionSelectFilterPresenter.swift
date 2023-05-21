
import Foundation

class TransactionSelectFilterPresenter: ViewToPresenterTransactionSelectFilterProtocol {
    // MARK: Properties
    var view: PresenterToViewTransactionSelectFilterProtocol?
    var interactor: PresenterToInteractorTransactionSelectFilterProtocol?
    var router: PresenterToRouterTransactionSelectFilterProtocol?
}

extension TransactionSelectFilterPresenter: InteractorToPresenterTransactionSelectFilterProtocol {
    
}
