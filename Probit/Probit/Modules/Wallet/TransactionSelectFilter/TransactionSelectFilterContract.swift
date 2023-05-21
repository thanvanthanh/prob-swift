
import Foundation

// MARK: View Output (Presenter -> View)
protocol PresenterToViewTransactionSelectFilterProtocol {
   
}

// MARK: View Input (View -> Presenter)
protocol ViewToPresenterTransactionSelectFilterProtocol {
    var view: PresenterToViewTransactionSelectFilterProtocol? { get set }
    var interactor: PresenterToInteractorTransactionSelectFilterProtocol? { get set }
    var router: PresenterToRouterTransactionSelectFilterProtocol? { get set }
}

// MARK: Interactor Input (Presenter -> Interactor)
protocol PresenterToInteractorTransactionSelectFilterProtocol {
    var presenter: InteractorToPresenterTransactionSelectFilterProtocol? { get set }
}

// MARK: Interactor Output (Interactor -> Presenter)
protocol InteractorToPresenterTransactionSelectFilterProtocol {
}

// MARK: Router Input (Presenter -> Router)
protocol PresenterToRouterTransactionSelectFilterProtocol {
}
