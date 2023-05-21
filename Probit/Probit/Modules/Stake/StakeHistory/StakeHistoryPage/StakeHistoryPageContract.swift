//
//  StakeHistoryPageContract.swift
//  Probit
//
//  Created by Đào Mỹ Đông on 06/10/2565 BE.
//  
//

import Foundation

// MARK: View Output (Presenter -> View)
protocol PresenterToViewStakeHistoryPageProtocol {
   
}

// MARK: View Input (View -> Presenter)
protocol ViewToPresenterStakeHistoryPageProtocol {
    var view: PresenterToViewStakeHistoryPageProtocol? { get set }
    var interactor: PresenterToInteractorStakeHistoryPageProtocol? { get set }
    var router: PresenterToRouterStakeHistoryPageProtocol? { get set }
}

// MARK: Interactor Input (Presenter -> Interactor)
protocol PresenterToInteractorStakeHistoryPageProtocol {
    var presenter: InteractorToPresenterStakeHistoryPageProtocol? { get set }
}

// MARK: Interactor Output (Interactor -> Presenter)
protocol InteractorToPresenterStakeHistoryPageProtocol {
}

// MARK: Router Input (Presenter -> Router)
protocol PresenterToRouterStakeHistoryPageProtocol {
}
