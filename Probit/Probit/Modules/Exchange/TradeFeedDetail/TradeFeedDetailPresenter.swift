//
//  TradeFeedDetailPresenter.swift
//  Probit
//
//  Created by Nguyen Quang on 21/10/2022.
//  
//

import Foundation

class TradeFeedDetailPresenter: ViewToPresenterTradeFeedDetailProtocol {
    var socket: SocketService?
    // MARK: Properties
    var view: PresenterToViewTradeFeedDetailProtocol?
    var interactor: PresenterToInteractorTradeFeedDetailProtocol?
    var router: PresenterToRouterTradeFeedDetailProtocol?
    var qoeteCurrency: String?
    var subTitle: String?
    var exchange: ExchangeTicker?
    var orderBooks: [[OrderBook]] = []
    
    var orderSide: OrderSide = .BUY
    var reportTrade: ReportTrade = .limit
    
    var marketPrice: String?
    var limitPrice: String?
    var currentAmount: String?
    var currentTotal: String?
    
    var totalPrice: Double = 0.0
    var availableBalanceBaseCurrency: Double = 0.0
    var availableBalanceQuoteCurrency: Double = 0.0
    
    var userBalances: [UserBalance] { interactor?.userBalances ?? [] }
    
    func viewDidLoad() {
        self.socket = SocketService()
        socket?.connect()
        socket?.set(delegate: self)
        interactor?.getUserBalance()
        view?.hideMarket(isHidden: exchange?.baseCurrencyId == "PROB")
    }
    
    func disconnect() {
        socket?.unsubscribe(channel: .marketdata)
        socket?.closeConnection()
    }
    
    func connect() {
        guard let exchange = exchange, let marketId = exchange.id else { return }
        socket?.subcribeMarketId(channel: .marketdata,
                                filter: ["ticker",
                                         "order_books_l0",
                                         "order_books_l1",
                                         "order_books_l2",
                                         "order_books_l3",
                                         "order_books_l4",
                                         "recent_trades"],
                                marketId: marketId)
        if let qoeteCurrency = marketId.split(separator: "-").last,
           qoeteCurrency != "USDT" {
            self.qoeteCurrency = "\(qoeteCurrency)"
            socket?.subcribe(channel: .exchangeRate, filter: ["USDT"])
        }
    }
    
    func changeTabOrderSide() {
        getUserBalancesSuccess()
    }
    
    func showPopUpConfirm(orderSide: OrderSide, data: ConfirmTradeFeed) {
        router?.showPopUpConfirm(orderSide: orderSide, data: data, delegate: self)
    }
    
    func changePercentAmount(percent: AmountTotal) {
        let priceValue = reportTrade == .limit ? limitPrice : marketPrice
        
        var totalMaxValue: CGFloat = 0
        if let makerFeeRate = exchange?.makerFeeRate?.asDouble() {
            totalMaxValue = availableBalanceQuoteCurrency * (1 - (makerFeeRate/100))
        }
        guard orderSide == .BUY else {
            let amountValue = availableBalanceBaseCurrency * Double(percent.rawValue) / Double(100)
            guard let priceValue = priceValue?.doubleValue() else { return }
            let total = priceValue * amountValue

            let costPrecision = exchange?.costPrecision ?? 0
            currentTotal = total.forTrailingZero(max: costPrecision)
            
            let quantityPrecision = exchange?.quantityPrecision ?? 0
            currentAmount = amountValue.forTrailingZero(max: quantityPrecision)
            
            view?.bindingBalanceData(type: nil)
            return
        }
        let totalValue = totalMaxValue * Double(percent.rawValue) / Double(100)
        var amountValue: Double = 0.0
        guard let currentPrice = priceValue?.doubleValue(), currentPrice > 0 else {
            view?.bindingBalanceData(type: nil)
            return
        }
        amountValue = totalValue / currentPrice
        
        let costPrecision = exchange?.costPrecision ?? 0
        currentTotal = totalValue.forTrailingZero(max: costPrecision)
        
        let quantityPrecision = exchange?.quantityPrecision ?? 0
        currentAmount = amountValue.forTrailingZero(max: quantityPrecision)
        
        view?.bindingBalanceData(type: nil)
    }
    
    func changePriceValue(isEditing: Bool) {
        let priceValue = reportTrade == .limit ? limitPrice : marketPrice
        let type: TradeFeedChange? = isEditing ? .price : nil
        guard let priceValue = priceValue?.doubleValue(),
              let amountValue = currentAmount?.doubleValue() else {
            currentTotal = nil
            currentAmount = nil
            view?.bindingBalanceData(type: type)
            return
        }
        let total = priceValue * amountValue
        let costPrecision = exchange?.costPrecision ?? 0
        currentTotal = total.forTrailingZero(max: costPrecision)
        view?.bindingBalanceData(type: type)
    }
    
    func changeAmountValue() {
        let priceValue = reportTrade == .limit ? limitPrice : marketPrice
        
        guard let priceValue = priceValue?.doubleValue(),
              let amountValue = currentAmount?.doubleValue() else {
            currentTotal = nil
            view?.bindingBalanceData(type: .amount)
            return
        }
        if amountValue <= 0 {
            currentTotal = nil
            view?.bindingBalanceData(type: .amount)
            return
        }
        let total = priceValue * amountValue
        let costPrecision = exchange?.costPrecision ?? 0
        currentTotal = total.forTrailingZero(max: costPrecision)
        view?.bindingBalanceData(type: .amount)
    }
    
    func changeTotalValue() {
        let priceValue = reportTrade == .limit ? limitPrice : marketPrice
        guard let totalValue = currentTotal?.doubleValue(),
              let currentPrice = priceValue?.doubleValue() else {
            currentAmount = nil
            view?.bindingBalanceData(type: .total)
            return
        }
        
        if currentPrice <= 0 {
            currentAmount = nil
            view?.bindingBalanceData(type: .total)
            return
        }
        
        let amountValue = totalValue / currentPrice
        let quantityPrecision = exchange?.quantityPrecision ?? 0
        currentAmount = amountValue.forTrailingZero(max: quantityPrecision)
        view?.bindingBalanceData(type: .total)
    }
    
    func showOpenOrders(pair: String) {
        router?.showOpenOrders(pair: pair, delegate: self)
    }
}

extension TradeFeedDetailPresenter: OpenOrdersDelegate {
    func didCancelOrderSuccess() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            self.interactor?.getUserBalance()
        }
    }
}

extension TradeFeedDetailPresenter: InteractorToPresenterTradeFeedDetailProtocol {
    func newOfferComplete() {
        view?.showSuccess(message: "alert_order_success".Localizable())
        view?.newOfferComplete()
        interactor?.getUserBalance()
    }
    
    func handerApiError(error: ServiceError) {
        view?.showError(error: error)
    }

    func getUserBalancesSuccess() {
        guard let currentId = exchange?.baseCurrencyId,
              let quoteCurrencyId = exchange?.quoteCurrencyId else { return }
        let costPrecision = exchange?.costPrecision ?? 0
        let quantityPrecision = exchange?.quantityPrecision ?? 0
        
        let priceBaseCurrency = userBalances
            .first(where: { $0.currencyID == currentId })?.available.doubleValue() ?? 0.0
        let priceQuoteCurrency = userBalances
            .first(where: { $0.currencyID == quoteCurrencyId })?.available.doubleValue() ?? 0.0
        
        availableBalanceQuoteCurrency = priceQuoteCurrency.forTrailingZero(max: costPrecision).doubleValue() ?? 0.0
        availableBalanceBaseCurrency = priceBaseCurrency.forTrailingZero(max: quantityPrecision).doubleValue() ?? 0.0
        
        if orderSide == .BUY {
            view?.updateAvailablebalance(total: "\(availableBalanceQuoteCurrency.string) \(quoteCurrencyId)")
            changePriceValue(isEditing: false)
        } else {
            view?.updateAvailablebalance(total: "\(availableBalanceBaseCurrency.string) \(currentId)")
            changePriceValue(isEditing: false)
        }
    }
}

extension TradeFeedDetailPresenter: ConfirmTradeFeedProtocol {
    func buyAction(limitPrice: String?, marketId: String, quantity: String) {
        guard let exchange = exchange,
              let baseCurrencyId = exchange.baseCurrencyId,
              let quoteCurrencyId = exchange.quoteCurrencyId else { return }
        
        interactor?.newOrder(limitPrice: limitPrice,
                             marketId: "\(baseCurrencyId)-\(quoteCurrencyId)",
                             quantity: quantity, side: .BUY, type: reportTrade)
    }
    
    func sellAction(limitPrice: String?, marketId: String, quantity: String) {
        guard let exchange = exchange,
              let baseCurrencyId = exchange.baseCurrencyId,
              let quoteCurrencyId = exchange.quoteCurrencyId else { return }
        
        interactor?.newOrder(limitPrice: limitPrice,
                             marketId: "\(baseCurrencyId)-\(quoteCurrencyId)",
                             quantity: quantity, side: .SELL, type: reportTrade)
    }
}

extension TradeFeedDetailPresenter: SocketServiceDelegate {
    func onSocketReciever(text: String) {
        guard let data = text.data(using: .utf8, allowLossyConversion: false) else { return }
        if let marketData = try? JSONDecoder().decode(MarketData.self, from: data) {
            DispatchQueue.main.async { [weak self] in
                guard let `self` = self else { return }
                self.bindingData(marketData: marketData)
            }
        }
        
        if let exchangeRate = try? JSONDecoder().decode(ExchangeRate.self, from: data) {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                if let qoeteCurrency = self.qoeteCurrency, let usdtRate = exchangeRate.data.usdt.first(where: {$0.currencyID == qoeteCurrency}) {
                    if let quoteRate = self.exchange?.quoteRate.doubleValue(),
                       let usdtRate = usdtRate.rate.doubleValue() {
                        self.view?.updateUsdtRate(usdtRate: (quoteRate * usdtRate).fractionDigits(min: 2, max: 8))
                    } else {
                        self.view?.updateUsdtRate(usdtRate: "")
                    }
                }
            }
        }
    }
    
    func bindingData(marketData: MarketData) {
        let response = marketData.recentTrades?.reversed() ?? []
        view?.updateCurrentPrice(model: response.first)
        
        if let ticker = marketData.ticker {
            let exchangeTicker = ExchangeTicker()
            exchangeTicker.mapping(withTicker: ticker)
            exchangeTicker.id = marketData.marketId
            view?.updateExchangeData(ticker: exchangeTicker)
            
            marketPrice = ticker.last
        }
        
        view?.updateOrderBookData(data: marketData)
    }
    
    func onSocketConnected() {
        self.connect()
    }
    
    func viabilityChanged(_ viability: Bool) {
        if viability {
            self.connect()
        }
    }
}

enum TradeFeedChange {
    case price
    case amount
    case total
}
