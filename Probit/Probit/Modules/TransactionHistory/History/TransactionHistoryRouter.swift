
import Foundation
import UIKit

enum TransactionScreenType {
    case normal
    case buyCrypto
}

class TransactionHistoryRouter: PresenterToRouterTransactionHistoryProtocol {
    
    func showScreen(currency: WalletCurrency) {
        let destinationVC = self.createModule(currency: currency)
        destinationVC.getRootTabbarViewController().pushViewController(destinationVC, animated: true)
    }

    func setupRootView(currency: WalletCurrency) {
        guard let appdelegate = UIApplication.shared.delegate as? AppDelegate,
              let window = appdelegate.window else { return }
        
        let destinationVC = self.createModule(currency: currency)
        window.rootViewController = UINavigationController.init(rootViewController: destinationVC)
        window.makeKeyAndVisible()
    }
    
    // MARK: Static methods
    func createModule(currency: WalletCurrency) -> UIViewController {
        let storyboard = UIStoryboard(name: "TransactionHistory", bundle: nil)
        let viewController = storyboard.instantiateViewController(viewControllerType:TransactionHistoryViewController.self)
        let presenter: ViewToPresenterTransactionHistoryProtocol & InteractorToPresenterTransactionHistoryProtocol = TransactionHistoryPresenter()
        
        viewController.presenter = presenter
        viewController.presenter?.router = TransactionHistoryRouter()
        viewController.presenter?.view = viewController
        viewController.presenter?.interactor = TransactionHistoryInteractor(currency: currency)
        viewController.presenter?.interactor?.presenter = presenter
        return viewController
    }
}
