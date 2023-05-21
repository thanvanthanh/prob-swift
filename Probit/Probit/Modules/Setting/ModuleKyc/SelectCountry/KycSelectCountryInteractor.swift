//
//  KycSelectCountryInteractor.swift
//  Probit
//
//  Created by Bradley Hoang on 02/11/2022.
//  
//

import Foundation

class KycSelectCountryInteractor: PresenterToInteractorKycSelectCountryProtocol {

    
    // MARK: - Private Variable
    private var countryNames: [String: String] = [:]
    private var ineligibleCountries: [String] = []
    private var selectKey: String?
    
    // MARK: Properties
    var presenter: InteractorToPresenterKycSelectCountryProtocol?
    var isSelectIneligibleCountry: Bool = false
    var selectedCountry: Country?
    let pageType = UserKycStatusDetailModel.PageType.country

    
    func getData() {
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        getCountryNames {
            dispatchGroup.leave()
        }
        dispatchGroup.enter()
        validatePage(page: pageType) {
            dispatchGroup.leave()
        }
        dispatchGroup.enter()
        getListIneligibleKycCountries {
            dispatchGroup.leave()
        }
        dispatchGroup.enter()
        getDataKyc(page: pageType) {
            dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .main) { [weak self]  in
            guard let self = self else { return }
            if let selectKey = self.selectKey,
               let name = self.countryNames[selectKey] {
                let selectedCountry = Country(shortName: selectKey, fullName: name)
                self.selectedCountry(selectedCountry)
            }
            self.presenter?.getDataCompleted()
        }
    }
    
    func updateCountry() {
        guard let selectedCountry = selectedCountry else { return }
        updateDataKyc(data: ["country": selectedCountry.shortName])
    }
    
    func selectedCountry(_ country: Country) {
        selectedCountry = country
        if ineligibleCountries.contains(where: { $0 == country.shortName }) {
            isSelectIneligibleCountry = true
            presenter?.selectedIneligibleCountry(country)
        } else {
            isSelectIneligibleCountry = false
            presenter?.selectedValidCountry(country)
        }
    }
}

// MARK: - Private
private extension KycSelectCountryInteractor {
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
    
    func getDataKyc(page: UserKycStatusDetailModel.PageType,
                    completion: @escaping () -> Void) {
        SettingAPI.shared.getGlobalKycData(page: page) { [weak self] result in
            defer { completion() }
            guard let self = self else { return }
            switch result {
            case let .success(res):
                if let country = res.data[page.rawValue] {
                    self.selectKey = country
                } else {
                    self.selectKey = self.getAlpha3CodeFromCurrentRegion()
                }
                
            case let .failure(error):
                self.presenter?.getDataFailed(error)
            }
        }
    }
    
    func updateDataKyc(data: [String: String]) {
        SettingAPI.shared.updateDataKyc(data: data) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(_ ):
                self.presenter?.updateDataSuccess()
            case .failure(let error):
                self.presenter?.getDataFailed(error)
            }
        }
    }
    
    func validatePage(page: UserKycStatusDetailModel.PageType, completion: @escaping () -> Void) {
        SettingAPI.shared.validatePageKyc(page: page) { [weak self] result in
            defer { completion() }
            guard let self = self else { return }
            switch result {
            case .success(_ ):
                return
            case .failure(let error):
                self.presenter?.getDataFailed(error)
            }
        }
    }
    
    func getListIneligibleKycCountries(completion: @escaping () -> Void) {
        SettingAPI.shared.getListIneligibleKycCountries { [weak self] result in
            defer { completion() }
            guard let self = self else { return }
            switch result {
            case let .success(ineligibleCountries):
                self.ineligibleCountries = ineligibleCountries
                
            case let .failure(error):
                self.presenter?.getDataFailed(error)
            }
        }
    }
    
    func getAlpha3CodeFromCurrentRegion() -> String? {
        let currentAlpha2Code = Locale.current.regionCode
        
        if let path = Bundle.main.path(forResource: "countries", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let alpha23Countries = try JSONDecoder().decode([Alpha23Country].self, from: data)
                return alpha23Countries.first(where: { $0.alpha2 == currentAlpha2Code })?.alpha3
                
            } catch {
                return nil
            }
        }
        return nil
    }
}
