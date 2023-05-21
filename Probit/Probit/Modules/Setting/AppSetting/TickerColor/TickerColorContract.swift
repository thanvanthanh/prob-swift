//
//  TickerColorContract.swift
//  Probit
//
//  Created by Thân Văn Thanh on 31/08/2022.
//  
//

import Foundation


// MARK: View Output (Presenter -> View)
protocol PresenterToViewTickerColorProtocol {
   
}


// MARK: View Input (View -> Presenter)
protocol ViewToPresenterTickerColorProtocol {
    
    var view: PresenterToViewTickerColorProtocol? { get set }
    var interactor: PresenterToInteractorTickerColorProtocol? { get set }
    var router: PresenterToRouterTickerColorProtocol? { get set }
    var tickerColor: TickerColor? { get }
    func chooseTickerColor(tickerColor: TickerColor)
}


// MARK: Interactor Input (Presenter -> Interactor)
protocol PresenterToInteractorTickerColorProtocol {
    var presenter: InteractorToPresenterTickerColorProtocol? { get set }
    var tickerColor: TickerColor? { get set }
}


// MARK: Interactor Output (Interactor -> Presenter)
protocol InteractorToPresenterTickerColorProtocol {
    
}


// MARK: Router Input (Presenter -> Router)
protocol PresenterToRouterTickerColorProtocol {
    
}
