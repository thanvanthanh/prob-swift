//
//  ExchangeChartPresenter.swift
//  Probit
//
//  Created by Nguyen Quang on 13/10/2022.
//  
//

import Foundation

class ExchangeChartPresenter: ViewToPresenterExchangeChartProtocol {
    // MARK: Properties
    var view: PresenterToViewExchangeChartProtocol?
    var interactor: PresenterToInteractorExchangeChartProtocol?
    var router: PresenterToRouterExchangeChartProtocol?
}

extension ExchangeChartPresenter: InteractorToPresenterExchangeChartProtocol {
    
}
