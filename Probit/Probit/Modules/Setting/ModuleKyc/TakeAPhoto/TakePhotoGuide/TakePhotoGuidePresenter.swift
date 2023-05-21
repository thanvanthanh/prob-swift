//
//  TakePhotoGuidePresenter.swift
//  Probit
//
//  Created by Đào Mỹ Đông on 08/11/2565 BE.
//  
//

import Foundation

class TakePhotoGuidePresenter: ViewToPresenterTakePhotoGuideProtocol {
    
    // MARK: Properties
    var view: PresenterToViewTakePhotoGuideProtocol?
    var interactor: PresenterToInteractorTakePhotoGuideProtocol?
    var router: PresenterToRouterTakePhotoGuideProtocol?
}

extension TakePhotoGuidePresenter: InteractorToPresenterTakePhotoGuideProtocol {
}
