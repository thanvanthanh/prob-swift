//
//  ExchangeTradeFeedPresenter.swift
//  Probit
//
//  Created by Nguyen Quang on 17/10/2022.
//  
//

import Foundation

class ExchangeTradeFeedPresenter: ViewToPresenterExchangeTradeFeedProtocol {
    // MARK: Properties
    var view: PresenterToViewExchangeTradeFeedProtocol?
    var interactor: PresenterToInteractorExchangeTradeFeedProtocol?
    var router: PresenterToRouterExchangeTradeFeedProtocol?
    var exchange: ExchangeTicker?
    
    func viewDidLoad() {
        
    }
}

extension ExchangeTradeFeedPresenter: InteractorToPresenterExchangeTradeFeedProtocol {
    
}
