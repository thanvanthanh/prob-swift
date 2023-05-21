//
//  AppSettingPresenter.swift
//  Probit
//
//  Created by Thân Văn Thanh on 30/08/2022.
//  
//

import Foundation

class AppSettingPresenter: ViewToPresenterAppSettingProtocol {

    // MARK: Properties
    var view: PresenterToViewAppSettingProtocol?
    var interactor: PresenterToInteractorAppSettingProtocol?
    var router: PresenterToRouterAppSettingProtocol?
    var currentData: TickerColor? = AppConstant.tickerColor
    
    func navigateToTickerColor(delegate: TickerColorDelegate) {
        router?.navigateToTickerColor(delegate: delegate,
                                      currentData: currentData ?? .option1)
    }
    
    func updateData(option: TickerColor) {
        currentData = option
        view?.reloadCurrencyData(option: option)
    }
    
    func navigateToTermsAndPolicies() {
        router?.navigateToTermsAndPolicies()
    }
    
    func navigateToNotifications() {
        router?.navigateToNotifications()
    }
    
    func navigateToAppLock() {
        router?.navigateToAppLock()
    }
    
    func navigateToProBitWebsite(viewController: BaseViewController) {
        router?.navigateToProBitWebsite(viewController: viewController)
    }
}

extension AppSettingPresenter: InteractorToPresenterAppSettingProtocol {
    func navigateToAppSettingLanguage() {
        router?.navigateToAppSettingLanguage()
    }
    
    func navigateToAppInfo() {
        router?.navigateToAppInfo()
    }
}
