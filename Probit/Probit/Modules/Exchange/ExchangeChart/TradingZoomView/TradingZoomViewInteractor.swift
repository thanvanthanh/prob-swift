//
//  TradingZoomViewInteractor.swift
//  Probit
//
//  Created by Đào Mỹ Đông on 10/01/2566 BE.
//  
//

import Foundation

class TradingZoomViewInteractor: PresenterToInteractorTradingZoomViewProtocol {
    // MARK: Properties
    var presenter: InteractorToPresenterTradingZoomViewProtocol?
    var exchange: ExchangeTicker
    init(exchange: ExchangeTicker) {
        self.exchange = exchange
    }
}
