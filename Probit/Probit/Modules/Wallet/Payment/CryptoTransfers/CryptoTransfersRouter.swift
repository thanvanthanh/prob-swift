
import Foundation
import UIKit

class CryptoTransfersRouter: PresenterToRouterCryptoTransfersProtocol {
    func showScreen(openAlone: Bool = false, data: WalletCurrency?) {
        let destinationVC = self.createModule(data: data)
        destinationVC.getRootTabbarViewController().push(viewController: destinationVC, isAnimated: true, ishidesBottomBar: true)
    }
    
    func setupRootView() {
        guard let appdelegate = UIApplication.shared.delegate as? AppDelegate,
              let window = appdelegate.window else { return }
        
        let destinationVC = self.createModule(data: nil)
        window.rootViewController = UINavigationController.init(rootViewController: destinationVC)
        window.makeKeyAndVisible()
    }
    
    // MARK: Static methods
    func createModule(data: WalletCurrency?) -> UIViewController {
        let storyboard = UIStoryboard(name: "CryptoTransfers", bundle: nil)
        let viewController = storyboard.instantiateViewController(viewControllerType:CryptoTransfersViewController.self)
        
        let presenter: ViewToPresenterCryptoTransfersProtocol & InteractorToPresenterCryptoTransfersProtocol = CryptoTransfersPresenter()
        let interactor = CryptoTransfersInteractor(data)
        viewController.presenter = presenter
        viewController.presenter?.router = CryptoTransfersRouter()
        viewController.presenter?.view = viewController
        viewController.presenter?.interactor = interactor
        viewController.presenter?.interactor?.presenter = presenter

        return viewController
    }
}
