
import Foundation

// MARK: View Output (Presenter -> View)
protocol PresenterToViewQRCodeScannerProtocol {
   
}

// MARK: View Input (View -> Presenter)
protocol ViewToPresenterQRCodeScannerProtocol {
    var view: PresenterToViewQRCodeScannerProtocol? { get set }
    var interactor: PresenterToInteractorQRCodeScannerProtocol? { get set }
    var router: PresenterToRouterQRCodeScannerProtocol? { get set }
    func popToReview()
}

// MARK: Interactor Input (Presenter -> Interactor)
protocol PresenterToInteractorQRCodeScannerProtocol {
    var presenter: InteractorToPresenterQRCodeScannerProtocol? { get set }
}

// MARK: Interactor Output (Interactor -> Presenter)
protocol InteractorToPresenterQRCodeScannerProtocol {
}

// MARK: Router Input (Presenter -> Router)
protocol PresenterToRouterQRCodeScannerProtocol {
    func popToReview()
}
