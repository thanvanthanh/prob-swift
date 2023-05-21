//
//  TabbarPresenter.swift
//  Probit
//
//  Created by Nguyen Quang on 23/08/2022.
//  
//

import Foundation

class TabbarPresenter: ViewToPresenterTabbarProtocol {

    // MARK: Properties
    var view: PresenterToViewTabbarProtocol?
    var interactor: PresenterToInteractorTabbarProtocol?
    var router: PresenterToRouterTabbarProtocol?
    
    func viewDidLoad() {
        RuntimeConfigService.shared.startTimer()
    }
}

extension TabbarPresenter: InteractorToPresenterTabbarProtocol {
    
}
