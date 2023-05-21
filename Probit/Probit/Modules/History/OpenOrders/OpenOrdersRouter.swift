//
//  OpenOrdersRouter.swift
//  Probit
//
//  Created by Nguyen Quang on 29/08/2022.
//  
//

import Foundation
import UIKit

enum OpenOrdersType {
    case defaults
    case bottomSheet
}

class OpenOrdersRouter: PresenterToRouterOpenOrdersProtocol {
    func showScreen(type: OpenOrdersType) {
        let destinationVC = self.createModule(type: type)
        destinationVC.getRootTabbarViewController().navigationController?.pushViewController(destinationVC, animated: true)
    }
    
    func pushScreen(type: OpenOrdersType, pair: String, delegate: OpenOrdersDelegate? = nil) {
        let destinationVC = self.createModule(type: type, pair: pair, delegate: delegate)
        let controller = UINavigationController(rootViewController: destinationVC)
        controller.modalPresentationStyle = .overFullScreen
        destinationVC.getRootTabbarViewController().present(controller, animated: true)
    }
    
    func setupRootView(type: OpenOrdersType) {
        guard let appdelegate = UIApplication.shared.delegate as? AppDelegate,
              let window = appdelegate.window else { return }
        
        let destinationVC = self.createModule(type: type)
        window.rootViewController = UINavigationController.init(rootViewController: destinationVC)
        window.makeKeyAndVisible()
    }
    
    // MARK: Static methods
    func createModule(type: OpenOrdersType, pair: String? = nil, delegate: OpenOrdersDelegate? = nil) -> UIViewController {
        let storyboard = UIStoryboard(name: "OpenOrders", bundle: nil)
        let viewController = storyboard.instantiateViewController(viewControllerType:OpenOrdersViewController.self)
        
        let presenter: ViewToPresenterOpenOrdersProtocol & InteractorToPresenterOpenOrdersProtocol = OpenOrdersPresenter()
        viewController.presenter = presenter
        viewController.presenter?.router = self
        viewController.presenter?.view = viewController
        viewController.presenter?.interactor = OpenOrdersInteractor()
        viewController.presenter?.interactor?.presenter = presenter
        viewController.presenter?.interactor?.pair = pair
        viewController.presenter?.screenType = type
        viewController.presenter?.delegate = delegate
        
        return viewController
    }
}
