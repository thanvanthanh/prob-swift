//
//  ValidateCardRouter.swift
//  Probit
//
//  Created by Đào Mỹ Đông on 16/11/2565 BE.
//  
//

import Foundation
import UIKit

class ValidateCardRouter: PresenterToRouterValidateCardProtocol {
    
    var destinationVC: UIViewController {
        return createModule()
    }
    
    func showScreen() {
        destinationVC.getRootTabbarViewController().pushViewController(destinationVC, animated: true)
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
        let storyboard = UIStoryboard(name: "ValidateCard", bundle: nil)
        let viewController = storyboard.instantiateViewController(viewControllerType:ValidateCardViewController.self)
        
        let presenter: ViewToPresenterValidateCardProtocol & InteractorToPresenterValidateCardProtocol = ValidateCardPresenter()
        
        viewController.presenter = presenter
        viewController.presenter?.router = self
        viewController.presenter?.view = viewController
        viewController.presenter?.interactor = ValidateCardInteractor()
        viewController.presenter?.interactor?.presenter = presenter
        
        return viewController
    }
    
    func navigateComplateVC() {
        let vc = ComplateKycViewController()
        destinationVC.getRootTabbarViewController().pushViewController(vc, animated: true)
    }
}
