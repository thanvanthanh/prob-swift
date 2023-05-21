//
//  KycSelectCountryContract.swift
//  Probit
//
//  Created by Bradley Hoang on 02/11/2022.
//  
//

import Foundation

// MARK: View Output (Presenter -> View)
protocol PresenterToViewKycSelectCountryProtocol: BaseViewProtocol {
    func selectedCountry(_ country: Country)
    func showIneligibleCountryError(isShow: Bool)
}

// MARK: View Input (View -> Presenter)
protocol ViewToPresenterKycSelectCountryProtocol {
    var view: PresenterToViewKycSelectCountryProtocol? { get set }
    var interactor: PresenterToInteractorKycSelectCountryProtocol? { get set }
    var router: PresenterToRouterKycSelectCountryProtocol? { get set }
    
    var isSelectIneligibleCountry: Bool { get }
    
    func navigateToKycListCountries(delegate: KycListCountriesDelegate)
    func navigateToPersonalInfoInput()
    func updateDataCountry()
    func viewDidLoad()
    func selectedCountry(_ country: Country)
}

// MARK: Interactor Input (Presenter -> Interactor)
protocol PresenterToInteractorKycSelectCountryProtocol {
    var presenter: InteractorToPresenterKycSelectCountryProtocol? { get set }
    
    var isSelectIneligibleCountry: Bool { get set }
    var selectedCountry: Country? { get set }
    var pageType: UserKycStatusDetailModel.PageType { get }
    
    func getData()
    func updateCountry()
    func selectedCountry(_ country: Country)
}

// MARK: Interactor Output (Interactor -> Presenter)
protocol InteractorToPresenterKycSelectCountryProtocol {
    func getDataCompleted()
    func getDataFailed(_ error: ServiceError)
    func updateDataSuccess()
    func selectedValidCountry(_ country: Country)
    func selectedIneligibleCountry(_ country: Country)
}

// MARK: Router Input (Presenter -> Router)
protocol PresenterToRouterKycSelectCountryProtocol {
    func navigateToKycListCountries(delegate: KycListCountriesDelegate,
                                    selectedCountry: Country?)
    func navigateToPersonalInfoInput()
}
