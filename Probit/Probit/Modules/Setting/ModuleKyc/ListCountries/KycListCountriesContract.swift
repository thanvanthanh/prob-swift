//
//  KycListCountriesContract.swift
//  Probit
//
//  Created by Bradley Hoang on 02/11/2022.
//  
//

import Foundation
import UIKit

// MARK: View Output (Presenter -> View)
protocol PresenterToViewKycListCountriesProtocol: BaseViewProtocol {
   func reloadTableViewData()
}

// MARK: View Input (View -> Presenter)
protocol ViewToPresenterKycListCountriesProtocol {
    var view: PresenterToViewKycListCountriesProtocol? { get set }
    var interactor: PresenterToInteractorKycListCountriesProtocol? { get set }
    var router: PresenterToRouterKycListCountriesProtocol? { get set }
    var delegate: KycListCountriesDelegate? { get set }
    
    var selectedCountry: Country? { get set }
    var filterCountries: [Country] { get }
    
    func onViewDidLoad()
    func onSelectTableViewCell(at index: Int)
    func onPopToPreviousView(from vc: UIViewController)
    func onChangeSearchBar(keyword: String)
}

// MARK: Interactor Input (Presenter -> Interactor)
protocol PresenterToInteractorKycListCountriesProtocol {
    var presenter: InteractorToPresenterKycListCountriesProtocol? { get set }
    
    var filterCountries: [String: String] { get set }
    
    func getData()
    func filterCountries(by keyword: String)
}

// MARK: Interactor Output (Interactor -> Presenter)
protocol InteractorToPresenterKycListCountriesProtocol {
    func getDataCompleted()
    func getDataFailed(_ error: ServiceError)
    func filterCountriesCompleted()
}

// MARK: Router Input (Presenter -> Router)
protocol PresenterToRouterKycListCountriesProtocol {
    func popToPreviousView(from vc: UIViewController)
}

protocol KycListCountriesDelegate: AnyObject {
    func kycListCountriesDidSelectCountry(_ country: Country)
}
