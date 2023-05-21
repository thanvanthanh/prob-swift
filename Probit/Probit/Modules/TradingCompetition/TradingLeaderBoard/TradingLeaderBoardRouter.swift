//
//  TradingLeaderBoardRouter.swift
//  Probit
//
//  Created by Nguyen Quang on 25/09/2022.
//  
//

import Foundation
import UIKit

class TradingLeaderBoardRouter: PresenterToRouterTradingLeaderBoardProtocol {
    func showScreen(title: String?,
                    eventType: StakeEventType? = .END,
                    leaderboard: TradingLeaderboard?) {
        let destinationVC = self.createModule(title: title,
                                              eventType: eventType,
                                              leaderboard: leaderboard)
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
    func createModule(title: String? = nil,
                      eventType: StakeEventType? = .END,
                      leaderboard: TradingLeaderboard? = nil) -> UIViewController {
        let storyboard = UIStoryboard(name: "TradingLeaderBoard", bundle: nil)
        let viewController = storyboard.instantiateViewController(viewControllerType:TradingLeaderBoardViewController.self)
        
        let presenter: ViewToPresenterTradingLeaderBoardProtocol & InteractorToPresenterTradingLeaderBoardProtocol = TradingLeaderBoardPresenter()
        
        viewController.presenter = presenter
        viewController.presenter?.title = title
        viewController.presenter?.router = TradingLeaderBoardRouter()
        viewController.presenter?.view = viewController
        viewController.presenter?.interactor = TradingLeaderBoardInteractor()
        viewController.presenter?.interactor?.presenter = presenter
        viewController.presenter?.interactor?.leaderboard = leaderboard
        viewController.presenter?.eventType = eventType
        
        return viewController
    }
}
