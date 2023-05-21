//
//  SearchExchangeContract.swift
//  Probit
//
//  Created by Nguyen Quang on 16/10/2022.
//  
//

import Foundation

// MARK: View Output (Presenter -> View)
protocol PresenterToViewSearchExchangeProtocol: BaseViewProtocol {
    func bindData(indexPaths: [Int], exchangeRate: ExchangeRate?, marketData: MarketData?)
    func showFilteredCoins(_ coins: [ExchangeTicker])
    func setSearchBar(_ text: String)
}

// MARK: View Input (View -> Presenter)
protocol ViewToPresenterSearchExchangeProtocol {
    var view: PresenterToViewSearchExchangeProtocol? { get set }
    var interactor: PresenterToInteractorSearchExchangeProtocol? { get set }
    var router: PresenterToRouterSearchExchangeProtocol? { get set }
    var coins: [ExchangeTicker] { get }
    var keyword: String { get }
    
    func viewDidLoad()
    func connect()
    func disconnect()
    func navigateToExchangeDetail(exchange: ExchangeTicker?)
    func searchBarDidChange(text: String)
}

// MARK: Interactor Input (Presenter -> Interactor)
protocol PresenterToInteractorSearchExchangeProtocol {
    var presenter: InteractorToPresenterSearchExchangeProtocol? { get set }
    var coins: [ExchangeTicker] { get set }
    var keyword: String { get set }
    
    func getDataIfNeeded()
}

// MARK: Interactor Output (Interactor -> Presenter)
protocol InteractorToPresenterSearchExchangeProtocol {
    func hideLoading()
    func showLoading()
    func showError(error: ServiceError)
    func getDataSuccess()
}

// MARK: Router Input (Presenter -> Router)
protocol PresenterToRouterSearchExchangeProtocol {
    func navigateToExchangeDetail(exchange: ExchangeTicker?)
}
