//
//  ExchangeOrderBookInteractor.swift
//  Probit
//
//  Created by Nguyen Quang on 17/10/2022.
//  
//

import Foundation

class ExchangeOrderBookInteractor: PresenterToInteractorExchangeOrderBookProtocol {
    // MARK: Properties
    var presenter: InteractorToPresenterExchangeOrderBookProtocol?
    var entity: InteractorToEntityExchangeOrderBookProtocol?
}
