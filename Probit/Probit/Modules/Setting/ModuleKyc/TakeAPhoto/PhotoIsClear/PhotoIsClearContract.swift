//
//  PhotoIsClearContract.swift
//  Probit
//
//  Created by Đào Mỹ Đông on 08/11/2565 BE.
//  
//

import Foundation

// MARK: View Output (Presenter -> View)
protocol PresenterToViewPhotoIsClearProtocol: BaseViewProtocol {
    func reloadView()
}

// MARK: View Input (View -> Presenter)
protocol ViewToPresenterPhotoIsClearProtocol {
    var view: PresenterToViewPhotoIsClearProtocol? { get set }
    var interactor: PresenterToInteractorPhotoIsClearProtocol? { get set }
    var router: PresenterToRouterPhotoIsClearProtocol? { get set }
    func nextStep()
    func viewDidLoad()
    func reTakePhoto()
}

// MARK: Interactor Input (Presenter -> Interactor)
protocol PresenterToInteractorPhotoIsClearProtocol {
    var presenter: InteractorToPresenterPhotoIsClearProtocol? { get set }
    var dataKyc: [String: String] { get }
    var stylePhoto: StylePhoto { get }
    func deletePhoto()
    func getData()
    func nextStep()
}

// MARK: Interactor Output (Interactor -> Presenter)
protocol InteractorToPresenterPhotoIsClearProtocol {
    func getDataFailed(_ error: ServiceError)
    func getDataCompleted()
    func deletePhotoSucces()
    func nextScreenLoading()
}

// MARK: Router Input (Presenter -> Router)
protocol PresenterToRouterPhotoIsClearProtocol {
    func navigateReTakePhoto(stylePhoto: StylePhoto)
}
