//
//  SignUpCompletePresenter.swift
//  Probit
//
//  Created by Nguyen Quang on 22/08/2022.
//  
//

import Foundation

class SignUpCompletePresenter: ViewToPresenterSignUpCompleteProtocol {

    // MARK: Properties
    var view: PresenterToViewSignUpCompleteProtocol?
    var interactor: PresenterToInteractorSignUpCompleteProtocol?
    var router: PresenterToRouterSignUpCompleteProtocol?
}

extension SignUpCompletePresenter: InteractorToPresenterSignUpCompleteProtocol {
    
}
