//
//  TradeFeedDetailInteractor.swift
//  Probit
//
//  Created by Nguyen Quang on 21/10/2022.
//  
//

import Foundation

class TradeFeedDetailInteractor: PresenterToInteractorTradeFeedDetailProtocol {
    // MARK: Properties
    var userBalances: [UserBalance] = []
    var getUserBalanceAction = GetUserBalanceAction()
    var presenter: InteractorToPresenterTradeFeedDetailProtocol?
    var entity: InteractorToEntityTradeFeedDetailProtocol?
    
    func getUserBalance() {
        getUserBalanceAction.apiCall { [weak self] result in
            guard let `self` = self else { return }
            switch result {
            case let .success(response):
                self.userBalances = response.data
                self.presenter?.getUserBalancesSuccess()
                print(response.data)
            case let .failure(error):
                print("error: \(error)")
            }
        }
    }
    
    func newOrder(limitPrice: String?, marketId: String,
                  quantity: String, side: OrderSide, type: ReportTrade) {
        entity?.newOrder(limitPrice: limitPrice,
                         marketId: marketId, quantity: quantity,
                         side: side, type: type, completionHandler: { [weak self] result in
            guard let `self` = self else { return }
            switch result {
            case .success:
                self.presenter?.newOfferComplete()
            case let .failure(error):
                self.presenter?.handerApiError(error: error)
            }
        })
    }
}

enum ReportTrade: String {
    case limit = "limit"
    case market = "market"
    
    var timeInForce: String {
        switch self {
        case .limit:
            return "gtc"
        case .market:
            return "ioc"
        }
    }
}

enum AmountTotal: Int, CaseIterable {
    case percent25 = 25
    case percent50 = 50
    case percent75 = 75
    case percent100 = 100
    
}
