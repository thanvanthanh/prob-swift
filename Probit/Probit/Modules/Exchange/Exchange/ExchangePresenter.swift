//
//  ExchangePresenter.swift
//  Probit
//
//  Created by Nguyen Quang on 25/08/2022.
//  
//

import Foundation

class ExchangePresenter: ViewToPresenterExchangeProtocol {
    
    var count: Int = 0
    var socketService: SocketService?
    
    // MARK: Properties
    var view: PresenterToViewExchangeProtocol?
    var interactor: PresenterToInteractorExchangeProtocol?
    var router: PresenterToRouterExchangeProtocol?
    
    var listExchange: [MenuBar] { interactor?.listExchange ?? [] }
    
    var sortType: ExchangeSortType { interactor?.sortType ?? .vol }
    var sortCompare: ExchangeSortCompare { interactor?.sortCompare ?? .up }
    
    var exchanges: [ExchangeTicker] { interactor?.exchanges ?? [] }
    var usdtExchanges: [ExchangeTicker] { interactor?.usdtExchanges ?? [] }
    var btcExchanges: [ExchangeTicker] { interactor?.btcExchanges ?? [] }
    var ethExchanges: [ExchangeTicker] { interactor?.ethExchanges ?? [] }
    var defiExchanges: [ExchangeTicker] { interactor?.defiExchanges ?? [] }
    var favoriteExchanges: [ExchangeTicker] { interactor?.favoriteExchanges ?? [] }
    
    var favoriteContent: ExchangePageViewViewController? {
        guard let controller = listExchange.first(where: { $0.name == nil })?.controller else { return nil }
        return controller as? ExchangePageViewViewController
    }
    var usdtContent: ExchangePageViewViewController? {
        guard let controller = listExchange.first(where: { $0.name == "USDT" })?.controller else { return nil }
        return controller as? ExchangePageViewViewController
    }
    var btcContent: ExchangePageViewViewController? {
        guard let controller = listExchange.first(where: { $0.name == "BTC" })?.controller else { return nil }
        return controller as? ExchangePageViewViewController
    }
    var ethContent: ExchangePageViewViewController? {
        guard let controller = listExchange.first(where: { $0.name == "ETH" })?.controller else { return nil }
        return controller as? ExchangePageViewViewController
    }
    var defiContent: ExchangePageViewViewController? {
        guard let controller = listExchange.first(where: { $0.name == "DeFi" })?.controller else { return nil }
        return controller as? ExchangePageViewViewController
    }
    
    func viewDidLoad() {
        view?.showLoading()
        interactor?.getData()
    }
    
    func viewWillAppear() {
        socketService = SocketService()
        socketService?.set(delegate: self)
        socketService?.connect()
    }
    
    func disconnectSocket() {
        socketService?.unsubscribe(channel: .marketdata)
        socketService?.unsubscribe(channel: .marketdata)
        socketService?.closeConnection()
    }
    
    func subscribeSocket() {
        socketService?.subcribe(channel: .marketdata, filter: ["ticker"])
        socketService?.subcribe(channel: .exchangeRate, filter: ["USDT"])
    }
    
    func selectedExchange(index: IndexPath) {
        interactor?.selectedExchange(index: index)
    }
    
    func sortVolumeData() {
        interactor?.sortVolumeData()
    }
    
    func sortChange24HrData() {
        interactor?.sortChange24HrData()
    }
    
    func sortPriceData() {
        interactor?.sortPriceData()
    }
    
    func sortTradingPairData() {
        interactor?.sortTradingPairData()
    }
    
    func navigateToSearchExchange() {
        router?.navigateToSearchExchange(data: exchanges )
    }
    
    func bindingData(data: MarketData) {
        usdtContent?.bindingData(data: data)
        btcContent?.bindingData(data: data)
        ethContent?.bindingData(data: data)
        defiContent?.bindingData(data: data)
        favoriteContent?.bindingData(data: data)
    }
    
    func bindingRates(_ rates: [Usdt] ) {
        btcContent?.bindingRates(rates)
        ethContent?.bindingRates(rates)
        defiContent?.bindingRates(rates)
        favoriteContent?.bindingRates(rates)
    }
}

extension ExchangePresenter: InteractorToPresenterExchangeProtocol {
    func changeExchangeSuccess() {
        view?.reloadData()
    }
    
    func dataListDidFetch() {
        view?.getDataSuccess()
        view?.hideLoading()
    }
    
    func connectSocket() {
        subscribeSocket()
    }
    
}

extension ExchangePresenter: SocketServiceDelegate {
    func onSocketReciever(text: String) {
        guard let data = text.data(using: .utf8, allowLossyConversion: false) else { return }
        if let marketData = try? JSONDecoder().decode(MarketData.self, from: data) {
            count += 1
            self.interactor?.exchanges.enumerated().forEach { index, element in
                guard element.id == marketData.marketId, let ticker = marketData.ticker else { return }
                element.mapping(withTicker: ticker)
            }
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.bindingData(data: marketData)
            }
        }
        
        if let exchangeRate = try? JSONDecoder().decode(ExchangeRate.self, from: data) {
            self.interactor?.exchanges.enumerated().forEach { index, element in
                exchangeRate.data.usdt.forEach {
                    if $0.currencyID == element.quoteCurrencyId {
                        element.changeRate = Double($0.rate)
                    }
                }
            }
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.bindingRates(exchangeRate.data.usdt)
            }
        }
    }
    
    func onSocketConnected() {
        self.subscribeSocket()
    }
    
    func viabilityChanged(_ viability: Bool) {
        if viability {
            self.subscribeSocket()
        }
    }

}


