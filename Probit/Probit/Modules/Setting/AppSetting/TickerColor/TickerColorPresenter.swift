//
//  TickerColorPresenter.swift
//  Probit
//
//  Created by Thân Văn Thanh on 31/08/2022.
//  
//

import Foundation

class TickerColorPresenter: ViewToPresenterTickerColorProtocol {

    // MARK: Properties
    var view: PresenterToViewTickerColorProtocol?
    var interactor: PresenterToInteractorTickerColorProtocol?
    var router: PresenterToRouterTickerColorProtocol?
    weak var delegate: TickerColorDelegate?
    var tickerColor: TickerColor? { interactor?.tickerColor }
    
    init(delegate: TickerColorDelegate? = nil) {
        self.delegate = delegate
    }
    
    func chooseTickerColor(tickerColor: TickerColor) {
        delegate?.getTickerColor(options: tickerColor)
    }
}

extension TickerColorPresenter: InteractorToPresenterTickerColorProtocol {
    
}
