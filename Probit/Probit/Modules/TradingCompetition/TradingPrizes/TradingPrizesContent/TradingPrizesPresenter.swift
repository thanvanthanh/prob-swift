//
//  TradingPrizesPresenter.swift
//  Probit
//
//  Created by Nguyen Quang on 23/09/2022.
//  
//

import Foundation

class TradingPrizesPresenter: ViewToPresenterTradingPrizesProtocol {
    var tradings: [TradingPrizeList] = []
    // MARK: Properties
    var view: PresenterToViewTradingPrizesProtocol?
    var interactor: PresenterToInteractorTradingPrizesProtocol?
    var router: PresenterToRouterTradingPrizesProtocol?
}

extension TradingPrizesPresenter: InteractorToPresenterTradingPrizesProtocol {
    
}
