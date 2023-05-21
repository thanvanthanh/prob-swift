
import Foundation
import UIKit

class WalletRouter: PresenterToRouterWalletProtocol {
    func showScreen() {
        let destinationVC = self.createModule()
        destinationVC.getRootViewController().navigationController?.pushViewController(destinationVC, animated: true)
    }
    
    func changeSelectedTabbar() {
        let destinationVC = self.createModule()
        destinationVC.getRootTabbarViewController().tabBarController?.selectedIndex = TabBarItem.wallet.rawIndex
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
        let storyboard = UIStoryboard(name: "Wallet", bundle: nil)
        let viewController = storyboard.instantiateViewController(viewControllerType:WalletViewController.self)
        
        let presenter: ViewToPresenterWalletProtocol & InteractorToPresenterWalletProtocol = WalletPresenter()
        
        viewController.presenter = presenter
        viewController.presenter?.router = WalletRouter()
        viewController.presenter?.view = viewController
        viewController.presenter?.interactor = WalletInteractor()
        viewController.presenter?.interactor?.presenter = presenter
        
        return viewController
    }
}
