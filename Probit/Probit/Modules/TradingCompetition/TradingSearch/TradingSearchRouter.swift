//
//  TradingSearchRouter.swift
//  Probit
//
//  Created by Nguyen Quang on 26/09/2022.
//  
//

import Foundation
import UIKit

class TradingSearchRouter: PresenterToRouterTradingSearchProtocol {
    func showScreen(tradings: [Trading]) {
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
    func createModule(tradings: [Trading]) -> UIViewController {
        let storyboard = UIStoryboard(name: "TradingSearch", bundle: nil)
        let viewController = storyboard.instantiateViewController(viewControllerType:TradingSearchViewController.self)
        
        let presenter: ViewToPresenterTradingSearchProtocol & InteractorToPresenterTradingSearchProtocol = TradingSearchPresenter()
        
        viewController.presenter = presenter
        viewController.presenter?.tradings = tradings
        viewController.presenter?.tradingsAll = tradings
        viewController.presenter?.router = TradingSearchRouter()
        viewController.presenter?.view = viewController
        viewController.presenter?.interactor = TradingSearchInteractor()
        viewController.presenter?.interactor?.presenter = presenter
        
        return viewController
    }
    
    func navigateToTradingCompetitionDetail(trading: Trading, title: String?) {
        TradingCompetitionDetailRouter().showScreen(trading: trading, title: title)
    }
}
