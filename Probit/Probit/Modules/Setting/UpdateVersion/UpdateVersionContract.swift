//
//  UpdateVersionContract.swift
//  Probit
//
//  Created by Bradley Hoang on 24/10/2022.
//  
//

import Foundation

// MARK: View Output (Presenter -> View)
protocol PresenterToViewUpdateVersionProtocol {
   
}

// MARK: View Input (View -> Presenter)
protocol ViewToPresenterUpdateVersionProtocol {
    var view: PresenterToViewUpdateVersionProtocol? { get set }
    var interactor: PresenterToInteractorUpdateVersionProtocol? { get set }
    var router: PresenterToRouterUpdateVersionProtocol? { get set }
}

// MARK: Interactor Input (Presenter -> Interactor)
protocol PresenterToInteractorUpdateVersionProtocol {
    var presenter: InteractorToPresenterUpdateVersionProtocol? { get set }
}

// MARK: Interactor Output (Interactor -> Presenter)
protocol InteractorToPresenterUpdateVersionProtocol {
}

// MARK: Router Input (Presenter -> Router)
protocol PresenterToRouterUpdateVersionProtocol {
}
