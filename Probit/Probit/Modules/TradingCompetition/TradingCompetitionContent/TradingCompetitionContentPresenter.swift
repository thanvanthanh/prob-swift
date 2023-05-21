//
//  TradingCompetitionContentPresenter.swift
//  Probit
//
//  Created by Nguyen Quang on 22/09/2022.
//  
//

import Foundation

class TradingCompetitionContentPresenter: ViewToPresenterTradingCompetitionContentProtocol {
    var tradings: [Trading] = []
    // MARK: Properties
    var view: PresenterToViewTradingCompetitionContentProtocol?
    var interactor: PresenterToInteractorTradingCompetitionContentProtocol?
    var router: PresenterToRouterTradingCompetitionContentProtocol?
    
    func navigateToTradingCompetitionDetail(model: Trading) {
        router?.navigateToTradingCompetitionDetail(trading: model, title: model.eventNameEn)
    }
}

extension TradingCompetitionContentPresenter: InteractorToPresenterTradingCompetitionContentProtocol {
    
}
