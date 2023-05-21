//
//  KycUpdateInformationPresenter.swift
//  Probit
//
//  Created by Bradley Hoang on 10/11/2022.
//  
//

import Foundation

class KycUpdateInformationPresenter: ViewToPresenterKycUpdateInformationProtocol {
    
    // MARK: - Private Variable
    private var dateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter
    }
    
    // MARK: Properties
    var view: PresenterToViewKycUpdateInformationProtocol?
    var interactor: PresenterToInteractorKycUpdateInformationProtocol?
    var router: PresenterToRouterKycUpdateInformationProtocol?
    
    var dateOfBirth: Date?
    var isValidDateOfBirth: Bool {
        return interactor?.isValidDateOfBirth ?? false
    }
    
    func selectDateOfBirth(_ date: Date?) {
        guard let date = date else { return }
        dateOfBirth = date
        interactor?.validateDateOfBirth(date)
        view?.updateDateOfBirthLabel(dateFormatter.string(from: date))
    }
    
    func viewDidLoad() {
        view?.showLoading()
        interactor?.getData()
    }
    
    func updatePersionalDataKyc(_ data: [String : String]) {
        view?.showLoading()
        interactor?.updatePersionalDataKyc(data)
    }
}

// MARK: - InteractorToPresenter
extension KycUpdateInformationPresenter: InteractorToPresenterKycUpdateInformationProtocol {
    func updateDataSuccess() {
        view?.hideLoading()
        router?.navigateComplateVC()
    }
    
    func getDataCompleted() {
        view?.hideLoading()
        view?.reloadView()
    }
    
    func getDataFailed(_ error: ServiceError) {
        view?.hideLoading()
        view?.showError(error: error)
    }
    
    func validateDateOfBirthCompleted() {
        if isValidDateOfBirth {
            view?.hideDateOfBirthError()
        } else {
            view?.showDateOfBirthError()
        }
    }
}
