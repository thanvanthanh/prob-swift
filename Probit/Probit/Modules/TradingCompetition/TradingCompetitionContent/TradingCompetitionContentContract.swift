//
//  TradingCompetitionContentContract.swift
//  Probit
//
//  Created by Nguyen Quang on 22/09/2022.
//  
//

import Foundation

// MARK: View Output (Presenter -> View)
protocol PresenterToViewTradingCompetitionContentProtocol {
   
}

// MARK: View Input (View -> Presenter)
protocol ViewToPresenterTradingCompetitionContentProtocol {
    var view: PresenterToViewTradingCompetitionContentProtocol? { get set }
    var interactor: PresenterToInteractorTradingCompetitionContentProtocol? { get set }
    var router: PresenterToRouterTradingCompetitionContentProtocol? { get set }
    
    var tradings: [Trading] { get set }
    
    func navigateToTradingCompetitionDetail(model: Trading)
}

// MARK: Interactor Input (Presenter -> Interactor)
protocol PresenterToInteractorTradingCompetitionContentProtocol {
    var presenter: InteractorToPresenterTradingCompetitionContentProtocol? { get set }
}

// MARK: Interactor Output (Interactor -> Presenter)
protocol InteractorToPresenterTradingCompetitionContentProtocol {
}

// MARK: Router Input (Presenter -> Router)
protocol PresenterToRouterTradingCompetitionContentProtocol {
    func navigateToTradingCompetitionDetail(trading: Trading, title: String?)
}
