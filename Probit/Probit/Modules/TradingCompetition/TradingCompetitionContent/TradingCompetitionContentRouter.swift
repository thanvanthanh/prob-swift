//
//  TradingCompetitionContentRouter.swift
//  Probit
//
//  Created by Nguyen Quang on 22/09/2022.
//  
//

import Foundation
import UIKit

class TradingCompetitionContentRouter: PresenterToRouterTradingCompetitionContentProtocol {
    func showScreen() {
        let destinationVC = self.createModule(tradings: [])
        destinationVC.getRootViewController().navigationController?.pushViewController(destinationVC, animated: true)
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
        let storyboard = UIStoryboard(name: "TradingCompetitionContent", bundle: nil)
        let viewController = storyboard.instantiateViewController(viewControllerType:TradingCompetitionContentViewController.self)
        
        let presenter: ViewToPresenterTradingCompetitionContentProtocol & InteractorToPresenterTradingCompetitionContentProtocol = TradingCompetitionContentPresenter()
        
        viewController.presenter = presenter
        viewController.presenter?.tradings = tradings
        viewController.presenter?.router = TradingCompetitionContentRouter()
        viewController.presenter?.view = viewController
        viewController.presenter?.interactor = TradingCompetitionContentInteractor()
        viewController.presenter?.interactor?.presenter = presenter
        
        return viewController
    }
    
    func navigateToTradingCompetitionDetail(trading: Trading, title: String?) {
        TradingCompetitionDetailRouter().showScreen(trading: trading, title: title)
    }
}
