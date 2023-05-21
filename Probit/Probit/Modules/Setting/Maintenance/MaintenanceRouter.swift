//
//  MaintenanceRouter.swift
//  Probit
//
//  Created by Bradley Hoang on 31/10/2022.
//  
//

import UIKit

class MaintenanceRouter: PresenterToRouterMaintenanceProtocol {
    func showScreen(with runtimeConfig: RuntimeConfig) {
        let destinationVC = createModule(with: runtimeConfig)
        destinationVC.getRootViewController().navigationController?.pushViewController(destinationVC, animated: true)
    }
    
    func setupRootView(with runtimeConfig: RuntimeConfig) {
        guard let appdelegate = UIApplication.shared.delegate as? AppDelegate,
              let window = appdelegate.window else { return }
        
        let destinationVC = createModule(with: runtimeConfig)
        window.rootViewController = UINavigationController.init(rootViewController: destinationVC)
        window.makeKeyAndVisible()
    }
    
    // MARK: Static methods
    func createModule(with runtimeConfig: RuntimeConfig) -> UIViewController {
        let storyboard = UIStoryboard(name: "Maintenance", bundle: nil)
        let viewController = storyboard.instantiateViewController(viewControllerType:MaintenanceViewController.self)
        
        let presenter: ViewToPresenterMaintenanceProtocol & InteractorToPresenterMaintenanceProtocol = MaintenancePresenter()
        
        viewController.presenter = presenter
        viewController.presenter?.router = MaintenanceRouter()
        viewController.presenter?.view = viewController
        viewController.presenter?.interactor = MaintenanceInteractor()
        viewController.presenter?.interactor?.presenter = presenter
        viewController.presenter?.interactor?.runtimeConfig = runtimeConfig
        
        return viewController
    }
}
