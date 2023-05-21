//
//  IntroduceContract.swift
//  Probit
//
//  Created by Nguyen Quang on 20/09/2022.
//  
//

import Foundation

// MARK: View Output (Presenter -> View)
protocol PresenterToViewIntroduceProtocol {
   
}

// MARK: View Input (View -> Presenter)
protocol ViewToPresenterIntroduceProtocol {
    var view: PresenterToViewIntroduceProtocol? { get set }
    var interactor: PresenterToInteractorIntroduceProtocol? { get set }
    var router: PresenterToRouterIntroduceProtocol? { get set }
    func navigateToHome()
}

// MARK: Interactor Input (Presenter -> Interactor)
protocol PresenterToInteractorIntroduceProtocol {
    var presenter: InteractorToPresenterIntroduceProtocol? { get set }
}

// MARK: Interactor Output (Interactor -> Presenter)
protocol InteractorToPresenterIntroduceProtocol {
}

// MARK: Router Input (Presenter -> Router)
protocol PresenterToRouterIntroduceProtocol {
    func navigateToHome()
}
