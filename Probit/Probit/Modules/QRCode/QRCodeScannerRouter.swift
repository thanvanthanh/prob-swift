
import Foundation
import UIKit

class QRCodeScannerRouter: PresenterToRouterQRCodeScannerProtocol {
    func showScreen(completion: @escaping (String) -> Void) {
        let destinationVC = self.createModule()
        destinationVC.completeScan = completion
        destinationVC.getRootTabbarViewController().pushViewController(destinationVC, animated: true)
    }
    
    func setupRootView() {
        guard let appdelegate = UIApplication.shared.delegate as? AppDelegate,
              let window = appdelegate.window else { return }
        
        let destinationVC = self.createModule()
        window.rootViewController = UINavigationController.init(rootViewController: destinationVC)
        window.makeKeyAndVisible()
    }
    
    func popToReview() {
        guard let currentViewController = UIViewController().getRootTabbarViewController().viewControllers.last else { return }
        currentViewController.navigationController?.popViewController(animated: true)
    }
    
    // MARK: Static methods
    func createModule() -> QRCodeScannerViewController {
        let storyboard = UIStoryboard(name: "QRCodeScanner", bundle: nil)
        let viewController = storyboard.instantiateViewController(viewControllerType:QRCodeScannerViewController.self)
        
        let presenter: ViewToPresenterQRCodeScannerProtocol & InteractorToPresenterQRCodeScannerProtocol = QRCodeScannerPresenter()
        
        viewController.presenter = presenter
        viewController.presenter?.router = QRCodeScannerRouter()
        viewController.presenter?.view = viewController
        viewController.presenter?.interactor = QRCodeScannerInteractor()
        viewController.presenter?.interactor?.presenter = presenter
        
        return viewController
    }
}
