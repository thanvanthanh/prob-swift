//
//  UploadGovermentContract.swift
//  Probit
//
//  Created by Đào Mỹ Đông on 09/11/2565 BE.
//  
//

import Foundation

// MARK: View Output (Presenter -> View)
protocol PresenterToViewUploadGovermentProtocol: BaseViewProtocol {
    func reloadView()
}

// MARK: View Input (View -> Presenter)
protocol ViewToPresenterUploadGovermentProtocol {
    var view: PresenterToViewUploadGovermentProtocol? { get set }
    var interactor: PresenterToInteractorUploadGovermentProtocol? { get set }
    var router: PresenterToRouterUploadGovermentProtocol? { get set }
    func viewDidLoad()
}

// MARK: Interactor Input (Presenter -> Interactor)
protocol PresenterToInteractorUploadGovermentProtocol {
    var presenter: InteractorToPresenterUploadGovermentProtocol? { get set }
    var stylePhoto: StylePhoto? { get }
    func getData()
    var pageType: UserKycStatusDetailModel.PageType { get }
}

// MARK: Interactor Output (Interactor -> Presenter)
protocol InteractorToPresenterUploadGovermentProtocol {
    func getDataFailed(_ error: ServiceError)
    func getDataCompleted()
}

// MARK: Router Input (Presenter -> Router)
protocol PresenterToRouterUploadGovermentProtocol {
}
