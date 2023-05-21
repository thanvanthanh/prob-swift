//
//  ExchangeOrderBookPresenter.swift
//  Probit
//
//  Created by Nguyen Quang on 17/10/2022.
//  
//

import Foundation

class ExchangeOrderBookPresenter: ViewToPresenterExchangeOrderBookProtocol {
    // MARK: Properties
    var view: PresenterToViewExchangeOrderBookProtocol?
    var interactor: PresenterToInteractorExchangeOrderBookProtocol?
    var router: PresenterToRouterExchangeOrderBookProtocol?
    
    var exchange: ExchangeTicker?

    func viewDidLoad() {
    
    }
}

extension ExchangeOrderBookPresenter: InteractorToPresenterExchangeOrderBookProtocol {
    func handerApiError() { }
    
    func getDataSuccess() {

    }
}
