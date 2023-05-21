//
//  TradingZoomViewContract.swift
//  Probit
//
//  Created by Đào Mỹ Đông on 10/01/2566 BE.
//  
//

import Foundation

// MARK: View Output (Presenter -> View)
protocol PresenterToViewTradingZoomViewProtocol {
   
}

// MARK: View Input (View -> Presenter)
protocol ViewToPresenterTradingZoomViewProtocol {
    var view: PresenterToViewTradingZoomViewProtocol? { get set }
    var interactor: PresenterToInteractorTradingZoomViewProtocol? { get set }
    var router: PresenterToRouterTradingZoomViewProtocol? { get set }
}

// MARK: Interactor Input (Presenter -> Interactor)
protocol PresenterToInteractorTradingZoomViewProtocol {
    var presenter: InteractorToPresenterTradingZoomViewProtocol? { get set }
    var exchange: ExchangeTicker { get }
}

// MARK: Interactor Output (Interactor -> Presenter)
protocol InteractorToPresenterTradingZoomViewProtocol {
}

// MARK: Router Input (Presenter -> Router)
protocol PresenterToRouterTradingZoomViewProtocol {
}
