//
//  CommonWebViewPresenter.swift
//  Probit
//
//  Created by Nguyen Quang on 07/09/2022.
//  
//

import Foundation

class CommonWebViewPresenter: ViewToPresenterCommonWebViewProtocol {
    // MARK: Properties
    var view: PresenterToViewCommonWebViewProtocol?
    var interactor: PresenterToInteractorCommonWebViewProtocol?
    var router: PresenterToRouterCommonWebViewProtocol?
    
    var html: String?
    var urlString: String?
    var titleBackScreen: String?
    var titleNavigation: String?
    var fileName: String?
    var type: String?

    func gotoLogin() {
        router?.gotoLogin()
    }
    
    func viewDidLoad() {
        interactor?.loadCurrency()
    }
}

extension CommonWebViewPresenter: InteractorToPresenterCommonWebViewProtocol {
    
}
