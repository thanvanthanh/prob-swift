//
//  ExchangeOrderBookContract.swift
//  Probit
//
//  Created by Nguyen Quang on 17/10/2022.
//  
//

import Foundation

// MARK: View Output (Presenter -> View)
protocol PresenterToViewExchangeOrderBookProtocol {
    
}

// MARK: View Input (View -> Presenter)
protocol ViewToPresenterExchangeOrderBookProtocol {
    var view: PresenterToViewExchangeOrderBookProtocol? { get set }
    var interactor: PresenterToInteractorExchangeOrderBookProtocol? { get set }
    var router: PresenterToRouterExchangeOrderBookProtocol? { get set }

    var exchange: ExchangeTicker? { get set }
    
    func viewDidLoad()
}

// MARK: Interactor Input (Presenter -> Interactor)
protocol PresenterToInteractorExchangeOrderBookProtocol {
    var presenter: InteractorToPresenterExchangeOrderBookProtocol? { get set }
    var entity: InteractorToEntityExchangeOrderBookProtocol? { get set }
}

// MARK: Interactor Output (Interactor -> Presenter)
protocol InteractorToPresenterExchangeOrderBookProtocol {

}

// MARK: Router Input (Presenter -> Router)
protocol PresenterToRouterExchangeOrderBookProtocol {
}

protocol InteractorToEntityExchangeOrderBookProtocol {
    func getListOrderBook(marketId: String,
                          completionHandler: @escaping (Result<DataDTO<[OrderBook]>, ServiceError>) -> Void)
}
