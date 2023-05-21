//
//  PhotoIsClearPresenter.swift
//  Probit
//
//  Created by Đào Mỹ Đông on 08/11/2565 BE.
//  
//

import Foundation

class PhotoIsClearPresenter: ViewToPresenterPhotoIsClearProtocol {
    func nextStep() {
        view?.showLoading()
        interactor?.nextStep()
    }
    
    // MARK: Properties
    var view: PresenterToViewPhotoIsClearProtocol?
    var interactor: PresenterToInteractorPhotoIsClearProtocol?
    var router: PresenterToRouterPhotoIsClearProtocol?
    
    func viewDidLoad() {
        view?.showLoading()
        interactor?.getData()
    }
    
    func reTakePhoto() {
        self.view?.showLoading()
        self.interactor?.deletePhoto()
    }
}

extension PhotoIsClearPresenter: InteractorToPresenterPhotoIsClearProtocol {
    func nextScreenLoading() {
        view?.hideLoading()
        ValidateCardRouter().showScreen()
    }
    
    func deletePhotoSucces() {
        view?.hideLoading()
        guard let stylePhoto = self.interactor?.stylePhoto else { return }
        router?.navigateReTakePhoto(stylePhoto: stylePhoto)
    }
    
    func getDataFailed(_ error: ServiceError) {
        view?.hideLoading()
        view?.showError(error: error)
    }
    
    func getDataCompleted() {
        view?.hideLoading()
        view?.reloadView()
    }
}
