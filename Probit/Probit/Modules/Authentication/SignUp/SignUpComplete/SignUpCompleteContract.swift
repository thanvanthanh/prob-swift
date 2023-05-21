//
//  SignUpCompleteContract.swift
//  Probit
//
//  Created by Nguyen Quang on 22/08/2022.
//  
//

import Foundation


// MARK: View Output (Presenter -> View)
protocol PresenterToViewSignUpCompleteProtocol {
   
}


// MARK: View Input (View -> Presenter)
protocol ViewToPresenterSignUpCompleteProtocol {
    
    var view: PresenterToViewSignUpCompleteProtocol? { get set }
    var interactor: PresenterToInteractorSignUpCompleteProtocol? { get set }
    var router: PresenterToRouterSignUpCompleteProtocol? { get set }
}


// MARK: Interactor Input (Presenter -> Interactor)
protocol PresenterToInteractorSignUpCompleteProtocol {
    
    var presenter: InteractorToPresenterSignUpCompleteProtocol? { get set }
}


// MARK: Interactor Output (Interactor -> Presenter)
protocol InteractorToPresenterSignUpCompleteProtocol {
    
}


// MARK: Router Input (Presenter -> Router)
protocol PresenterToRouterSignUpCompleteProtocol {
    
}
