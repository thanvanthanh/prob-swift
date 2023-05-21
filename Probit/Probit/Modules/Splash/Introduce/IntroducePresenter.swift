//
//  IntroducePresenter.swift
//  Probit
//
//  Created by Nguyen Quang on 20/09/2022.
//  
//

import Foundation

class IntroducePresenter: ViewToPresenterIntroduceProtocol {
    // MARK: Properties
    var view: PresenterToViewIntroduceProtocol?
    var interactor: PresenterToInteractorIntroduceProtocol?
    var router: PresenterToRouterIntroduceProtocol?
    
    func navigateToHome() {
        router?.navigateToHome()
        AppConstant.showIntroDevice = true
    }
}

extension IntroducePresenter: InteractorToPresenterIntroduceProtocol {
    
}
