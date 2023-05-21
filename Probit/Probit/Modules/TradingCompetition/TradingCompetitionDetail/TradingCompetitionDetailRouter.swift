//
//  TradingCompetitionDetailRouter.swift
//  Probit
//
//  Created by Nguyen Quang on 22/09/2022.
//  
//

import Foundation
import UIKit

class TradingCompetitionDetailRouter: PresenterToRouterTradingCompetitionDetailProtocol {
    func showScreen(trading: Trading, title: String?) {
        let destinationVC = self.createModule(trading: trading, title: title)
        destinationVC.getRootTabbarViewController().pushViewController(destinationVC, animated: true)
    }
    
    func setupRootView() {
        guard let appdelegate = UIApplication.shared.delegate as? AppDelegate,
              let window = appdelegate.window else { return }
        
        let destinationVC = self.createModule(trading: nil, title: nil)
        window.rootViewController = UINavigationController.init(rootViewController: destinationVC)
        window.makeKeyAndVisible()
    }
    
    // MARK: Static methods
    func createModule(trading: Trading?, title: String?) -> UIViewController {
        let storyboard = UIStoryboard(name: "TradingCompetitionDetail", bundle: nil)
        let viewController = storyboard.instantiateViewController(viewControllerType:TradingCompetitionDetailViewController.self)
        
        let presenter: ViewToPresenterTradingCompetitionDetailProtocol & InteractorToPresenterTradingCompetitionDetailProtocol = TradingCompetitionDetailPresenter()
        let entity: InteractorToEntityTradingCompetitionDetailProtocol = TradingCompetitionDetailEntity()
        
        viewController.presenter = presenter
        viewController.presenter?.trading = trading
        viewController.presenter?.title = title
        viewController.presenter?.router = TradingCompetitionDetailRouter()
        viewController.presenter?.view = viewController
        let interactor = TradingCompetitionDetailInteractor()
        viewController.presenter?.interactor = interactor
        viewController.presenter?.stakeInteracter = interactor
        viewController.presenter?.interactor?.presenter = presenter
        viewController.presenter?.interactor?.entity = entity
        
        return viewController
    }
    
    func navigateToTradingPrizes(tradingDetail: TradingDetail?) {
        TradingPrizesPageRouter().showScreen(tradingDetail: tradingDetail)
    }
    
    func navigateToLeaderBoard(title: String?,
                               eventType: StakeEventType?,
                               leaderBoard: TradingLeaderboard?) {
        TradingLeaderBoardRouter().showScreen(title: title, eventType: eventType, leaderboard: leaderBoard)
    }
    
    func navigateToLogin() {
        LoginRouter().showScreen()
    }
    
    func startTrading(maketIds: [String]) {
        PopupStartTradingRouter().presentScreen(maketIds: maketIds)
    }
}
