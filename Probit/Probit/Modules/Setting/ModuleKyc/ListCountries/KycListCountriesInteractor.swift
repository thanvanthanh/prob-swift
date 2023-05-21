//
//  KycListCountriesInteractor.swift
//  Probit
//
//  Created by Bradley Hoang on 02/11/2022.
//  
//

import Foundation

class KycListCountriesInteractor: PresenterToInteractorKycListCountriesProtocol {
    
    // MARK: - Private Variable
    private var countryNames: [String: String] = [:]
    private var countries: [String] = []
    
    // MARK: Properties
    var presenter: InteractorToPresenterKycListCountriesProtocol?
    
    var filterCountries: [String: String] = [:]
    
    func getData() {
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        getCountryNames {
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        getListKycCountries {
            dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .main) { [weak self]  in
            guard let self = self else { return }
            self.countryNames = self.countryNames.filter { self.countries.contains($0.key) }
            self.filterCountries = self.countryNames
            self.presenter?.getDataCompleted()
        }
    }
    
    func filterCountries(by keyword: String) {
        guard !keyword.isEmpty else {
            filterCountries = countryNames
            presenter?.filterCountriesCompleted()
            return
        }
        
        filterCountries = countryNames.filter { country in
            let normalizeCountryId = country.key.folding(options: [.diacriticInsensitive,
                                                                   .widthInsensitive,
                                                                   .caseInsensitive],
                                                         locale: .current)
            let normalizeCountryName = country.value.folding(options: [.diacriticInsensitive,
                                                                       .widthInsensitive,
                                                                       .caseInsensitive],
                                                             locale: .current)
            
            let searchKeyword = keyword.lowercased()
            let searchId = normalizeCountryId.lowercased()
            let searchName = normalizeCountryName.lowercased()
            
            let hasId = searchId.hasPrefix(searchKeyword)
            let hasName = searchName.hasPrefix(searchKeyword)
            
            return hasId || hasName
        }
        
        presenter?.filterCountriesCompleted()
    }
}

// MARK: - Private
private extension KycListCountriesInteractor {
    func getCountryNames(completion: @escaping () -> Void) {
        SettingAPI.shared.getCountryNames(locale: AppConstant.locale) { [weak self] result in
            defer { completion() }
            guard let self = self else { return }
            switch result {
            case let .success(countryNames):
                self.countryNames = countryNames
            case let .failure(error):
                self.presenter?.getDataFailed(error)
            }
        }
    }
    
    func getListKycCountries(completion: @escaping () -> Void) {
        SettingAPI.shared.getListKycCountries { [weak self] result in
            defer { completion() }
            guard let self = self else { return }
            switch result {
            case let .success(countries):
                self.countries = countries
                
            case let .failure(error):
                self.presenter?.getDataFailed(error)
            }
        }
    }
}
