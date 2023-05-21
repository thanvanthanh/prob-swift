//
//  KycPersonalInfoInputContract.swift
//  Probit
//
//  Created by Bradley Hoang on 08/11/2022.
//  
//

import Foundation

// MARK: View Output (Presenter -> View)
protocol PresenterToViewKycPersonalInfoInputProtocol: BaseViewProtocol {
    func updateSelectedGender(_ gender: GenderType)
    func updateDateOfBirthLabel(_ dateString: String)
    func showDateOfBirthError()
    func hideDateOfBirthError()
    func updateViewPersonal()
    func enableNextButton(_ enable: Bool)
}

// MARK: View Input (View -> Presenter)
protocol ViewToPresenterKycPersonalInfoInputProtocol {
    var view: PresenterToViewKycPersonalInfoInputProtocol? { get set }
    var interactor: PresenterToInteractorKycPersonalInfoInputProtocol? { get set }
    var router: PresenterToRouterKycPersonalInfoInputProtocol? { get set }
    
    var gender: GenderType? { get set }
    var dateOfBirth: Date? { get set }
    var isValidDateOfBirth: Bool { get }
    func selectGender(_ gender: GenderType)
    func selectDateOfBirth(_ date: Date?)
    func changeFullName(_ fullName: String)
    func viewDidLoad()
    func updatePersionalDataKyc(_ data: [String: String])
}

// MARK: Interactor Input (Presenter -> Interactor)
protocol PresenterToInteractorKycPersonalInfoInputProtocol {
    var presenter: InteractorToPresenterKycPersonalInfoInputProtocol? { get set }
    func getData()
    var isValidDateOfBirth: Bool { get set }
    var personalInfor: [String: String] { get }
    func validateDateOfBirth(_ dateOfBirth: Date)
    func updatePersionalDataKyc(_ data: [String: String])
    var pageType: UserKycStatusDetailModel.PageType { get }
}

// MARK: Interactor Output (Interactor -> Presenter)
protocol InteractorToPresenterKycPersonalInfoInputProtocol {
    func validateDateOfBirthCompleted()
    func getDataCompleted()
    func updateDataSuccess()
    func getDataFailed(_ error: ServiceError)
}

// MARK: Router Input (Presenter -> Router)
protocol PresenterToRouterKycPersonalInfoInputProtocol {
}
