//
//  KycPersonalInfoInputPresenter.swift
//  Probit
//
//  Created by Bradley Hoang on 08/11/2022.
//  
//

import Foundation

class KycPersonalInfoInputPresenter: ViewToPresenterKycPersonalInfoInputProtocol {
    // MARK: - Private Variable
    private var dateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return dateFormatter
    }
    private var fullName: String = ""
    
    // MARK: Properties
    var view: PresenterToViewKycPersonalInfoInputProtocol?
    var interactor: PresenterToInteractorKycPersonalInfoInputProtocol?
    var router: PresenterToRouterKycPersonalInfoInputProtocol?
    
    var gender: GenderType?
    var dateOfBirth: Date?
    var isValidDateOfBirth: Bool {
        return interactor?.isValidDateOfBirth ?? false
    }
    
    func selectGender(_ gender: GenderType) {
        self.gender = gender
        view?.updateSelectedGender(gender)
        enableNextButtonIfNeeded()
    }
    
    func selectDateOfBirth(_ date: Date?) {
        guard let date = date else { return }
        dateOfBirth = date
        interactor?.validateDateOfBirth(date)
        view?.updateDateOfBirthLabel(dateFormatter.string(from: date))
        enableNextButtonIfNeeded()
    }
    
    func viewDidLoad() {
        self.view?.showLoading()
        self.interactor?.getData()
    }
    
    func updatePersionalDataKyc(_ data: [String: String]) {
        self.view?.showLoading()
        self.interactor?.updatePersionalDataKyc(data)
    }
    
    func changeFullName(_ fullName: String) {
        self.fullName = fullName
        enableNextButtonIfNeeded()
    }
    
    private func enableNextButtonIfNeeded() {
        let isValidGender = gender != nil
        let isValidFullName = !fullName.isEmpty
        let hasFullInformation = isValidDateOfBirth && isValidGender && isValidFullName
        
        view?.enableNextButton(hasFullInformation)
    }
}

// MARK: - InteractorToPresenter
extension KycPersonalInfoInputPresenter: InteractorToPresenterKycPersonalInfoInputProtocol {
    func getDataCompleted() {
        self.view?.hideLoading()
        self.view?.updateViewPersonal()
    }
    
    func updateDataSuccess() {
        self.view?.hideLoading()
        KycAddressInputRouter().showScreen()
    }
    
    func getDataFailed(_ error: ServiceError) {
        self.view?.hideLoading()
        self.view?.showError(error: error)
    }
    
    func validateDateOfBirthCompleted() {
        if isValidDateOfBirth {
            view?.hideDateOfBirthError()
        } else {
            view?.showDateOfBirthError()
        }
    }
}
