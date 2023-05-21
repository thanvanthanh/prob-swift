//
//  TakeAPhotoPresenter.swift
//  Probit
//
//  Created by Đào Mỹ Đông on 07/11/2565 BE.
//  
//

import Foundation

class TakeAPhotoPresenter: ViewToPresenterTakeAPhotoProtocol {
    
    func uploaImage(image: UIImage) {
        view?.showLoading()
        view?.pauseCamera()
        interactor?.uploaImage(image: image)
        print("UploadImage", image.size)
    }
    
    func viewDidLoad() {
    }
    
    // MARK: Properties
    var view: PresenterToViewTakeAPhotoProtocol?
    var interactor: PresenterToInteractorTakeAPhotoProtocol?
    var router: PresenterToRouterTakeAPhotoProtocol?
}

extension TakeAPhotoPresenter: InteractorToPresenterTakeAPhotoProtocol {
    
    func updateImageFailed() {
        view?.hideLoading()
        view?.resumeCamera()
    }
    
    func getDataFailed(_ error: ServiceError) {
        view?.hideLoading()
        view?.showErrorWarningPopup({ self.view?.resumeCamera() },
                                    { self.view?.popToParentView() })
//        view?.showError(error: error)
    }
    
    func uploadImageSucced() {
        view?.hideLoading()
        guard let stylePhoto = self.interactor?.stylePhoto else { return }
        PhotoIsClearRouter(stylePhoto: stylePhoto).showScreen()
    }
    
}
