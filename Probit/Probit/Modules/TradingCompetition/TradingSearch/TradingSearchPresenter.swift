//
//  TradingSearchPresenter.swift
//  Probit
//
//  Created by Nguyen Quang on 26/09/2022.
//  
//

import Foundation

class TradingSearchPresenter: ViewToPresenterTradingSearchProtocol {
    // MARK: Properties
    var view: PresenterToViewTradingSearchProtocol?
    var interactor: PresenterToInteractorTradingSearchProtocol?
    var router: PresenterToRouterTradingSearchProtocol?
    
    var tradings: [Trading] = []
    var tradingsAll: [Trading] = []
    
    func navigateToTradingCompetitionDetail(model: Trading) {
        router?.navigateToTradingCompetitionDetail(trading: model, title: model.eventNameEn)
    }
}

extension TradingSearchPresenter: InteractorToPresenterTradingSearchProtocol {
    
}
