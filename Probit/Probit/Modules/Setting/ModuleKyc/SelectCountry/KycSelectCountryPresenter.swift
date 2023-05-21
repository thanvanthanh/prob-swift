//
//  KycSelectCountryPresenter.swift
//  Probit
//
//  Created by Bradley Hoang on 02/11/2022.
//  
//

import Foundation

class KycSelectCountryPresenter: ViewToPresenterKycSelectCountryProtocol {
    // MARK: Properties
    var view: PresenterToViewKycSelectCountryProtocol?
    var interactor: PresenterToInteractorKycSelectCountryProtocol?
    var router: PresenterToRouterKycSelectCountryProtocol?
    
    var selectedCountry: Country? {
        return interactor?.selectedCountry
    }
    var isSelectIneligibleCountry: Bool {
        return interactor?.isSelectIneligibleCountry ?? false
    }
    
    func navigateToKycListCountries(delegate: KycListCountriesDelegate) {
        router?.navigateToKycListCountries(delegate: delegate,
                                           selectedCountry: selectedCountry)
    }
    
    func navigateToPersonalInfoInput() {
        router?.navigateToPersonalInfoInput()
    }
    
    func viewDidLoad() {
        view?.showLoading()
        interactor?.getData()
    }
    
    func updateDataCountry() {
        view?.showLoading()
        interactor?.updateCountry()
    }
    
    func selectedCountry(_ country: Country) {
        interactor?.selectedCountry(country)
    }
}

// MARK: - InteractorToPresenter
extension KycSelectCountryPresenter: InteractorToPresenterKycSelectCountryProtocol {
    func updateDataSuccess() {
        view?.hideLoading()
        router?.navigateToPersonalInfoInput()
    }
    
    func getDataCompleted() {
        view?.hideLoading()
    }
    
    func getDataFailed(_ error: ServiceError) {
        view?.hideLoading()
        view?.showError(error: error)
    }
    
    func selectedIneligibleCountry(_ country: Country) {
        view?.selectedCountry(country)
        view?.showIneligibleCountryError(isShow: true)
    }
    
    func selectedValidCountry(_ country: Country) {
        view?.selectedCountry(country)
        view?.showIneligibleCountryError(isShow: false)
    }
}
