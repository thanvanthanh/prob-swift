//
//  ExchangeDetailPresenter.swift
//  Probit
//
//  Created by Nguyen Quang on 13/10/2022.
//  
//

import Foundation

class ExchangeDetailPresenter: ViewToPresenterExchangeDetailProtocol {
    var socket: SocketService?
    // MARK: Properties
    var view: PresenterToViewExchangeDetailProtocol?
    var interactor: PresenterToInteractorExchangeDetailProtocol?
    var router: PresenterToRouterExchangeDetailProtocol?
    var isFavorite: Bool = false
    var tradeFeeds: [RecentTrade] = []
    var menus: [MenuBar] { interactor?.menus ?? [] }
    var exchange: ExchangeTicker? { interactor?.exchange }
    var qoeteCurrency: String?
    var tradeFeedsContent: ExchangeTradeFeedViewController? {
        guard let controller = menus.last?.controller else { return nil }
        return controller as? ExchangeTradeFeedViewController
    }
    var orderBooksContent: ExchangeOrderBookViewController? {
        guard let controller = menus.first(where: { $0.name == "order_book".Localizable().capitalized })?.controller else { return nil }
        return controller as? ExchangeOrderBookViewController
    }
    
    var chartViewController: ExchangeChartViewController? {
        guard let controller = self.menus.first?.controller else { return nil }
        return controller as? ExchangeChartViewController
    }
    
    let group = DispatchGroup()
    var getMarketInfoAction: GetMarketInfoAction = GetMarketInfoAction(serviceType: "", dataSource: GatewayApiProductService())
    var marketsInfo: [MarketInfo] = []
    var membershipUser: MembershipModel? = nil
    var userKycCurrent: String?
    var kycStatusData: UserKycStatusModel? = nil
    var candleData: [[String: Any]]?
    
    func viewDidLoad() {
        self.socket = SocketService()
        socket?.connect()
        self.socket?.set(delegate: self)
        fetchData()
    }
    
    
    func updateTradingView(_ price: String?) {
        if let chartViewController = self.chartViewController {
            chartViewController.update(price)
        }
    }
    
    
    func reloadTradingView() {
        if let chartViewController = self.chartViewController {
            chartViewController.reload()
        }
    }
    
    func fetchData() {
        view?.showLoading()
        group.enter()
        getMarketInfoAction.apiCall { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let res):
                let markets = res.data.filter({$0.serviceType == .all || $0.serviceType == .global})
                self.marketsInfo = markets
            case .failure:
                break
            }
            self.group.leave()
        }
        
        group.enter()
        SettingAPI.shared.membership {[weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let success):
                self.membershipUser = success
            case .failure(let failure):
                print(failure)
            }
            self.group.leave()
        }
        
        group.enter()
        SettingAPI.shared.checkStep { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let success):
                self.userKycCurrent = success.data?.string
            case .failure(let failure):
                print(failure)
            }
            self.group.leave()
        }
        
        group.enter()
        SettingAPI.shared.userKycStatus { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                self.kycStatusData = data
            case .failure(let failure):
                print(failure)
            }
            self.group.leave()
        }
        
        group.enter()
        interactor?.getMarketInfo(completionHandler: { [weak self] in
            guard let `self` = self else { return }
            self.group.leave()
        })
        
        group.notify(queue: DispatchQueue.global()) {
            DispatchQueue.main.async {
                self.view?.hideLoading()
                self.connect()
                self.updateExchangeTicker(ticker: self.exchange)
            }
        }
    }
    
    func disconnect() {
        self.socket?.unsubscribe(channel: .marketdata)
        self.socket?.unsubscribe(channel: .exchangeRate)
        socket?.closeConnection()
    }
    
    deinit {
        //        socket = nil
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
        
        if let chartViewController = menus.first?.controller as? ExchangeChartViewController {
            let filter = chartViewController.tradingView.filterValue
            socket?.subcribeMarketId(channel: .realtimeCandle, filter: [filter], marketId: marketId)
//
            chartViewController.onDidUpdateInterval = { [weak self] intervalValue in
                guard let `self` = self else { return }
                
                self.socket?.unsubscribe(channel: .realtimeCandle)

                DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 0.8) {
                    self.socket?.subcribeMarketId(channel: .realtimeCandle, filter: [intervalValue], marketId: marketId)
                }
            }
        }
    }
    
    
    func didSelectMenuItem(index: IndexPath) {
        interactor?.didSelectMenuItem(index: index)
    }
    
    func navigationLogin() {
        router?.navigationLogin()
    }
    
    func navigationStaking() {
        router?.navigationStaking()
    }
    
    func navigationKycLevel() {
        guard let model = kycStatusData else { return }
        router?.navigationKycLevel(kycStatusModel: model.data)
    }
    
    func navigationToTradeFeedDetail(orderSide: OrderSide) {
        guard let exchange = exchange else { return }
        let orderBooks = orderBooksContent?.orderBookListView.orderBooks ?? []
        router?.navigationToTradeFeedDetail(exchange: exchange, orderBooks: orderBooks, orderSide: orderSide)
    }
    
    func checkValidBuySell() {
        guard AppConstant.isAuthorization else {
            view?.requestLoginWhenBuySell()
            return
        }
        let userSuspend = AppConstant.profileInfo?.suspend?.withdrawal?.reason
        
        if userSuspend == "suspend" {
            view?.showNotiAccountSuspend()
            return
        }
        
        for info in marketsInfo where info.id == exchange?.id  {
            
            if info.kycStep.number > Int(userKycCurrent ?? "0") ?? 0 {
                view?.requestKycLevelWhenBuySell(hightLevel: info.kycStep.number)
                return
            }
            
            if info.vip.number > membershipUser?.data.membershipType?.levelNumber ?? 0 {
                view?.requestMembershipLevelWhenBuySell(hightLevel: info.vip.number)
                return
            }
        }
        view?.buySellValid()
    }
}

extension ExchangeDetailPresenter: InteractorToPresenterExchangeDetailProtocol {
    func changeStateMenuSuccess() {
        view?.reloadData()
    }
    
    func updateExchangeTicker(ticker: ExchangeTicker?) {
        guard let exchangeTicker = ticker else { return }
        view?.updateExchangeData(ticker: exchangeTicker)
    }
}

extension ExchangeDetailPresenter: SocketServiceDelegate {
    func onSocketReciever(text: String) {
        guard let data = text.data(using: .utf8, allowLossyConversion: false) else { return }
        if let marketData = try? JSONDecoder().decode(MarketData.self, from: data) {
            DispatchQueue.main.async { [weak self] in
                guard let `self` = self else { return }
                self.bindingData(marketData: marketData)
                if let ticker = marketData.ticker {
                    self.exchange?.mapping(withTicker: ticker)
                }
            }
        }
        if let candleData = try? JSONDecoder().decode(RealtimeCandle.self, from: data) {
            print("TRADINGVIEW", text)
            DispatchQueue.main.async { [weak self] in
                guard let `self` = self else { return }
                if let chartViewController = self.chartViewController,
                   let candle = candleData.data?.values.first as? CandleValueOld,
                   let dictionary = candle.dictionary {
                    guard candleData.interval == chartViewController.getIntervalTime().filterValue else {
                        return
                    }
                    chartViewController.tradingView.updateCandleFromSocket(data: [dictionary])
                }
            }
        }
        if let exchangeRate = try? JSONDecoder().decode(ExchangeRate.self, from: data) {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                if let qoeteCurrency = self.qoeteCurrency, let usdtRate = exchangeRate.data.usdt.first(where: {$0.currencyID == qoeteCurrency}) {
                    if let quoteRate = self.exchange?.quoteRate.doubleValue(),
                       let usdtRate = usdtRate.rate.doubleValue() {
                        self.view?.updateUsdtRate(usdtRate: (quoteRate * usdtRate).fractionDigits(min: 0, max: 8))
                        self.orderBooksContent?.updateUsdtRate(usdtRate:  (quoteRate * usdtRate).fractionDigits(min: 0, max: 8))
                    } else {
                        self.view?.updateUsdtRate(usdtRate: "")
                        self.orderBooksContent?.updateUsdtRate(usdtRate: "")
                    }
                }
            }
        }
    }
    
    func bindingData(marketData: MarketData) {
        let response = marketData.recentTrades?.reversed() ?? []
        self.tradeFeeds.insert(contentsOf: response, at: 0)
        self.tradeFeedsContent?.updateData(data: response)
        self.orderBooksContent?.updateCurrentPrice(model: response.first)
        
        if let ticker = marketData.ticker {
            let exchangeTicker = ExchangeTicker()
            exchangeTicker.mapping(withTicker: ticker)
            exchangeTicker.id = marketData.marketId
            view?.updateExchangeData(ticker: exchangeTicker)
        }
        
        orderBooksContent?.onListenerSocket(marketData)
    }
    
    func onSocketConnected() {
        self.connect()
    }
    
    func viabilityChanged(_ viability: Bool) {
        if viability {
            self.connect()
        }
    }
    
    private func getIntervalTime() -> String? {
        if let chartViewController = self.menus.first?.controller as? ExchangeChartViewController {
            return chartViewController.getIntervalTime().filterValue
        }
        return nil
    }
}

