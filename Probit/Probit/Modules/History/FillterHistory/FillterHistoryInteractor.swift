//
//  FillterHistoryInteractor.swift
//  Probit
//
//  Created by Đào Mỹ Đông on 12/10/2565 BE.
//  
//

import Foundation

class FillterHistoryInteractor: PresenterToInteractorFillterHistoryProtocol {
    var marketsInfo: [MarketInfo] = []
    var markets: [Market] = []
    var currencies: [Currency] = []
    var listQuoteCurrencyId: [String] = []
    // MARK: Properties
    var presenter: InteractorToPresenterFillterHistoryProtocol?
    
    func getData() {
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        getDataCurrencies {
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        getMarket {
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        getMarketInfo {
            dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .main, execute: { [weak self] in
            guard let `self` = self else { return }
            let marketsInfoId = self.marketsInfo.map { market in
                market.id
            }
            let listMarket = self.markets.filter({ marketsInfoId.contains($0.id ?? "" ) })
            
            self.listQuoteCurrencyId = listMarket.map({ maket in
                return maket.quoteCurrencyID ?? ""
            }).uniqued()
            
            self.presenter?.changeStateResponseSucces()
        })
    }
    var productService = GatewayApiProductService()
    var getMarketInfoAction: GetMarketInfoAction
    var getMarketAction: GetMarketAction
    
    init() {
        self.getMarketAction = GetMarketAction(serviceType: "", dataSource: productService)
        self.getMarketInfoAction = GetMarketInfoAction(serviceType: "", dataSource: productService)
    }
    
    private func getDataCurrencies(completed: @escaping() -> Void) {
        HistoryAPI.shared.getCurrencyWithPlatform{ [weak self] result in
            guard let `self` = self else { return }
            switch result {
            case .success(let data):
                let list = data.data.filter({$0.showInUI ?? false})
                self.currencies = list
            case let .failure(error):
                self.presenter?.handerApiError(error: error)
            }
            completed()
        }
    }
    
    
    private func getMarketInfo(completed: @escaping() -> Void) {
        getMarketInfoAction.apiCall { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let res):
                let markets = res.data.filter({$0.serviceType == .all || $0.serviceType == .global})
                self.marketsInfo = markets
            case .failure(let error):
                self.presenter?.handerApiError(error: error)
            }
            completed()
        }
    }
    
    private func getMarket(completed: @escaping() -> Void) {
        getMarketAction.apiCall { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let res):
                let markets = res.data.filter({$0.showInUI ?? false && !($0.closed ?? true)})
                self.markets = markets
            case .failure(let error):
                self.presenter?.handerApiError(error: error)
            }
            completed()
        }
    }
    
}
