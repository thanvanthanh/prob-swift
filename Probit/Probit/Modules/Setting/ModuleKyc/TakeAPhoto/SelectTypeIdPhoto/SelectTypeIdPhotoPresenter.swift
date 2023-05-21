//
//  SelectTypeIdPhotoPresenter.swift
//  Probit
//
//  Created by Đào Mỹ Đông on 08/11/2565 BE.
//  
//

import Foundation

class SelectTypeIdPhotoPresenter: ViewToPresenterSelectTypeIdPhotoProtocol {
  
    
    // MARK: Properties
    var view: PresenterToViewSelectTypeIdPhotoProtocol?
    var interactor: PresenterToInteractorSelectTypeIdPhotoProtocol?
    var router: PresenterToRouterSelectTypeIdPhotoProtocol?
    
    func setTypeCardSelected(_ data: TypeCardId) {
        view?.showLoading()
        interactor?.updateIdTypeDataKyc(data)
    }
    
    func viewDidLoad() {
        view?.showLoading()
        interactor?.getData()
    }
}

extension SelectTypeIdPhotoPresenter: InteractorToPresenterSelectTypeIdPhotoProtocol {
    func getDataFailed(_ error: ServiceError) {
        view?.hideLoading()
        view?.showError(error: error)
    }
    
    func updateDataSuccess() {
        view?.hideLoading()
        view?.reloadData()
    }
    
    func getDataCompleted() {
        view?.hideLoading()
        view?.reloadData()
    }
}
