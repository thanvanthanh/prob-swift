//
//  UploadGovermentRouter.swift
//  Probit
//
//  Created by Đào Mỹ Đông on 09/11/2565 BE.
//  
//

import Foundation
import UIKit

class UploadGovermentRouter: PresenterToRouterUploadGovermentProtocol {
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
        let storyboard = UIStoryboard(name: "UploadGoverment", bundle: nil)
        let viewController = storyboard.instantiateViewController(viewControllerType:UploadGovermentViewController.self)
        let presenter: ViewToPresenterUploadGovermentProtocol & InteractorToPresenterUploadGovermentProtocol = UploadGovermentPresenter()
        viewController.presenter = presenter
        viewController.presenter?.router = self
        viewController.presenter?.view = viewController
        viewController.presenter?.interactor = UploadGovermentInteractor()
        viewController.presenter?.interactor?.presenter = presenter
        return viewController
    }
}
