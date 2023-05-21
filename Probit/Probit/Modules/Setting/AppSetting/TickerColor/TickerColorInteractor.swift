//
//  TickerColorInteractor.swift
//  Probit
//
//  Created by Thân Văn Thanh on 31/08/2022.
//  
//

import Foundation

class TickerColorInteractor: PresenterToInteractorTickerColorProtocol {

    // MARK: Properties
    var presenter: InteractorToPresenterTickerColorProtocol?
    var tickerColor: TickerColor?
    
    init(tickerColor: TickerColor) {
        self.tickerColor = tickerColor
    }
}
