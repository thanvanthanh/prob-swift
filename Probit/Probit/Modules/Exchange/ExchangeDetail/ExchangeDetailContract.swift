//
//  ExchangeDetailContract.swift
//  Probit
//
//  Created by Nguyen Quang on 13/10/2022.
//  
//

import Foundation

// MARK: View Output (Presenter -> View)
protocol PresenterToViewExchangeDetailProtocol: BaseViewProtocol {
    func reloadData()
    func updateExchangeData(ticker: ExchangeTicker)
    func updateUsdtRate(usdtRate: String)
    func requestLoginWhenBuySell()
    func requestKycLevelWhenBuySell(hightLevel: Int)
    func requestMembershipLevelWhenBuySell(hightLevel: Int)
    func showNotiAccountSuspend()
    func buySellValid()
}

// MARK: View Input (View -> Presenter)
protocol ViewToPresenterExchangeDetailProtocol {
    var view: PresenterToViewExchangeDetailProtocol? { get set }
    var interactor: PresenterToInteractorExchangeDetailProtocol? { get set }
    var router: PresenterToRouterExchangeDetailProtocol? { get set }
    
    var menus: [MenuBar] { get }
    var isFavorite: Bool { get set }
    var exchange: ExchangeTicker? { get }
    var tradeFeeds: [RecentTrade] { get set }
    
    func didSelectMenuItem(index: IndexPath)
    func connect()
    func disconnect()
    func viewDidLoad()
    func navigationLogin()
    func navigationStaking()
    func navigationKycLevel()
    func navigationToTradeFeedDetail(orderSide: OrderSide)
    func checkValidBuySell()
    func reloadTradingView()
    func updateTradingView(_ price: String?)
}

// MARK: Interactor Input (Presenter -> Interactor)
protocol PresenterToInteractorExchangeDetailProtocol {
    var presenter: InteractorToPresenterExchangeDetailProtocol? { get set }
    var menus: [MenuBar] { get set }
    var exchange: ExchangeTicker? { get set }
    var exchangeId: String? { get set }
    var entity: InteractorToEntityExchangeDetailProtocol? { get set }

    func didSelectMenuItem(index: IndexPath)
    func getMarketInfo(completionHandler: @escaping () -> ())
}

// MARK: Interactor Output (Interactor -> Presenter)
protocol InteractorToPresenterExchangeDetailProtocol {
    func changeStateMenuSuccess()
}

// MARK: Router Input (Presenter -> Router)
protocol PresenterToRouterExchangeDetailProtocol {
    func navigationLogin()
    func navigationStaking()
    func navigationKycLevel(kycStatusModel: UserKycStatusDetailModel)
    
    func navigationToTradeFeedDetail(exchange: ExchangeTicker, orderBooks: [[OrderBook]], orderSide: OrderSide)
}

protocol InteractorToEntityExchangeDetailProtocol {
    func getExchangeTicker(completionHandler: @escaping ([Ticker]) -> ())
    func getListMaket(completionHandler: @escaping ([Market]) -> ())
}
