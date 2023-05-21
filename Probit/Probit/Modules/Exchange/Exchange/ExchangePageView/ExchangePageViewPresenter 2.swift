//
//  ExchangePageViewPresenter.swift
//  Probit
//
//  Created by Nguyen Quang on 26/08/2022.
//  
//

import Foundation

class ExchangePageViewPresenter: ViewToPresenterExchangePageViewProtocol {
    // MARK: Properties
    var view: PresenterToViewExchangePageViewProtocol?
    var interactor: PresenterToInteractorExchangePageViewProtocol?
    var router: PresenterToRouterExchangePageViewProtocol?
    
    func navigateToExchangeDetail(exchange: ExchangeTicker?) {
        router?.navigateToExchangeDetail(exchange: exchange)
    }
}

extension ExchangePageViewPresenter: InteractorToPresenterExchangePageViewProtocol {
    
}
