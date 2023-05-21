//
//  SearchExchangeInteractor.swift
//  Probit
//
//  Created by Nguyen Quang on 16/10/2022.
//  
//

import Foundation

class SearchExchangeInteractor: PresenterToInteractorSearchExchangeProtocol {
    
    // MARK: - Private Variable
    private var productService = GatewayApiProductService()
    private var getTicker: GetTickerAction!
    private var getMarket: GetMarketAction!
    var getMarketInfor: GetMarketInfoAction!
    private var getCurrencyWithPlatform: GetCurrencyWithPlatformAction!
    private var markets: [Market] = []
    private var currency: [Currency] = []
    
    
    // MARK: Properties
    var presenter: InteractorToPresenterSearchExchangeProtocol?
    
    var coins: [ExchangeTicker] = []
    var marketsInfo: [MarketInfo] = []
    var keyword: String = ""
    
    // MARK: - Lifecycle
    init() {
        getTicker = GetTickerAction(dataSource: productService)
        getMarket = GetMarketAction(serviceType: "", dataSource: productService)
        getMarketInfor = GetMarketInfoAction(serviceType: "", dataSource: productService)
        getCurrencyWithPlatform = GetCurrencyWithPlatformAction(dataSource: productService)
    }
    
    func getDataIfNeeded() {
        guard coins.isEmpty else { return }
        presenter?.showLoading()
        
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        getTicker.apiCall { [weak self] result in
            dispatchGroup.leave()
            guard let self = self else { return }
            switch result {
            case .success(let res):
                res.data.forEach {
                    let exchange = ExchangeTicker()
                    exchange.mapping(withTicker: $0)
                    self.coins.append(exchange)
                }
            case .failure(let error):
                self.presenter?.showError(error: error)
            }
        }
        
        dispatchGroup.enter()
        getMarketInfor.apiCall { [weak self] result in
            dispatchGroup.leave()
            guard let self = self else { return }
            switch result {
            case .success(let response):
                self.marketsInfo = response.data.filter({$0.serviceType != .korea})
            case .failure(let error):
                print("[Error]", error.message)
            }
        }
        
        dispatchGroup.enter()
        getMarket.apiCall { [weak self] result in
            dispatchGroup.leave()
            guard let self = self else { return }
            switch result {
            case .success(let res):
                self.markets = res.data
            case .failure(let error):
                self.presenter?.showError(error: error)
            }
        }
        dispatchGroup.enter()
        getCurrencyWithPlatform.apiCall { [weak self] result in
            dispatchGroup.leave()
            guard let self = self else { return }
            switch result {
            case .success(let res):
                self.currency = res.data
            case .failure(let error):
                self.presenter?.showError(error: error)
            }
        }
        dispatchGroup.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            self.presenter?.hideLoading()
            self.coins = self.coins.filter { item in self.marketsInfo.compactMap({ $0.id}).contains(item.id) }
            self.coins.forEach { exchange in
                for market in self.markets where exchange.id == market.id {
                    exchange.mapping(withMarket: market)
                }
                exchange.mapping(withCurrencies: self.currency)
            }
            self.coins.sort { $0.quoteVolume.value.asDouble() > $1.quoteVolume.value.asDouble() }
            self.presenter?.getDataSuccess()
        }
    }
}
