//
//  AppSettingContract.swift
//  Probit
//
//  Created by Thân Văn Thanh on 30/08/2022.
//  
//

import Foundation


// MARK: View Output (Presenter -> View)
protocol PresenterToViewAppSettingProtocol {
    func reloadCurrencyData(option: TickerColor)
}


// MARK: View Input (View -> Presenter)
protocol ViewToPresenterAppSettingProtocol {
    
    var view: PresenterToViewAppSettingProtocol? { get set }
    var interactor: PresenterToInteractorAppSettingProtocol? { get set }
    var router: PresenterToRouterAppSettingProtocol? { get set }
    func navigateToAppSettingLanguage()
    func navigateToAppInfo()
    func navigateToTermsAndPolicies()
    func navigateToNotifications()
    func navigateToAppLock()
    func navigateToTickerColor(delegate: TickerColorDelegate)
    func updateData(option: TickerColor)
    func navigateToProBitWebsite(viewController: BaseViewController)
    var currentData: TickerColor? { get set }
}


// MARK: Interactor Input (Presenter -> Interactor)
protocol PresenterToInteractorAppSettingProtocol {
    
    var presenter: InteractorToPresenterAppSettingProtocol? { get set }
}


// MARK: Interactor Output (Interactor -> Presenter)
protocol InteractorToPresenterAppSettingProtocol {
    
}


// MARK: Router Input (Presenter -> Router)
protocol PresenterToRouterAppSettingProtocol {
    func navigateToAppSettingLanguage()
    func navigateToTickerColor(delegate: TickerColorDelegate, currentData: TickerColor)
    func navigateToAppInfo()
    func navigateToTermsAndPolicies()
    func navigateToNotifications()
    func navigateToAppLock()
    func navigateToProBitWebsite(viewController: BaseViewController)
}
