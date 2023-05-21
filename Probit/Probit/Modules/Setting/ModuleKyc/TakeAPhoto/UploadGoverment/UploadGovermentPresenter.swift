//
//  UploadGovermentPresenter.swift
//  Probit
//
//  Created by Đào Mỹ Đông on 09/11/2565 BE.
//  
//

import Foundation

class UploadGovermentPresenter: ViewToPresenterUploadGovermentProtocol {
    // MARK: Properties
    var view: PresenterToViewUploadGovermentProtocol?
    var interactor: PresenterToInteractorUploadGovermentProtocol?
    var router: PresenterToRouterUploadGovermentProtocol?
    func viewDidLoad() {
        view?.showLoading()
        interactor?.getData()
    }
}

extension UploadGovermentPresenter: InteractorToPresenterUploadGovermentProtocol {
    func getDataFailed(_ error: ServiceError) {
        view?.hideLoading()
        view?.showError(error: error)
    }
    
    func getDataCompleted() {
        view?.hideLoading()
        view?.reloadView()
    }
}
