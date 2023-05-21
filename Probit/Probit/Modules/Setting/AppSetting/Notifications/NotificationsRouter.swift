//
//  NotificationsRouter.swift
//  Probit
//
//  Created by Thân Văn Thanh on 27/09/2022.
//  
//

import Foundation
import UIKit

class NotificationsRouter: PresenterToRouterNotificationsProtocol {
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
        let storyboard = UIStoryboard(name: "Notifications", bundle: nil)
        let viewController = storyboard.instantiateViewController(viewControllerType:NotificationsViewController.self)
        
        let presenter: ViewToPresenterNotificationsProtocol & InteractorToPresenterNotificationsProtocol = NotificationsPresenter()
        
        viewController.presenter = presenter
        viewController.presenter?.router = NotificationsRouter()
        viewController.presenter?.view = viewController
        viewController.presenter?.interactor = NotificationsInteractor()
        viewController.presenter?.interactor?.presenter = presenter
        
        return viewController
    }
    
    func navigateToSystemSetting() {
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }
        guard UIApplication.shared.canOpenURL(settingsUrl) else { return }
        UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
            print("Settings opened: \(success)")
        })
                
    }
}
