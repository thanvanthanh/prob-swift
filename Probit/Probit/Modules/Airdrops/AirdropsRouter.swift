//
//  AirdropsRouter.swift
//  Probit
//
//  Created by Đào Mỹ Đông on 26/12/2565 BE.
//  
//

import Foundation
import UIKit

class AirdropsRouter: PresenterToRouterAirdropsProtocol {
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
        let storyboard = UIStoryboard(name: "Airdrops", bundle: nil)
        let viewController = storyboard.instantiateViewController(viewControllerType:AirdropsViewController.self)
        
        let presenter: ViewToPresenterAirdropsProtocol & InteractorToPresenterAirdropsProtocol = AirdropsPresenter()
        
        viewController.presenter = presenter
        viewController.presenter?.router = AirdropsRouter()
        viewController.presenter?.view = viewController
        viewController.presenter?.interactor = AirdropsInteractor()
        viewController.presenter?.interactor?.presenter = presenter
        
        return viewController
    }
}
