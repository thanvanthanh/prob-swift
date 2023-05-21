//
//  PopupStartTradingContract.swift
//  Probit
//
//  Created by Nguyen Quang on 26/09/2022.
//  
//

import Foundation

// MARK: View Output (Presenter -> View)
protocol PresenterToViewPopupStartTradingProtocol {
   
}

// MARK: View Input (View -> Presenter)
protocol ViewToPresenterPopupStartTradingProtocol {
    var view: PresenterToViewPopupStartTradingProtocol? { get set }
    var interactor: PresenterToInteractorPopupStartTradingProtocol? { get set }
    var router: PresenterToRouterPopupStartTradingProtocol? { get set }
    var marketIds: [String] { get set }
    func gotoExchangeDetail(marketId: String)
}

// MARK: Interactor Input (Presenter -> Interactor)
protocol PresenterToInteractorPopupStartTradingProtocol {
    var presenter: InteractorToPresenterPopupStartTradingProtocol? { get set }
}

// MARK: Interactor Output (Interactor -> Presenter)
protocol InteractorToPresenterPopupStartTradingProtocol {
}

// MARK: Router Input (Presenter -> Router)
protocol PresenterToRouterPopupStartTradingProtocol {
    func gotoExchangeDetail(marketId: String)
}
