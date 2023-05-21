//
//  OpenOrdersInteractor.swift
//  Probit
//
//  Created by Nguyen Quang on 29/08/2022.
//  
//

import Foundation

class OpenOrdersInteractor: PresenterToInteractorOpenOrdersProtocol {
 
    
    // MARK: Properties
    var presenter: InteractorToPresenterOpenOrdersProtocol?
    var orderOpens: [OrderDataModel] = []
    var pair: String?
    
    func getData(hidePair: Bool) {
        HistoryAPI.shared.getOpenOder{ [weak self] result in
            guard let `self` = self else { return }
            switch result {
            case .success(let data):
                var models: [OrderDataModel] = []
                data.data.forEach { entry in
                    let model = OrderDataModel(entry: entry)
                    models.append(model)
                }
                let allData = models.sorted(by: {$0.time > $1.time})
                let dataFilter = models.filter {$0.marketID == self.pair}
                self.orderOpens = hidePair ? dataFilter : allData
                self.presenter?.changeStateResponseSucces()
            case let .failure(error):
                self.presenter?.handerApiError(error: error)
            }
        }
    }
    
    func doCancelOrder(openOrder: OrderDataModel, hidePair: Bool) {
        guard let marketId = openOrder.marketID, let orderId = openOrder.id else { return }
        HistoryAPI.shared.cancelOpenOrder(marketId: marketId, orderId: orderId) { [weak self] result in
            guard let `self` = self else { return }
            switch result {
            case .success(let res):
                let data = res.data
                self.presenter?.cancelOrderSucess(hidePair: hidePair, orderDatas: [data])
            case let .failure(error):
                self.presenter?.handerApiError(error: error)
            }
        }
    }
    
    func doCancelAllOrder(hidePair: Bool) {
        HistoryAPI.shared.cancelAllOpenOrder() { [weak self] result in
            guard let `self` = self else { return }
            switch result {
            case .success(let res):
                self.presenter?.cancelOrderSucess(hidePair: hidePair, orderDatas: res.data)
            case let .failure(error):
                self.presenter?.handerApiError(error: error)
            }
        }
    }
}
