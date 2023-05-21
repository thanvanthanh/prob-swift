//
//  TradingCompetitionRouter.swift
//  Probit
//
//  Created by Nguyen Quang on 22/09/2022.
//  
//

import Foundation
import UIKit

class TradingCompetitionRouter: PresenterToRouterTradingCompetitionProtocol {
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
        let storyboard = UIStoryboard(name: "TradingCompetition", bundle: nil)
        let viewController = storyboard.instantiateViewController(viewControllerType:TradingCompetitionViewController.self)
        
        let presenter: ViewToPresenterTradingCompetitionProtocol & InteractorToPresenterTradingCompetitionProtocol = TradingCompetitionPresenter()
        let entity: InteractorToEntityTradingCompetitionProtocol = TradingCompetitionEntity()
        
        viewController.presenter = presenter
        viewController.presenter?.router = TradingCompetitionRouter()
        viewController.presenter?.view = viewController
        viewController.presenter?.interactor = TradingCompetitionInteractor()
        viewController.presenter?.interactor?.presenter = presenter
        viewController.presenter?.interactor?.entity = entity
        
        return viewController
    }
    
    func navigateToTradingSearch(data: [Trading]) {
        TradingSearchRouter().showScreen(tradings: data)
    }
}
