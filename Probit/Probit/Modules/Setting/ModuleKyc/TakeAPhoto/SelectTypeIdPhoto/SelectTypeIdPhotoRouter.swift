//
//  SelectTypeIdPhotoRouter.swift
//  Probit
//
//  Created by Đào Mỹ Đông on 08/11/2565 BE.
//  
//

import Foundation
import UIKit

class SelectTypeIdPhotoRouter: PresenterToRouterSelectTypeIdPhotoProtocol {
    func showScreen() {
        let destinationVC = self.createModule()
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
        let storyboard = UIStoryboard(name: "SelectTypeIdPhoto", bundle: nil)
        let viewController = storyboard.instantiateViewController(viewControllerType:SelectTypeIdPhotoViewController.self)
        
        let presenter: ViewToPresenterSelectTypeIdPhotoProtocol & InteractorToPresenterSelectTypeIdPhotoProtocol = SelectTypeIdPhotoPresenter()
        
        viewController.presenter = presenter
        viewController.presenter?.router = SelectTypeIdPhotoRouter()
        viewController.presenter?.view = viewController
        viewController.presenter?.interactor = SelectTypeIdPhotoInteractor()
        viewController.presenter?.interactor?.presenter = presenter
        
        return viewController
    }
}
