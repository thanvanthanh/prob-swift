//
//  OrderHistoryInteractor.swift
//  Probit
//
//  Created by Nguyen Quang on 29/08/2022.
//  
//

import Foundation

class OrderHistoryInteractor: PresenterToInteractorOrderHistoryProtocol {
    var orders: [OrderDataModel] = []
    var filterModel: SearchFilterModel
    // MARK: Properties
    var presenter: InteractorToPresenterOrderHistoryProtocol?
    init() {
        self.filterModel = SearchFilterModel(limit: 100)
    }
    
    func getData() {
        HistoryAPI.shared.getOrderHistory(startTime: filterModel.startTime,
                                          endTime: filterModel.endTime,
                                          limit: filterModel.limit,
                                          baseCurrencyId: filterModel.baseCurrency?.id,
                                          quoteCurrencyId: filterModel.quoteCurrency?.id ){ [weak self] result in
            guard let `self` = self else { return }
            switch result {
            case .success(let data):
                var models: [OrderDataModel] = []
                data.data.forEach { entry in
                    let model = OrderDataModel(entry: entry)
                    models.append(model)
                }
                self.orders = models
                self.presenter?.changeStateResponseSucces()
            case let .failure(error):
                self.presenter?.handerApiError(error: error)
            }
        }
    }
}
