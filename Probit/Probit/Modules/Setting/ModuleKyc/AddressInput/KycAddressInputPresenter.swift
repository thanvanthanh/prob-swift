//
//  KycAddressInputPresenter.swift
//  Probit
//
//  Created by Bradley Hoang on 09/11/2022.
//  
//

import Foundation

class KycAddressInputPresenter: ViewToPresenterKycAddressInputProtocol {
    func viewDidLoad() {
        view?.showLoading()
        interactor?.getData()
    }
    
    // MARK: Properties
    var view: PresenterToViewKycAddressInputProtocol?
    var interactor: PresenterToInteractorKycAddressInputProtocol?
    var router: PresenterToRouterKycAddressInputProtocol?
    
    func updatePersionalDataKyc(_ data: [String: String]) {
        self.view?.showLoading()
        self.interactor?.updatePersionalDataKyc(data)
    }
}

// MARK: - InteractorToPresenter
extension KycAddressInputPresenter: InteractorToPresenterKycAddressInputProtocol {
    func getDataFailed(_ error: ServiceError) {
        view?.hideLoading()
        view?.showError(error: error)
    }
    
    func updateDataSuccess() {
        view?.hideLoading()
        TakePhotoGuideRouter().showScreen()
    }
    
    func getDataCompleted() {
        view?.hideLoading()
        view?.updateViewPersonal()
    }
    
    func handleNextButtonState(_ address: String, city: String, postalCode: String) {
        let isEnable: Bool = !address.isEmpty && !city.isEmpty && !postalCode.isEmpty
        self.view?.enableNextButton(isEnable)
    }
    
    
}
