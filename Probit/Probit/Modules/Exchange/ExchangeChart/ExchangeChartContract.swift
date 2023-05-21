//
//  ExchangeChartContract.swift
//  Probit
//
//  Created by Nguyen Quang on 13/10/2022.
//  
//

import Foundation

// MARK: View Output (Presenter -> View)
protocol PresenterToViewExchangeChartProtocol {
   
}

// MARK: View Input (View -> Presenter)
protocol ViewToPresenterExchangeChartProtocol {
    var view: PresenterToViewExchangeChartProtocol? { get set }
    var interactor: PresenterToInteractorExchangeChartProtocol? { get set }
    var router: PresenterToRouterExchangeChartProtocol? { get set }
}

// MARK: Interactor Input (Presenter -> Interactor)
protocol PresenterToInteractorExchangeChartProtocol {
    var presenter: InteractorToPresenterExchangeChartProtocol? { get set }
    var exchange: ExchangeTicker? { get set }
    var marketId: String? { get set }
    var exchangId: String { get }


}

// MARK: Interactor Output (Interactor -> Presenter)
protocol InteractorToPresenterExchangeChartProtocol {
}

// MARK: Router Input (Presenter -> Router)
protocol PresenterToRouterExchangeChartProtocol {
}
