//
//  TakePhotoGuideRouter.swift
//  Probit
//
//  Created by Đào Mỹ Đông on 08/11/2565 BE.
//  
//

import Foundation
import UIKit

class TakePhotoGuideRouter: PresenterToRouterTakePhotoGuideProtocol {
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
        let storyboard = UIStoryboard(name: "TakePhotoGuide", bundle: nil)
        let viewController = storyboard.instantiateViewController(viewControllerType:TakePhotoGuideViewController.self)
        
        let presenter: ViewToPresenterTakePhotoGuideProtocol & InteractorToPresenterTakePhotoGuideProtocol = TakePhotoGuidePresenter()
        
        viewController.presenter = presenter
        viewController.presenter?.router = TakePhotoGuideRouter()
        viewController.presenter?.view = viewController
        viewController.presenter?.interactor = TakePhotoGuideInteractor()
        viewController.presenter?.interactor?.presenter = presenter
        
        return viewController
    }
}
