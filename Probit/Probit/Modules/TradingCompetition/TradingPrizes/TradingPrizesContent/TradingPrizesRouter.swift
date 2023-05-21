//
//  TradingPrizesRouter.swift
//  Probit
//
//  Created by Nguyen Quang on 23/09/2022.
//  
//

import Foundation
import UIKit

class TradingPrizesRouter: PresenterToRouterTradingPrizesProtocol {
    func showScreen(tradings: [TradingPrizeList]) {
        let destinationVC = self.createModule(tradings: tradings)
        destinationVC.getRootTabbarViewController().pushViewController(destinationVC, animated: true)
    }
    
    func setupRootView() {
        guard let appdelegate = UIApplication.shared.delegate as? AppDelegate,
              let window = appdelegate.window else { return }
        
        let destinationVC = self.createModule(tradings: [])
        window.rootViewController = UINavigationController.init(rootViewController: destinationVC)
        window.makeKeyAndVisible()
    }
    
    // MARK: Static methods
    func createModule(tradings: [TradingPrizeList]) -> UIViewController {
        let storyboard = UIStoryboard(name: "TradingPrizes", bundle: nil)
        let viewController = storyboard.instantiateViewController(viewControllerType:TradingPrizesViewController.self)
        
        let presenter: ViewToPresenterTradingPrizesProtocol & InteractorToPresenterTradingPrizesProtocol = TradingPrizesPresenter()
        
        viewController.presenter = presenter
        viewController.presenter?.tradings = tradings
        viewController.presenter?.router = TradingPrizesRouter()
        viewController.presenter?.view = viewController
        viewController.presenter?.interactor = TradingPrizesInteractor()
        viewController.presenter?.interactor?.presenter = presenter
        
        return viewController
    }
}
