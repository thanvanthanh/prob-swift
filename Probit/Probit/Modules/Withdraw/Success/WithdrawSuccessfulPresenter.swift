//
//  WithdrawSuccessfulPresenter.swift
//  Probit
//
//  Created by Dang Nguyen on 10/11/2022.
//  
//

import Foundation

class WithdrawSuccessfulPresenter: ViewToPresenterWithdrawSuccessfulProtocol {
    // MARK: Properties
    var view: PresenterToViewWithdrawSuccessfulProtocol?
    var interactor: PresenterToInteractorWithdrawSuccessfulProtocol?
    var router: PresenterToRouterWithdrawSuccessfulProtocol?
    
    func gotoWallet() {
        router?.gotoWallet()
    }
}

extension WithdrawSuccessfulPresenter: InteractorToPresenterWithdrawSuccessfulProtocol {
    
}
