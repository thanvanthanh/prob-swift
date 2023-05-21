//
//  ExchangeDetailInteractor.swift
//  Probit
//
//  Created by Nguyen Quang on 13/10/2022.
//  
//

import Foundation

class ExchangeDetailInteractor: PresenterToInteractorExchangeDetailProtocol {
    // MARK: Properties
    var presenter: InteractorToPresenterExchangeDetailProtocol?
    var entity: InteractorToEntityExchangeDetailProtocol?
    
    var productService = GatewayApiProductService()
    var getCurrencyWithPlatform: GetCurrencyWithPlatformAction
    var getMarket: GetMarketAction
    var getTicker: GetTickerAction
    
    var menus: [MenuBar] = []
    var exchange: ExchangeTicker?
    var exchangeId: String?
    
    var markets: [Market] = []
    var currency: [Currency] = []
    var exchanges: [ExchangeTicker] = []
    
    init(exchange: ExchangeTicker?, exchangeId: String?) {
        self.exchange = exchange
        self.exchangeId = exchangeId
        self.menus = [
            MenuBar(name: "activity_marketdetailsv2_tab_title".Localizable(), icon: nil,
                    controller: ExchangeChartRouter().createModule(marketId: exchangeId, exchange: exchange),
                    isSelected: true),
            MenuBar(name: "order_book".Localizable().capitalized,
                    icon: nil,
                    controller: ExchangeOrderBookRouter().createModule(exchange: exchange)),
            MenuBar(name: "title_tradefeed".Localizable().capitalized,
                    icon: nil,
                    controller: ExchangeTradeFeedRouter().createModule(exchange: exchange))
        ]
        getTicker = .init(dataSource: productService)
        getMarket = .init(serviceType: "", dataSource: productService)
        getCurrencyWithPlatform = .init(dataSource: productService)
    }
    
    func didSelectMenuItem(index: IndexPath) {
        menus.enumerated().forEach { (i, _) in
            menus[i].isSelected = false
        }
        menus[index.row].isSelected = true
        presenter?.changeStateMenuSuccess()
    }
    
    func getMarketInfo(completionHandler: @escaping () -> ()) {
        guard exchange == nil else {
            getExchangeTicker { completionHandler() }
            return
        }
        getExchangeInfo { completionHandler() }
    }
    
    func getExchangeInfo(completionHandler: @escaping () -> ()) {
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
                    self.exchanges.append(exchange)
                }
            case .failure(let error):
                print(error.localizedDescription)
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
                print(error.localizedDescription)
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
                print(error.localizedDescription)
            }
        }
        dispatchGroup.notify(queue: .main, execute: { [weak self] in
            guard let `self` = self else { return }
            self.exchanges.forEach { exchange in
                for market in self.markets where exchange.id == market.id {
                    exchange.mapping(withMarket: market)
                }
                exchange.mapping(withCurrencies: self.currency)
            }
            
            let currentExchange = self.exchanges.first(where: {
                $0.id == self.exchangeId
            })
            self.exchange = currentExchange
            completionHandler()
        })
    }
    
    
    func getExchangeTicker(completionHandler: @escaping () -> ()) {
        entity?.getExchangeTicker(completionHandler: { [weak self] tickers in
            guard let `self` = self else { return }
            guard let exchangeTicker = tickers
                .first(where: {$0.marketId == self.exchange?.id}) else {
                completionHandler()
                return
            }
            self.exchange?.mapping(withTicker: exchangeTicker)
            completionHandler()
        })
    }
}
