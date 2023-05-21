//
//  KycAddressInputContract.swift
//  Probit
//
//  Created by Bradley Hoang on 09/11/2022.
//  
//

import Foundation

// MARK: View Output (Presenter -> View)
protocol PresenterToViewKycAddressInputProtocol: BaseViewProtocol {
    func updateViewPersonal()
    func enableNextButton(_ enable: Bool)
}

// MARK: View Input (View -> Presenter)
protocol ViewToPresenterKycAddressInputProtocol {
    var view: PresenterToViewKycAddressInputProtocol? { get set }
    var interactor: PresenterToInteractorKycAddressInputProtocol? { get set }
    var router: PresenterToRouterKycAddressInputProtocol? { get set }
    func viewDidLoad()
    func updatePersionalDataKyc(_ data: [String: String])
    func handleNextButtonState(_ address: String, city: String, postalCode: String)
}

// MARK: Interactor Input (Presenter -> Interactor)
protocol PresenterToInteractorKycAddressInputProtocol {
    var presenter: InteractorToPresenterKycAddressInputProtocol? { get set }
    var personalInfor: [String: String] { get }
    func getData()
    func updatePersionalDataKyc(_ data: [String: String])
    var pageType: UserKycStatusDetailModel.PageType { get }
}

// MARK: Interactor Output (Interactor -> Presenter)
protocol InteractorToPresenterKycAddressInputProtocol {
    func getDataFailed(_ error: ServiceError)
    func updateDataSuccess()
    func getDataCompleted()
}

// MARK: Router Input (Presenter -> Router)
protocol PresenterToRouterKycAddressInputProtocol {
}
