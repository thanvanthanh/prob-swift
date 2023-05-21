//
//  UpdateVersionPresenter.swift
//  Probit
//
//  Created by Bradley Hoang on 24/10/2022.
//  
//

import Foundation

final class UpdateVersionPresenter: ViewToPresenterUpdateVersionProtocol {
    // MARK: Properties
    var view: PresenterToViewUpdateVersionProtocol?
    var interactor: PresenterToInteractorUpdateVersionProtocol?
    var router: PresenterToRouterUpdateVersionProtocol?
}

extension UpdateVersionPresenter: InteractorToPresenterUpdateVersionProtocol {
    
}
