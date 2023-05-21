//
//  ExchangePageViewContract.swift
//  Probit
//
//  Created by Nguyen Quang on 26/08/2022.
//  
//

import Foundation

// MARK: View Output (Presenter -> View)
protocol PresenterToViewExchangePageViewProtocol {
   
}

// MARK: View Input (View -> Presenter)
protocol ViewToPresenterExchangePageViewProtocol {
    var view: PresenterToViewExchangePageViewProtocol? { get set }
    var interactor: PresenterToInteractorExchangePageViewProtocol? { get set }
    var router: PresenterToRouterExchangePageViewProtocol? { get set }
    
    func navigateToExchangeDetail(exchange: ExchangeTicker?)
}

// MARK: Interactor Input (Presenter -> Interactor)
protocol PresenterToInteractorExchangePageViewProtocol {
    var presenter: InteractorToPresenterExchangePageViewProtocol? { get set }
}

// MARK: Interactor Output (Interactor -> Presenter)
protocol InteractorToPresenterExchangePageViewProtocol {
}

// MARK: Router Input (Presenter -> Router)
protocol PresenterToRouterExchangePageViewProtocol {
    func navigateToExchangeDetail(exchange: ExchangeTicker?)
}
