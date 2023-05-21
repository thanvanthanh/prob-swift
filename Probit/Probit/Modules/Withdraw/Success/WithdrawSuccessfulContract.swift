//
//  WithdrawSuccessfulContract.swift
//  Probit
//
//  Created by Dang Nguyen on 10/11/2022.
//  
//

import Foundation

// MARK: View Output (Presenter -> View)
protocol PresenterToViewWithdrawSuccessfulProtocol {
   
}

// MARK: View Input (View -> Presenter)
protocol ViewToPresenterWithdrawSuccessfulProtocol {
    var view: PresenterToViewWithdrawSuccessfulProtocol? { get set }
    var interactor: PresenterToInteractorWithdrawSuccessfulProtocol? { get set }
    var router: PresenterToRouterWithdrawSuccessfulProtocol? { get set }
    func gotoWallet()
}

// MARK: Interactor Input (Presenter -> Interactor)
protocol PresenterToInteractorWithdrawSuccessfulProtocol {
    var presenter: InteractorToPresenterWithdrawSuccessfulProtocol? { get set }
}

// MARK: Interactor Output (Interactor -> Presenter)
protocol InteractorToPresenterWithdrawSuccessfulProtocol {
}

// MARK: Router Input (Presenter -> Router)
protocol PresenterToRouterWithdrawSuccessfulProtocol {
    func gotoWallet()
}
