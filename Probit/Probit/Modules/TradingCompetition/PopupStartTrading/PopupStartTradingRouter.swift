//
//  PopupStartTradingRouter.swift
//  Probit
//
//  Created by Nguyen Quang on 26/09/2022.
//  
//

import Foundation
import UIKit

class PopupStartTradingRouter: PresenterToRouterPopupStartTradingProtocol {
    func showScreen() {
        let destinationVC = self.createModule()
        destinationVC.getRootViewController().navigationController?.pushViewController(destinationVC, animated: true)
    }
    
    func presentScreen(maketIds: [String]) {
        let destinationVC = self.createModule(maketIds: maketIds)
        let navigationController = UINavigationController(rootViewController: destinationVC)
        navigationController.modalPresentationStyle = .overFullScreen
        navigationController.modalTransitionStyle = .crossDissolve
        destinationVC.getRootTabbarViewController().present(navigationController, animated: true)
    }
    
    func setupRootView() {
        guard let appdelegate = UIApplication.shared.delegate as? AppDelegate,
              let window = appdelegate.window else { return }
        
        let destinationVC = self.createModule()
        window.rootViewController = UINavigationController.init(rootViewController: destinationVC)
        window.makeKeyAndVisible()
    }
    
    // MARK: Static methods
    func createModule(maketIds: [String] = []) -> UIViewController {
        let storyboard = UIStoryboard(name: "PopupStartTrading", bundle: nil)
        let viewController = storyboard.instantiateViewController(viewControllerType:PopupStartTradingViewController.self)
        
        let presenter: ViewToPresenterPopupStartTradingProtocol & InteractorToPresenterPopupStartTradingProtocol = PopupStartTradingPresenter()
        
        viewController.presenter = presenter
        viewController.presenter?.marketIds = maketIds
        viewController.presenter?.router = PopupStartTradingRouter()
        viewController.presenter?.view = viewController
        viewController.presenter?.interactor = PopupStartTradingInteractor()
        viewController.presenter?.interactor?.presenter = presenter
        
        return viewController
    }
    
    func gotoExchangeDetail(marketId: String) {
        let lastViewController = UIViewController().getRootTabbarViewController().viewControllers.last
        lastViewController?.dismiss(animated: false, completion: {
            ExchangeDetailRouter().showScreen(exchangeId: marketId)
        })
    }
}
