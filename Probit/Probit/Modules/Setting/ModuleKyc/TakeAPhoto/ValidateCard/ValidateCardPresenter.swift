//
//  ValidateCardPresenter.swift
//  Probit
//
//  Created by Đào Mỹ Đông on 16/11/2565 BE.
//  
//

import Foundation

class ValidateCardPresenter: ViewToPresenterValidateCardProtocol {

    
    // MARK: Properties
    var view: PresenterToViewValidateCardProtocol?
    var interactor: PresenterToInteractorValidateCardProtocol?
    var router: PresenterToRouterValidateCardProtocol?
    
    func viewDidLoad() {
        view?.showLoading()
        interactor?.getData()
    }
    
    func doProceedAnyway() {
        guard let status = interactor?.loadingData?.result else { return }
        switch status {
        case .NEED_CONFIRM:
            self.interactor?.nextProcessAnyWay()
        case .NEED_CHECK:
            KycUpdateInformationRouter().showScreen()
        default:
            return
        }
    }
}

extension ValidateCardPresenter: InteractorToPresenterValidateCardProtocol {
    func getDataFailed(_ error: ServiceError) {
        view?.hideLoading()
        view?.showError(error: error)
    }
    
    func getDataCompleted() {
        view?.hideLoading()
        view?.reloadView()
    }
    func nextStepSuccess() {
        self.router?.navigateComplateVC()
    }
}
