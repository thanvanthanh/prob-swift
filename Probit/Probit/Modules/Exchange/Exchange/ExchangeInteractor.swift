//
//  ExchangeInteractor.swift
//  Probit
//
//  Created by Nguyen Quang on 25/08/2022.
//  
//

import Foundation

class ExchangeInteractor: PresenterToInteractorExchangeProtocol {
    // MARK: Properties
    var presenter: InteractorToPresenterExchangeProtocol?
    var entity: InteractorToEntityExchangeProtocol?
    
    var productService = GatewayApiProductService()
    var getTicker: GetTickerAction!
    var getMarket: GetMarketAction!
    var getMarketInfor: GetMarketInfoAction!
    var getMarketTag: GetMarketTagAction!
    var getMarketTagSuggetion: GetMarketTagSuggestionAction!
    var getCurrencyWithPlatform: GetCurrencyWithPlatformAction!
    var sortType: ExchangeSortType = .vol
    var sortCompare: ExchangeSortCompare = .down
    
    var tickers: [Ticker] = []
    var markets: [Market] = []
    var defiId: String?
    var tags: [MarketTag] = []
    var marketsInfo: [MarketInfo] = []
    var currency: [Currency] = []
    var exchanges: [ExchangeTicker] = []
    var btcExchanges: [ExchangeTicker] = []
    var ethExchanges: [ExchangeTicker] = []
    var usdtExchanges: [ExchangeTicker] = []
    var defiExchanges: [ExchangeTicker] = []
    var favoriteExchanges: [ExchangeTicker] = []
    
    var listExchange: [MenuBar] = [
        MenuBar(name: nil, icon: nil,
                controller: ExchangePageViewRouter().createModule(withType: .favorite)),
        MenuBar(name: "USDT", icon: nil,
                controller: ExchangePageViewRouter().createModule(withType: .other("USDT")),
                isSelected: true),
        MenuBar(name: "BTC", icon: nil,
                controller: ExchangePageViewRouter().createModule(withType: .other("BTC"))),
        MenuBar(name: "ETH",
                icon: nil,
                controller: ExchangePageViewRouter().createModule(withType: .other("ETH"))),
        MenuBar(name: "DeFi", icon: nil,
                controller: ExchangePageViewRouter().createModule(withType: .other("DeFi")))
    ]
    
    init() {
        self.getTicker = GetTickerAction(dataSource: productService)
        self.getMarket = GetMarketAction(serviceType: "", dataSource: productService)
        self.getCurrencyWithPlatform = GetCurrencyWithPlatformAction(dataSource: productService)
        self.getMarketInfor = GetMarketInfoAction(serviceType: "", dataSource: productService)
        self.getMarketTagSuggetion = GetMarketTagSuggestionAction(dataSource: productService)
        self.getMarketTag = GetMarketTagAction(dataSource: productService)
    }
    
    func getData() {
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
        getMarketTag.apiCall { [weak self] result in
            dispatchGroup.leave()
            guard let self = self else { return }
            switch result {
            case .success(let response):
                self.tags = response.data
            case .failure(let error):
                print("[Error]", error.message)
            }
        }
        
        dispatchGroup.enter()
        getMarketTagSuggetion.apiCall { [weak self] result in
            dispatchGroup.leave()
            guard let self = self else { return }
            switch result {
            case .success(let response):
                self.defiId = response.data.defi?.tags?.first
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
                self.markets = res.data.filter { $0.closed == false }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        dispatchGroup.enter()
        getMarketInfor.apiCall { [weak self] result in
            dispatchGroup.leave()
            guard let self = self else { return }
            switch result {
            case .success(let response):
                self.marketsInfo = response.data
            case .failure(let error):
                print("[Error]", error.message)
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
            self.exchanges = self.exchanges.global(with: self.marketsInfo.compactMap{ $0.id })
            self.exchanges.forEach { exchange in
                for market in self.markets where exchange.id == market.id {
                    exchange.mapping(withMarket: market)
                }
                exchange.mapping(withCurrencies: self.currency)
            }
            self.sortDataExChange()
        })
    }
    
    private func sortDataExChange() {
        AppConstant.exchangeSortType = sortType
        var exchanges = self.exchanges

        if sortCompare == .down {
            exchanges = exchanges.sorted(by: >)
        } else {
            exchanges = exchanges.sorted(by: <)
        }
        usdtExchanges = exchanges.filter { $0.quoteCurrencyId == "USDT" }
        btcExchanges = exchanges.filter { $0.quoteCurrencyId == "BTC" }
        ethExchanges = exchanges.filter { $0.quoteCurrencyId == "ETH" }
        favoriteExchanges = exchanges.filter { AppConstant.listCoinFavorites.contains($0.id.value) }
        
        if let tagDefi = defiId {
            let applies = self.tags.getDefiApplies(withTag: tagDefi)
            defiExchanges = exchanges.filter { applies.contains($0.baseCurrencyId ?? "") }
            
        } else {
            defiExchanges = []
        }
        self.presenter?.dataListDidFetch()
    }
    
    func selectedExchange(index: IndexPath) {
        listExchange.enumerated().forEach { (i, _) in
            listExchange[i].isSelected = false
        }
        listExchange[index.row].isSelected = true
        sortDataExChange()
    }
    
    func sortVolumeData() {
        guard sortType == .vol else {
            sortType = .vol
            sortDataExChange()
            return
        }
        sortCompare = sortCompare == .down ? .up : .down
        sortDataExChange()
    }
    
    func sortChange24HrData() {
        guard sortType == .change else {
            sortType = .change
            sortDataExChange()
            return
        }
        sortCompare = sortCompare == .down ? .up : .down
        sortDataExChange()
    }
    
    func sortPriceData() {
        guard sortType == .price else {
            sortType = .price
            sortDataExChange()
            return
        }
        sortCompare = sortCompare == .down ? .up : .down
        sortDataExChange()
    }
    
    func sortTradingPairData() {
        guard sortType == .pair else {
            sortType = .pair
            sortDataExChange()
            return
        }
        sortCompare = sortCompare == .down ? .up : .down
        sortDataExChange()
    }
}
