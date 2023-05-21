//
//  ExchangeTradeFeedContract.swift
//  Probit
//
//  Created by Nguyen Quang on 17/10/2022.
//  
//

import Foundation

// MARK: View Output (Presenter -> View)
protocol PresenterToViewExchangeTradeFeedProtocol {
   
}

// MARK: View Input (View -> Presenter)
protocol ViewToPresenterExchangeTradeFeedProtocol {
    var view: PresenterToViewExchangeTradeFeedProtocol? { get set }
    var interactor: PresenterToInteractorExchangeTradeFeedProtocol? { get set }
    var router: PresenterToRouterExchangeTradeFeedProtocol? { get set }
    var exchange: ExchangeTicker? { get set }
    
    func viewDidLoad()
}

// MARK: Interactor Input (Presenter -> Interactor)
protocol PresenterToInteractorExchangeTradeFeedProtocol {
    var presenter: InteractorToPresenterExchangeTradeFeedProtocol? { get set }
}

// MARK: Interactor Output (Interactor -> Presenter)
protocol InteractorToPresenterExchangeTradeFeedProtocol {
}

// MARK: Router Input (Presenter -> Router)
protocol PresenterToRouterExchangeTradeFeedProtocol {
}
