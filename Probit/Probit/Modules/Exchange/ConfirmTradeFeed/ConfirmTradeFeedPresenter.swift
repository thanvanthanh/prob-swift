//
//  ConfirmTradeFeedPresenter.swift
//  Probit
//
//  Created by Nguyen Quang on 25/10/2022.
//  
//

import Foundation

protocol ConfirmTradeFeedProtocol: AnyObject {
    func buyAction(limitPrice: String?, marketId: String, quantity: String)
    func sellAction(limitPrice: String?, marketId: String, quantity: String)
}

class ConfirmTradeFeedPresenter: ViewToPresenterConfirmTradeFeedProtocol {
    var orderSide: OrderSide?
    var marketId: String?
    var orderPrice: String?
    var orderAmount: String?
    var totalOrder: String?
    // MARK: Properties
    var view: PresenterToViewConfirmTradeFeedProtocol?
    var interactor: PresenterToInteractorConfirmTradeFeedProtocol?
    var router: PresenterToRouterConfirmTradeFeedProtocol?
    weak var delegate: ConfirmTradeFeedProtocol?
    
    init(delegate: ConfirmTradeFeedProtocol?) {
        self.delegate = delegate
    }
    
    func buyAction() {
        guard let marketId = marketId,
              let quantity = orderAmount ?? totalOrder else { return }
        delegate?.buyAction(limitPrice: orderPrice,
                            marketId: marketId,
                            quantity: quantity)
    }
    
    func sellAction() {
        guard let marketId = marketId,
              let quantity = orderAmount ?? totalOrder else { return }
        delegate?.sellAction(limitPrice: orderPrice,
                             marketId: marketId,
                             quantity: quantity)
    }
    
}

extension ConfirmTradeFeedPresenter: InteractorToPresenterConfirmTradeFeedProtocol {
    
}
