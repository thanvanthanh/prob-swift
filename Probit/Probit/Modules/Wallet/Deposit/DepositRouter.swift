
import Foundation
import UIKit

class DepositRouter: PresenterToRouterDepositProtocol {
    var walletCurrency: WalletCurrency
    func showScreen() {
        let destinationVC = self.createModule()
        destinationVC.getRootTabbarViewController().pushViewController(destinationVC, animated: true)
    }
    
    init(walletCurrency: WalletCurrency) {
        self.walletCurrency = walletCurrency
    }
    
    func setupRootView() {
        guard let appdelegate = UIApplication.shared.delegate as? AppDelegate,
              let window = appdelegate.window else { return }
        
        let destinationVC = self.createModule()
        window.rootViewController = UINavigationController.init(rootViewController: destinationVC)
        window.makeKeyAndVisible()
    }
    
    // MARK: Static methods
    func createModule() -> UIViewController {
        let storyboard = UIStoryboard(name: "Deposit", bundle: nil)
        let viewController = storyboard.instantiateViewController(viewControllerType:DepositViewController.self)
        
        let presenter: ViewToPresenterDepositProtocol & InteractorToPresenterDepositProtocol = DepositPresenter()
        
        viewController.presenter = presenter
        viewController.presenter?.router = self
        viewController.presenter?.view = viewController
        viewController.presenter?.interactor = DepositInteractor(walletCurrency: walletCurrency)
        viewController.presenter?.interactor?.presenter = presenter
        
        return viewController
    }
}
