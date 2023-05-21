//
//  SplashPresenter.swift
//  Probit
//
//  Created by Beacon on 21/08/2022.
//  
//

import Foundation

class SplashPresenter: ViewToPresenterSplashProtocol {

    // MARK: Properties
    var view: PresenterToViewSplashProtocol?
    var interactor: PresenterToInteractorSplashProtocol?
    var router: PresenterToRouterSplashProtocol?
    
    func navigateToLogin() {
        router?.navigateToLogin()
    }
    
    func viewDidLoad() {
        
    }
}

extension SplashPresenter: InteractorToPresenterSplashProtocol {
    
}
