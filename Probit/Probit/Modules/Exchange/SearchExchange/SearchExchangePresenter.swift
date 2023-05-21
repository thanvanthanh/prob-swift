//
//  SearchExchangePresenter.swift
//  Probit
//
//  Created by Nguyen Quang on 16/10/2022.
//  
//

import Foundation

class SearchExchangePresenter: ViewToPresenterSearchExchangeProtocol {
    var socket: SocketService?
    // MARK: Properties
    var view: PresenterToViewSearchExchangeProtocol?
    var interactor: PresenterToInteractorSearchExchangeProtocol?
    var router: PresenterToRouterSearchExchangeProtocol?
    
    var coins: [ExchangeTicker] { interactor?.coins ?? [] }
    var keyword: String { interactor?.keyword ?? "" }
    
    func viewDidLoad() {
        socket = SocketService()
        socket?.set(delegate: self)
        interactor?.getDataIfNeeded()
        view?.setSearchBar(keyword)
    }
    
    func disconnect() {
        socket?.unsubscribe(channel: .marketdata)
        socket?.unsubscribe(channel: .exchangeRate)
        socket?.closeConnection()
    }
    
    func connect() {
        socket?.subcribe(channel: .exchangeRate, filter: [])
        socket?.subcribe(channel: .marketdata, filter: ["ticker"])
    }
    
    func navigateToExchangeDetail(exchange: ExchangeTicker?) {
        disconnect()
        router?.navigateToExchangeDetail(exchange: exchange)
    }
    
    func searchBarDidChange(text: String) {
        view?.setSearchBar(text)
    }
    
    private func filterByBaseAndQuoteCurrency(_ text: String, splitChar: Character) -> [ExchangeTicker] {
        let currencies = text.split(separator: splitChar, omittingEmptySubsequences: false).map { String($0) }
        guard currencies.count == 2 else {
            return []
        }
        let baseCurrency = currencies[0]
        let quoteCurrency = currencies[1]
        
        let filteredCoins = coins.filter {
            let isHasBaseId = $0.baseCurrencyId.value.lowercased() == baseCurrency
            let isHasQuoteId = $0.quoteCurrencyId.value.lowercased() == quoteCurrency
            return isHasBaseId || isHasQuoteId
        }
        return filteredCoins
    }
    
    private func filterByBaseCurrencyAndDisplayName(_ text: String) -> [ExchangeTicker] {
        print( "CoinId:" ,coins.compactMap({$0.baseCurrencyId}))
        let filteredCoins = coins.filter {
            let isHasBaseCurrency = $0.baseCurrencyId.value.lowercased().contains(text)
            let isHasDisplayName = $0.displayName.value.lowercased().contains(text)
            return isHasBaseCurrency || isHasDisplayName
        }
        return filteredCoins
    }
}

// MARK: - InteractorToPresenter
extension SearchExchangePresenter: InteractorToPresenterSearchExchangeProtocol {
    func hideLoading() {
        view?.hideLoading()
    }
    
    func showLoading() {
        view?.showLoading()
    }
    
    func showError(error: ServiceError) {
        view?.showError(error: error)
    }
    
    func getDataSuccess() {
        searchBarDidChange(text: keyword)
    }
}

extension SearchExchangePresenter: SocketServiceDelegate {
    func onSocketReciever(text: String) {
        guard let data = text.data(using: .utf8, allowLossyConversion: false) else { return }
        if let exchangeRate = try? JSONDecoder().decode(ExchangeRate.self, from: data) {
            var indexPaths: [Int] = []
            coins.enumerated().forEach { index, coin in
                for item in exchangeRate.data.usdt where item.currencyID == coin.id {
                    indexPaths.append(index)
                    coin.mapping(withUsdt: item)
                }
            }
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.view?.bindData(indexPaths: indexPaths, exchangeRate: exchangeRate, marketData: nil)
            }
        }
        
        if let marketData = try? JSONDecoder().decode(MarketData.self, from: data) {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.view?.bindData(indexPaths: [],
                                    exchangeRate: nil,
                                    marketData: marketData)
            }
        }
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

