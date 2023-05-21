//
//  TradingLeaderBoardPresenter.swift
//  Probit
//
//  Created by Nguyen Quang on 25/09/2022.
//  
//

import Foundation

class TradingLeaderBoardPresenter: ViewToPresenterTradingLeaderBoardProtocol {
    var title: String?
    var eventType: StakeEventType?
    // MARK: Properties
    var view: PresenterToViewTradingLeaderBoardProtocol?
    var interactor: PresenterToInteractorTradingLeaderBoardProtocol?
    var router: PresenterToRouterTradingLeaderBoardProtocol?
    var leaderboard: TradingLeaderboard? { interactor?.leaderboard }
    
    var noDataMessage: String? {
        switch eventType {
        case .END:
            return nil
        case .RUNNING:
            return "tradecompetition_nodata_list_running".Localizable()
        case .UP_COMING:
            return "tradecompetition_leaderboard_list_upcoming".Localizable()
        default:
            return nil
        }
    }
}

extension TradingLeaderBoardPresenter: InteractorToPresenterTradingLeaderBoardProtocol {
    
}
