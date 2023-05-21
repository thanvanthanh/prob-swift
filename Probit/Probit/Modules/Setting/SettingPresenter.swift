//
//  SettingPresenter.swift
//  Probit
//
//  Created by Thân Văn Thanh on 29/08/2022.
//  
//

import Foundation
import UIKit

class SettingPresenter: ViewToPresenterSettingProtocol {
    
    // MARK: Properties
    var view: PresenterToViewSettingProtocol?
    var interactor: PresenterToInteractorSettingProtocol?
    var router: PresenterToRouterSettingProtocol?
    var profileInfo: ProfileInfo? { interactor?.profileInfo }
    var membershipData: MembershipModel? { interactor?.membershipData }
    var getPayInProbData: GetPayInProbModel? { interactor?.getPayInProbData }
    var referrerCount: String? { interactor?.referrerCount }
    var feesDiscount: String? { interactor?.feesDiscount }
    var currentKyc: String? { interactor?.currentKyc }
    var iconColor: UIColor? { interactor?.iconColor }
    var kycWarning: String? { interactor?.kycWarning }
    var kycButtonTitle: String? { interactor?.kycButtonTitle }
    var userKycStatus: UserKycStatusModel? { interactor?.kycStatusData}
    var hasProbToken: Bool { interactor?.hasProbToken ?? false }
    
    func getData() {
        view?.showLoading()
        interactor?.getData()
    }
    
    func getProfile() {
        interactor?.getProfile()
    }
    
    func postPayInProb(param: Bool) {
        interactor?.postPayInProb(param: param)
    }
    
    func navigateToLogin() {
        router?.navigateToLogin()
    }
    
    func navigateToReferral() {
        router?.navigateToReferral()
    }
    
    func navigateToMembership() {
        router?.navigateToMembership()
    }
    
    func navigateToAppSetting() {
        router?.navigateToAppSetting()
    }
    func navigateToAnnouncements(viewcontroller: BaseViewController) {
        router?.navigateToAnnouncements(viewcontroller: viewcontroller)
    }
    
    func navigateToHomePage(viewcontroller: BaseViewController) {
        router?.navigateToHomePage(viewcontroller: viewcontroller)
    }
    
    func navigateToPurchase() {
        router?.navigateToPurchase()
    }
    
    func navigateToHome() {
        router?.navigateToHome()
    }
    
    func navigateToVerifyKyc() {
        guard let kycStatusModel = self.interactor?.kycStatusData?.data else { return }
        router?.navigateToVerifyKyc(kycStatusModel: kycStatusModel)
    }
}

extension SettingPresenter: InteractorToPresenterSettingProtocol {
    
    func callingApiComplete() {
        view?.hideLoading()
        view?.callingApiComplete()
        
    }
    
    func loadApiError() {
        view?.hideLoading()
        view?.loadApiError()
    }
    
    func postFeesSwitchComplete(msg: String) {
        view?.postFeesSwitchComplete(msg: msg)
    }
    
}
