//
//  KycUpdateInformationContract.swift
//  Probit
//
//  Created by Bradley Hoang on 10/11/2022.
//  
//

import Foundation

// MARK: View Output (Presenter -> View)
protocol PresenterToViewKycUpdateInformationProtocol: BaseViewProtocol {
    func updateDateOfBirthLabel(_ dateString: String)
    func showDateOfBirthError()
    func hideDateOfBirthError()
    func reloadView()
}

// MARK: View Input (View -> Presenter)
protocol ViewToPresenterKycUpdateInformationProtocol {
    var view: PresenterToViewKycUpdateInformationProtocol? { get set }
    var interactor: PresenterToInteractorKycUpdateInformationProtocol? { get set }
    var router: PresenterToRouterKycUpdateInformationProtocol? { get set }
    var dateOfBirth: Date? { get set }
    var isValidDateOfBirth: Bool { get }
    func selectDateOfBirth(_ date: Date?)
    func viewDidLoad()
    func updatePersionalDataKyc(_ data: [String: String])
}

// MARK: Interactor Input (Presenter -> Interactor)
protocol PresenterToInteractorKycUpdateInformationProtocol {
    var presenter: InteractorToPresenterKycUpdateInformationProtocol? { get set }
    var isValidDateOfBirth: Bool { get set }
    func validateDateOfBirth(_ dateOfBirth: Date)
    func getData()
    var checkData: CheckDataModel? { get }
    func updatePersionalDataKyc(_ data: [String: String])
    var pageType: UserKycStatusDetailModel.PageType { get }
}

// MARK: Interactor Output (Interactor -> Presenter)
protocol InteractorToPresenterKycUpdateInformationProtocol {
    func validateDateOfBirthCompleted()
    func getDataCompleted()
    func getDataFailed(_ error: ServiceError)
    func updateDataSuccess()
}

// MARK: Router Input (Presenter -> Router)
protocol PresenterToRouterKycUpdateInformationProtocol {
    func navigateComplateVC()
}
