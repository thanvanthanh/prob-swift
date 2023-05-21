//
//  TradingPrizesPageRouter.swift
//  Probit
//
//  Created by Nguyen Quang on 04/10/2022.
//  
//

import Foundation
import UIKit

class TradingPrizesPageRouter: PresenterToRouterTradingPrizesPageProtocol {
    func showScreen(tradingDetail: TradingDetail?) {
        let destinationVC = self.createModule(tradingDetail: tradingDetail)
        destinationVC.getRootTabbarViewController().push(viewController: destinationVC)
    }
    
    func setupRootView() {
        guard let appdelegate = UIApplication.shared.delegate as? AppDelegate,
              let window = appdelegate.window else { return }
        
        let destinationVC = self.createModule(tradingDetail: nil)
        window.rootViewController = UINavigationController.init(rootViewController: destinationVC)
        window.makeKeyAndVisible()
    }
    
    // MARK: Static methods
    func createModule(tradingDetail: TradingDetail?) -> UIViewController {
        let storyboard = UIStoryboard(name: "TradingPrizesPage", bundle: nil)
        let viewController = storyboard.instantiateViewController(viewControllerType:TradingPrizesPageViewController.self)
        
        let presenter: ViewToPresenterTradingPrizesPageProtocol & InteractorToPresenterTradingPrizesPageProtocol = TradingPrizesPagePresenter()
        
        viewController.presenter = presenter
        viewController.presenter?.tradingDetail = tradingDetail
        viewController.presenter?.router = TradingPrizesPageRouter()
        viewController.presenter?.view = viewController
        viewController.presenter?.interactor = TradingPrizesPageInteractor()
        viewController.presenter?.interactor?.presenter = presenter
        
        return viewController
    }
}
