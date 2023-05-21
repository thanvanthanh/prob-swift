//
//  ConfirmTradeFeedInteractor.swift
//  Probit
//
//  Created by Nguyen Quang on 25/10/2022.
//  
//

import Foundation

class ConfirmTradeFeedInteractor: PresenterToInteractorConfirmTradeFeedProtocol {
    // MARK: Properties
    var presenter: InteractorToPresenterConfirmTradeFeedProtocol?
}

struct ConfirmTradeFeed {
    let marketId: String?
    let orderPrice: String?
    let orderAmount: String?
    let totalOrder: String?
}
