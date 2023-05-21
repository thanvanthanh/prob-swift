//
//  AirdropsPresenter.swift
//  Probit
//
//  Created by Đào Mỹ Đông on 26/12/2565 BE.
//  
//

import Foundation

class AirdropsPresenter: ViewToPresenterAirdropsProtocol {
    var menus: [MenuBar] {
        interactor?.menus ?? []
    }
    
    // MARK: Properties
    var view: PresenterToViewAirdropsProtocol?
    var interactor: PresenterToInteractorAirdropsProtocol?
    var router: PresenterToRouterAirdropsProtocol?
}

extension AirdropsPresenter: InteractorToPresenterAirdropsProtocol {
}
