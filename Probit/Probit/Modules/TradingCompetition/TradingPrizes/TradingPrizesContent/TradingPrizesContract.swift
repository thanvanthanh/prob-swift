//
//  TradingPrizesContract.swift
//  Probit
//
//  Created by Nguyen Quang on 23/09/2022.
//  
//

import Foundation

// MARK: View Output (Presenter -> View)
protocol PresenterToViewTradingPrizesProtocol {
   
}

// MARK: View Input (View -> Presenter)
protocol ViewToPresenterTradingPrizesProtocol {
    var view: PresenterToViewTradingPrizesProtocol? { get set }
    var interactor: PresenterToInteractorTradingPrizesProtocol? { get set }
    var router: PresenterToRouterTradingPrizesProtocol? { get set }
    var tradings: [TradingPrizeList] { get set }

}

// MARK: Interactor Input (Presenter -> Interactor)
protocol PresenterToInteractorTradingPrizesProtocol {
    var presenter: InteractorToPresenterTradingPrizesProtocol? { get set }
}

// MARK: Interactor Output (Interactor -> Presenter)
protocol InteractorToPresenterTradingPrizesProtocol {
}

// MARK: Router Input (Presenter -> Router)
protocol PresenterToRouterTradingPrizesProtocol {
}
