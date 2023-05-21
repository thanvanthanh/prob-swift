//
//  ConfirmTradeFeedContract.swift
//  Probit
//
//  Created by Nguyen Quang on 25/10/2022.
//  
//

import Foundation

// MARK: View Output (Presenter -> View)
protocol PresenterToViewConfirmTradeFeedProtocol {
   
}

// MARK: View Input (View -> Presenter)
protocol ViewToPresenterConfirmTradeFeedProtocol {
    var view: PresenterToViewConfirmTradeFeedProtocol? { get set }
    var interactor: PresenterToInteractorConfirmTradeFeedProtocol? { get set }
    var router: PresenterToRouterConfirmTradeFeedProtocol? { get set }
    
    var orderSide: OrderSide? { get set }
    var marketId: String? { get set }
    var orderPrice: String? { get set }
    var orderAmount: String? { get set }
    var totalOrder: String? { get set }
    
    func buyAction()
    func sellAction()
}

// MARK: Interactor Input (Presenter -> Interactor)
protocol PresenterToInteractorConfirmTradeFeedProtocol {
    var presenter: InteractorToPresenterConfirmTradeFeedProtocol? { get set }
}

// MARK: Interactor Output (Interactor -> Presenter)
protocol InteractorToPresenterConfirmTradeFeedProtocol {
}

// MARK: Router Input (Presenter -> Router)
protocol PresenterToRouterConfirmTradeFeedProtocol {
}
