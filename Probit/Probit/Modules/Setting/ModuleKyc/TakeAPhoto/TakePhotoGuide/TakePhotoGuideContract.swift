//
//  TakePhotoGuideContract.swift
//  Probit
//
//  Created by Đào Mỹ Đông on 08/11/2565 BE.
//  
//

import Foundation

// MARK: View Output (Presenter -> View)
protocol PresenterToViewTakePhotoGuideProtocol: BaseViewProtocol {
}

// MARK: View Input (View -> Presenter)
protocol ViewToPresenterTakePhotoGuideProtocol {
    var view: PresenterToViewTakePhotoGuideProtocol? { get set }
    var interactor: PresenterToInteractorTakePhotoGuideProtocol? { get set }
    var router: PresenterToRouterTakePhotoGuideProtocol? { get set }
}

// MARK: Interactor Input (Presenter -> Interactor)
protocol PresenterToInteractorTakePhotoGuideProtocol {
    var presenter: InteractorToPresenterTakePhotoGuideProtocol? { get set }
}

// MARK: Interactor Output (Interactor -> Presenter)
protocol InteractorToPresenterTakePhotoGuideProtocol {
}

// MARK: Router Input (Presenter -> Router)
protocol PresenterToRouterTakePhotoGuideProtocol {
}
