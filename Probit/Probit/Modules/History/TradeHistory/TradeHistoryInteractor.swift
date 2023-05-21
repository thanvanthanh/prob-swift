//
//  TradeHistoryInteractor.swift
//  Probit
//
//  Created by Nguyen Quang on 29/08/2022.
//  
//

import Foundation

class TradeHistoryInteractor: PresenterToInteractorTradeHistoryProtocol {
    var filterModel: SearchFilterModel
    var tradeHistorys: [TradeHistoryModel] = []
    // MARK: Properties
    var presenter: InteractorToPresenterTradeHistoryProtocol?
    
    init() {
        self.filterModel = SearchFilterModel(limit: 100)
    }
    
    func getData() {
        HistoryAPI.shared.getTradeHistory(startTime: filterModel.startTime,
                                          endTime: filterModel.endTime,
                                          limit: filterModel.limit,
                                          baseCurrencyId: filterModel.baseCurrency?.id,
                                          quoteCurrencyId: filterModel.quoteCurrency?.id ){ [weak self] result in
            guard let `self` = self else { return }
            switch result {
            case .success(let data):
                var models: [TradeHistoryModel] = []
                data.data.forEach { entry in
                    let model = TradeHistoryModel(entry: entry)
                    models.append(model)
                }
                self.tradeHistorys = models
                self.presenter?.changeStateResponseSucces()
            case let .failure(error):
                self.presenter?.handerApiError(error: error)
            }
        }
    }
}
