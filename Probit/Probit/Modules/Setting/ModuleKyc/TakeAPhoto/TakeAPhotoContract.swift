//
//  TakeAPhotoContract.swift
//  Probit
//
//  Created by Đào Mỹ Đông on 07/11/2565 BE.
//  
//

import Foundation
import UIKit

// MARK: View Output (Presenter -> View)
protocol PresenterToViewTakeAPhotoProtocol: BaseViewProtocol {
    func setupCamera()
    func stopCamera()
    func pauseCamera()
    func resumeCamera()
    func popToParentView()
}

// MARK: View Input (View -> Presenter)
protocol ViewToPresenterTakeAPhotoProtocol {
    var view: PresenterToViewTakeAPhotoProtocol? { get set }
    var interactor: PresenterToInteractorTakeAPhotoProtocol? { get set }
    var router: PresenterToRouterTakeAPhotoProtocol? { get set }
    func viewDidLoad()
    func uploaImage(image: UIImage)
}

// MARK: Interactor Input (Presenter -> Interactor)
protocol PresenterToInteractorTakeAPhotoProtocol {
    var presenter: InteractorToPresenterTakeAPhotoProtocol? { get set }
    var stylePhoto: StylePhoto { get }
    func getData()
    func uploaImage(image: UIImage)
}

// MARK: Interactor Output (Interactor -> Presenter)
protocol InteractorToPresenterTakeAPhotoProtocol {
    func getDataFailed(_ error: ServiceError)
    func uploadImageSucced()
    func updateImageFailed()
}

// MARK: Router Input (Presenter -> Router)
protocol PresenterToRouterTakeAPhotoProtocol {
}
