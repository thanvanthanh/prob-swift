//
//  AirdropsCollectionPageRouter.swift
//  Probit
//
//  Created by Đào Mỹ Đông on 26/12/2565 BE.
//  
//

import Foundation
import UIKit

class AirdropsCollectionPageRouter: PresenterToRouterAirdropsCollectionPageProtocol {
    var request: AirdropListRequestModel
    init(request: AirdropListRequestModel) {
        self.request = request
    }
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
        let storyboard = UIStoryboard(name: "AirdropsCollectionPage", bundle: nil)
        let viewController = storyboard.instantiateViewController(viewControllerType:AirdropsCollectionPageViewController.self)
        
        let presenter: ViewToPresenterAirdropsCollectionPageProtocol & InteractorToPresenterAirdropsCollectionPageProtocol = AirdropsCollectionPagePresenter()
        
        viewController.presenter = presenter
        viewController.presenter?.router = self
        viewController.presenter?.view = viewController
        viewController.presenter?.interactor = AirdropsCollectionPageInteractor(request: request)
        viewController.presenter?.interactor?.presenter = presenter
        
        return viewController
    }
}
