//
//  KycListCountriesPresenter.swift
//  Probit
//
//  Created by Bradley Hoang on 02/11/2022.
//  
//

import Foundation
import UIKit

struct Country {
    var shortName: String
    var fullName: String
}

class KycListCountriesPresenter: ViewToPresenterKycListCountriesProtocol {
    // MARK: Properties
    var view: PresenterToViewKycListCountriesProtocol?
    var interactor: PresenterToInteractorKycListCountriesProtocol?
    var router: PresenterToRouterKycListCountriesProtocol?
    var delegate: KycListCountriesDelegate?
    
    var selectedCountry: Country?
    var filterCountries: [Country] {
        let countries = interactor?.filterCountries.compactMap { Country(shortName: $0.key, fullName: $0.value)}
        return countries?.sorted(by: {$0.fullName < $1.fullName}) ?? []
    }
    
    func onViewDidLoad() {
        view?.showLoading()
        interactor?.getData()
    }
    
    func onSelectTableViewCell(at index: Int) {
        guard filterCountries.indices.contains(index) else { return }
        delegate?.kycListCountriesDidSelectCountry(filterCountries[index])
    }
    
    func onPopToPreviousView(from vc: UIViewController) {
        router?.popToPreviousView(from: vc)
    }
    
    func onChangeSearchBar(keyword: String) {
        interactor?.filterCountries(by: keyword)
    }
}

// MARK: - InteractorToPresenter
extension KycListCountriesPresenter: InteractorToPresenterKycListCountriesProtocol {
    func getDataCompleted() {
        view?.hideLoading()
        view?.reloadTableViewData()
    }
    
    func getDataFailed(_ error: ServiceError) {
        view?.hideLoading()
        view?.showError(error: error)
    }
    
    func filterCountriesCompleted() {
        view?.reloadTableViewData()
    }
}
