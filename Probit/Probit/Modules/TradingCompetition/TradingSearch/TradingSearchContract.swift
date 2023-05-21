//
//  TradingSearchContract.swift
//  Probit
//
//  Created by Nguyen Quang on 26/09/2022.
//  
//

import Foundation

// MARK: View Output (Presenter -> View)
protocol PresenterToViewTradingSearchProtocol {
   
}

// MARK: View Input (View -> Presenter)
protocol ViewToPresenterTradingSearchProtocol {
    var view: PresenterToViewTradingSearchProtocol? { get set }
    var interactor: PresenterToInteractorTradingSearchProtocol? { get set }
    var router: PresenterToRouterTradingSearchProtocol? { get set }
    var tradings: [Trading] { get set }
    var tradingsAll: [Trading] { get set }
    func navigateToTradingCompetitionDetail(model: Trading)
}

// MARK: Interactor Input (Presenter -> Interactor)
protocol PresenterToInteractorTradingSearchProtocol {
    var presenter: InteractorToPresenterTradingSearchProtocol? { get set }
}

// MARK: Interactor Output (Interactor -> Presenter)
protocol InteractorToPresenterTradingSearchProtocol {
}

// MARK: Router Input (Presenter -> Router)
protocol PresenterToRouterTradingSearchProtocol {
    func navigateToTradingCompetitionDetail(trading: Trading, title: String?)
}
