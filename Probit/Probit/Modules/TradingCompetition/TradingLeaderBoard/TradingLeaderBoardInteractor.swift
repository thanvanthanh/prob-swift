//
//  TradingLeaderBoardInteractor.swift
//  Probit
//
//  Created by Nguyen Quang on 25/09/2022.
//  
//

import Foundation

class TradingLeaderBoardInteractor: PresenterToInteractorTradingLeaderBoardProtocol {
    // MARK: Properties
    var presenter: InteractorToPresenterTradingLeaderBoardProtocol?
    var leaderboard: TradingLeaderboard?
}
