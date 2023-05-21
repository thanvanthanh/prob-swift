//
//  TradeFeedDetailContract.swift
//  Probit
//
//  Created by Nguyen Quang on 21/10/2022.
//  
//

import Foundation

// MARK: View Output (Presenter -> View)
protocol PresenterToViewTradeFeedDetailProtocol: BaseViewProtocol {
    func updateExchangeData(ticker: ExchangeTicker)
    func updateUsdtRate(usdtRate: String)
    func updateCurrentPrice(model: RecentTrade?)
    func updateOrderBookData(data: MarketData)
    func updateAvailablebalance(total: String)
    func bindingBalanceData(type: TradeFeedChange?)
    func newOfferComplete()
    func buySellAction()
    func hideMarket(isHidden: Bool)
}

// MARK: View Input (View -> Presenter)
protocol ViewToPresenterTradeFeedDetailProtocol {
    var view: PresenterToViewTradeFeedDetailProtocol? { get set }
    var interactor: PresenterToInteractorTradeFeedDetailProtocol? { get set }
    var router: PresenterToRouterTradeFeedDetailProtocol? { get set }
    
    var subTitle: String? { get set }
    var orderBooks: [[OrderBook]] { get set }
    var exchange: ExchangeTicker? { get set }
    var userBalances: [UserBalance] { get }
    
    var orderSide: OrderSide { get set }
    var reportTrade: ReportTrade { get set }
    
    var limitPrice: String? { get set }
    var marketPrice: String? { get set }
    var currentAmount: String? { get set }
    var currentTotal: String? { get set }
    
    var totalPrice: Double { get set }
    var availableBalanceBaseCurrency: Double { get set }
    var availableBalanceQuoteCurrency: Double { get set }


    func connect()
    func disconnect()
    func viewDidLoad()
    func changeTotalValue()
    func changePriceValue(isEditing: Bool)
    func changeAmountValue()
    func changePercentAmount(percent: AmountTotal)
    func changeTabOrderSide()
    func showPopUpConfirm(orderSide: OrderSide, data: ConfirmTradeFeed)
    func showOpenOrders(pair: String)
}

// MARK: Interactor Input (Presenter -> Interactor)
protocol PresenterToInteractorTradeFeedDetailProtocol {
    var userBalances: [UserBalance] { get set }
    var presenter: InteractorToPresenterTradeFeedDetailProtocol? { get set }
    var entity: InteractorToEntityTradeFeedDetailProtocol? { get set }
    
    func getUserBalance()
    func newOrder(limitPrice: String?, marketId: String,
                  quantity: String, side: OrderSide, type: ReportTrade)
}

// MARK: Interactor Output (Interactor -> Presenter)
protocol InteractorToPresenterTradeFeedDetailProtocol {
    func getUserBalancesSuccess()
    func newOfferComplete()
    func handerApiError(error: ServiceError)
}

// MARK: Router Input (Presenter -> Router)
protocol PresenterToRouterTradeFeedDetailProtocol {
    func showPopUpConfirm(orderSide: OrderSide, data: ConfirmTradeFeed, delegate: ConfirmTradeFeedProtocol?)
    func showOpenOrders(pair: String, delegate: OpenOrdersDelegate?)
}

protocol InteractorToEntityTradeFeedDetailProtocol {
    func newOrder(limitPrice: String?, marketId: String,
                  quantity: String, side: OrderSide, type: ReportTrade,
                  completionHandler: @escaping (Result<DataDTO<NewOrder>, ServiceError>) -> Void)
}
