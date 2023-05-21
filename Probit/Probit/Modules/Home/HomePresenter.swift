//
//  HomePresenter.swift
//  Probit
//
//  Created by Nguyen Quang on 23/08/2022.
//  
//

import Foundation
import os

class HomePresenter: ViewToPresenterHomeProtocol {

    // MARK: Properties
    var view: PresenterToViewHomeProtocol?
    var interactor: PresenterToInteractorHomeProtocol?
    var router: PresenterToRouterHomeProtocol?
    
    var newCoins: [NewCoins] { interactor?.newCoins ?? [] }
    var listBanner: [HomeBannerModel] { interactor?.listBanner ?? [] }
    var annoucements: [Annoucement] { interactor?.annoucements ?? [] }
    var carousels: [CarouselModel] { interactor?.carousels ?? [] }
    var makets: [Market] { interactor?.makets ?? [] }
    var homeSectionData: [HomeConfigGlobal] { interactor?.homeSectionData ?? [] }
    var socketService: SocketService?
    private var exchangeRate: ExchangeRate?
    private var marketData: MarketData?
    
    var isShowing: Bool = true
    
    private var logger = Logger()
    
    func viewDidLoad() {
        view?.showLoading()
        interactor?.getData()
    }
    
    func viewWillAppear() {
        view?.setupNavigationBar()
        connectSocket()
    }
    
    func viewWillDisappear() {
        disconnectedSocket()
    }
    
    func navigateToBuyCrypto() {
        router?.navigateToBuyCrypto()
    }
    
    func navigateToLogin() {
        router?.navigateToLogin()
    }
    
    func navigateToMore() {
        router?.navigateToMore()
    }
    
    private func closeConnection() {
        self.socketService?.unsubscribe(channel: .exchangeRate)
        self.socketService?.unsubscribe(channel: .marketdata)
        self.socketService?.closeConnection()
    }
    
    func navigateToWebView(link: String, title: String) {
        router?.navigateToWebView(link: link, title: title)
    }
    
    func navigateToAppLock() {
        guard AppConstant.isAppLock else { return }
        router?.navigateToAppLock()
    }
    
    func navigateToExchange(from vc: UIViewController) {
        router?.navigateToExchange(from: vc)
    }
    
    func selectNewCoin(_ coin: NewCoins) {
        router?.navigateToExchangeSearch(keyword: coin.id + "/")
    }
    
    func navigateToExchangeDetail(with market: Market?) {
        guard let market = market else { return }
        let exchangeTicker = ExchangeTicker()
        exchangeTicker.mapping(withMarket: market)
        router?.navigateToExchangeDetail(with: exchangeTicker)
    }
    
    func navigateToExchangeDetail(with exchangeId: String) {
        router?.navigateToExchangeDetail(with: exchangeId)
    }
    
    private func connectSocket() {
        self.socketService = SocketService()
        self.socketService?.connect()
        self.socketService?.set(delegate: self)
    }
    
    private func disconnectedSocket() {
        socketService?.closeConnection()
        socketService = nil
    }
}

extension HomePresenter: InteractorToPresenterHomeProtocol {
    func getHomeConfigComplete() {
        view?.hideLoading()
        view?.getHomeConfigComplete(exchangeRate: exchangeRate, marketData: marketData)
    }
    
    func getCoinInfoComplete() {
        guard let exchangeRate = exchangeRate else { return }
        reloadDataExchangeRate(exchangeRate: exchangeRate)
    }
    
    func subscribeSocket() {
        socketService?.subcribe(channel: .exchangeRate, filter: ["USDT"])
        socketService?.subcribe(channel: .marketdata, filter: ["ticker"])
    }
    
    func handerApiError() {
        view?.hideLoading()
    }
    
    func networkDisconnected() {
        
    }
    
    func networkRecconnected() {
        view?.showLoading()
        interactor?.getData()
        self.subscribeSocket()
    }
    
}

extension HomePresenter: SocketServiceDelegate {
    
    func onSocketReciever(text: String) {
        guard let data = text.data(using: .utf8, allowLossyConversion: false) else { return }
        if let exchangeRate = try? JSONDecoder().decode(ExchangeRate.self, from: data) {
            if self.exchangeRate == nil {
                self.exchangeRate = exchangeRate
            }
            guard self.newCoins.count > 0 else { return }
            self.reloadDataExchangeRate(exchangeRate: exchangeRate)
        }
        if let marketData = try? JSONDecoder().decode(MarketData.self, from: data) {
            if self.marketData == nil {
                self.marketData = marketData
            }
            guard self.newCoins.count > 0 else { return }
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.view?.bindData(indexPaths: [],
                                    exchangeRate: nil,
                                    marketData: marketData)
            }
        }
    }
    
    private func reloadDataExchangeRate(exchangeRate: ExchangeRate) {
        var indexPaths: [Int] = []
        newCoins.enumerated().forEach { index, coin in
            for item in exchangeRate.data.usdt where item.currencyID == coin.id {
                indexPaths.append(index)
                coin.mapping(item)
            }
        }
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.view?.bindData(indexPaths: indexPaths,
                                exchangeRate: exchangeRate, marketData: nil)
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
