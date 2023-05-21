//
//  AppLockContract.swift
//  Probit
//
//  Created by Thân Văn Thanh on 27/09/2022.
//  
//

import Foundation

// MARK: View Output (Presenter -> View)
protocol PresenterToViewAppLockProtocol {
   
}

// MARK: View Input (View -> Presenter)
protocol ViewToPresenterAppLockProtocol {
    var view: PresenterToViewAppLockProtocol? { get set }
    var interactor: PresenterToInteractorAppLockProtocol? { get set }
    var router: PresenterToRouterAppLockProtocol? { get set }
    func navigateToInputPin(type: InputPinType)
}

// MARK: Interactor Input (Presenter -> Interactor)
protocol PresenterToInteractorAppLockProtocol {
    var presenter: InteractorToPresenterAppLockProtocol? { get set }
}

// MARK: Interactor Output (Interactor -> Presenter)
protocol InteractorToPresenterAppLockProtocol {
}

// MARK: Router Input (Presenter -> Router)
protocol PresenterToRouterAppLockProtocol {
    func navigateToInputPin(type: InputPinType)
}
