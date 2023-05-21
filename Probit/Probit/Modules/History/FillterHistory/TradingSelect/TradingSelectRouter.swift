//
//  TradingSelectRouter.swift
//  Probit
//
//  Created by Đào Mỹ Đông on 14/10/2565 BE.
//  
//

import Foundation
import UIKit

class TradingSelectRouter: PresenterToRouterTradingSelectProtocol {
    var tradingSelectDelegate: TradingSelectViewControllerDelegate
    var typeList: String
    init(tradingSelectDelegate: TradingSelectViewControllerDelegate,
         typeList: String) {
        self.tradingSelectDelegate = tradingSelectDelegate
        self.typeList = typeList
    }
    
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
        let storyboard = UIStoryboard(name: "TradingSelect", bundle: nil)
        let viewController = storyboard.instantiateViewController(viewControllerType:TradingSelectViewController.self)
        
        let presenter: ViewToPresenterTradingSelectProtocol & InteractorToPresenterTradingSelectProtocol = TradingSelectPresenter()
        viewController.presenter = presenter
        viewController.presenter?.router = self
        viewController.presenter?.view = viewController
        viewController.presenter?.interactor = TradingSelectInteractor(delegate: tradingSelectDelegate, typeList: typeList)
        viewController.presenter?.interactor?.presenter = presenter
        return viewController
    }
}
