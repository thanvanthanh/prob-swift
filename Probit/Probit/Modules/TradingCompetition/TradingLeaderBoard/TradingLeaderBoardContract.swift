//
//  TradingLeaderBoardContract.swift
//  Probit
//
//  Created by Nguyen Quang on 25/09/2022.
//  
//

import Foundation

// MARK: View Output (Presenter -> View)
protocol PresenterToViewTradingLeaderBoardProtocol {
   
}

// MARK: View Input (View -> Presenter)
protocol ViewToPresenterTradingLeaderBoardProtocol {
    var view: PresenterToViewTradingLeaderBoardProtocol? { get set }
    var interactor: PresenterToInteractorTradingLeaderBoardProtocol? { get set }
    var router: PresenterToRouterTradingLeaderBoardProtocol? { get set }
    var title: String? { get set }
    var leaderboard: TradingLeaderboard? { get }
    var eventType: StakeEventType? { get set }
    var noDataMessage: String? { get }
}

// MARK: Interactor Input (Presenter -> Interactor)
protocol PresenterToInteractorTradingLeaderBoardProtocol {
    var presenter: InteractorToPresenterTradingLeaderBoardProtocol? { get set }
    var leaderboard: TradingLeaderboard? { get set }
}

// MARK: Interactor Output (Interactor -> Presenter)
protocol InteractorToPresenterTradingLeaderBoardProtocol {
}

// MARK: Router Input (Presenter -> Router)
protocol PresenterToRouterTradingLeaderBoardProtocol {
}
