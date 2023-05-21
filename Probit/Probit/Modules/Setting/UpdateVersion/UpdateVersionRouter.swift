//
//  UpdateVersionRouter.swift
//  Probit
//
//  Created by Bradley Hoang on 24/10/2022.
//  
//

import UIKit

final class UpdateVersionRouter: PresenterToRouterUpdateVersionProtocol {
    func showScreen() {
        let destinationVC = createModule()
        destinationVC.modalPresentationStyle = .fullScreen
        destinationVC.getRootTabbarViewController().present(destinationVC, animated: true)
    }
    
    func setupRootView() {
        guard let appdelegate = UIApplication.shared.delegate as? AppDelegate,
              let window = appdelegate.window else { return }
        
        let destinationVC = createModule()
        window.rootViewController = UINavigationController.init(rootViewController: destinationVC)
        window.makeKeyAndVisible()
    }
    
    // MARK: Static methods
    func createModule() -> UIViewController {
        let storyboard = UIStoryboard(name: "UpdateVersion", bundle: nil)
        let viewController = storyboard.instantiateViewController(viewControllerType: UpdateVersionViewController.self)
        
        let presenter: ViewToPresenterUpdateVersionProtocol & InteractorToPresenterUpdateVersionProtocol = UpdateVersionPresenter()
        
        viewController.presenter = presenter
        viewController.presenter?.router = UpdateVersionRouter()
        viewController.presenter?.view = viewController
        viewController.presenter?.interactor = UpdateVersionInteractor()
        viewController.presenter?.interactor?.presenter = presenter
        
        return viewController
    }
}
