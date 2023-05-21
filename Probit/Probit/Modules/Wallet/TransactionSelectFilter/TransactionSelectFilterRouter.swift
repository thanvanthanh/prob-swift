
import Foundation
import UIKit

class TransactionSelectFilterRouter: PresenterToRouterTransactionSelectFilterProtocol {
    func showScreen() {
        let destinationVC = self.createModule()
        destinationVC.getRootViewController().navigationController?.pushViewController(destinationVC, animated: true)
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
        let storyboard = UIStoryboard(name: "TransactionSelectFilter", bundle: nil)
        let viewController = storyboard.instantiateViewController(viewControllerType:TransactionSelectFilterViewController.self)
        
        let presenter: ViewToPresenterTransactionSelectFilterProtocol & InteractorToPresenterTransactionSelectFilterProtocol = TransactionSelectFilterPresenter()
        
        viewController.presenter = presenter
        viewController.presenter?.router = TransactionSelectFilterRouter()
        viewController.presenter?.view = viewController
        viewController.presenter?.interactor = TransactionSelectFilterInteractor()
        viewController.presenter?.interactor?.presenter = presenter
        
        return viewController
    }
}
