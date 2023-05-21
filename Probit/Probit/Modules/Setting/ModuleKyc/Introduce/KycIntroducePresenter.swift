//
//  KycIntroducePresenter.swift
//  Probit
//
//  Created by Bradley Hoang on 01/11/2022.
//  
//

import Foundation

class KycIntroducePresenter: ViewToPresenterKycIntroduceProtocol {
    // MARK: Properties
    var view: PresenterToViewKycIntroduceProtocol?
    var interactor: PresenterToInteractorKycIntroduceProtocol?
    var router: PresenterToRouterKycIntroduceProtocol?
    
    func navigateByStatus() {
        view?.showLoading()
        interactor?.reloadKycData { [weak self] in
            guard let self = self else { return }
            self.view?.hideLoading()
            let pageType = self.interactor?.kycStatusModel.pageType ?? .country
            switch pageType {
            case .country:
                self.router?.navigateToKycSelectCountry()
            case .personalInfo:
                self.router?.navigateInputType()
            case .selfieImage:
                self.router?.navigateSelfImageClear()
            case .idType:
                SelectTypeIdPhotoRouter().showScreen()
            case .idImage:
                UploadGovermentRouter().showScreen()
            case .loading:
                ValidateCardRouter().showScreen()
            case .checkData:
                KycUpdateInformationRouter().showScreen()
            default:
                self.router?.navigateToKycSelectCountry()
            }
        }
    }
    
    func viewDidLoad() {
        view?.showLoading()
        interactor?.getData()
    }
}

extension KycIntroducePresenter: InteractorToPresenterKycIntroduceProtocol {
    
    func getDataCompleted() {
        view?.hideLoading()
        view?.reloadView()
    }
    
    func updateDataSuccess() {
        view?.hideLoading()
        view?.reloadView()
    }
    
    func getDataFailed(_ error: ServiceError) {
        view?.hideLoading()
//        view?.showErrorWarningPopup(nil, nil)
    }
    
}
