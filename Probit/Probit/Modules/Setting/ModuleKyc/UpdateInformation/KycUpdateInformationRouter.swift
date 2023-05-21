//
//  KycUpdateInformationRouter.swift
//  Probit
//
//  Created by Bradley Hoang on 10/11/2022.
//  
//

import UIKit

class KycUpdateInformationRouter: PresenterToRouterKycUpdateInformationProtocol {
    
    var destinationVC: UIViewController {
        return createModule()
    }
    
    func showScreen() {
        destinationVC.getRootTabbarViewController().pushViewController(destinationVC, animated: true)
    }
    
    func setupRootView() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate,
              let window = appDelegate.window else { return }
        window.rootViewController = UINavigationController.init(rootViewController: destinationVC)
        window.makeKeyAndVisible()
    }
    
    // MARK: Static methods
    func createModule() -> UIViewController {
        let storyboard = UIStoryboard(name: "KycUpdateInformation", bundle: nil)
        let viewController = storyboard.instantiateViewController(viewControllerType:KycUpdateInformationViewController.self)
        
        let presenter: ViewToPresenterKycUpdateInformationProtocol & InteractorToPresenterKycUpdateInformationProtocol = KycUpdateInformationPresenter()
        
        viewController.presenter = presenter
        viewController.presenter?.router = self
        viewController.presenter?.view = viewController
        viewController.presenter?.interactor = KycUpdateInformationInteractor()
        viewController.presenter?.interactor?.presenter = presenter
        
        return viewController
    }
    
    func navigateComplateVC() {
        let vc = ComplateKycViewController()
        destinationVC.getRootTabbarViewController().pushViewController(vc, animated: true)
    }
}
