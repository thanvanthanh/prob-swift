
import Foundation

class QRCodeScannerPresenter: ViewToPresenterQRCodeScannerProtocol {
    // MARK: Properties
    var view: PresenterToViewQRCodeScannerProtocol?
    var interactor: PresenterToInteractorQRCodeScannerProtocol?
    var router: PresenterToRouterQRCodeScannerProtocol?
    
    func popToReview() {
        router?.popToReview()
    }
}

extension QRCodeScannerPresenter: InteractorToPresenterQRCodeScannerProtocol {
    
}
