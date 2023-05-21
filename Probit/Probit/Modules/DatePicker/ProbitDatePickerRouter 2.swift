
import Foundation
import UIKit

class ProbitDatePickerRouter: PresenterToRouterProbitDatePickerProtocol {
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
        let storyboard = UIStoryboard(name: "ProbitDatePicker", bundle: nil)
        let viewController = storyboard.instantiateViewController(viewControllerType:ProbitDatePickerViewController.self)
        
        let presenter: ViewToPresenterProbitDatePickerProtocol & InteractorToPresenterProbitDatePickerProtocol = ProbitDatePickerPresenter()
        
        viewController.presenter = presenter
        viewController.presenter?.router = ProbitDatePickerRouter()
        viewController.presenter?.view = viewController
        viewController.presenter?.interactor = ProbitDatePickerInteractor()
        viewController.presenter?.interactor?.presenter = presenter
        
        return viewController
    }
}
