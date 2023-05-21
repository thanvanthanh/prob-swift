//
//  SettingContract.swift
//  Probit
//
//  Created by Thân Văn Thanh on 29/08/2022.
//  
//

import Foundation
import UIKit

// MARK: View Output (Presenter -> View)
protocol PresenterToViewSettingProtocol: BaseViewProtocol {
    func callingApiComplete()
    func loadApiError()
    func postFeesSwitchComplete(msg: String)
}

// MARK: View Input (View -> Presenter)
protocol ViewToPresenterSettingProtocol {
    
    var view: PresenterToViewSettingProtocol? { get set }
    var interactor: PresenterToInteractorSettingProtocol? { get set }
    var router: PresenterToRouterSettingProtocol? { get set }
    var membershipData: MembershipModel? { get }
    var getPayInProbData: GetPayInProbModel? { get }
    var userKycStatus: UserKycStatusModel? { get }
    var profileInfo: ProfileInfo? { get }
    var feesDiscount: String? { get }
    var referrerCount: String? { get }
    var currentKyc: String? { get }
    var iconColor: UIColor? { get }
    var kycWarning: String? { get }
    var hasProbToken: Bool { get }
    var kycButtonTitle: String? { get }
    func getData()
    func getProfile()
    func postPayInProb(param: Bool)
    func navigateToPurchase()
    func navigateToLogin()
    func navigateToReferral()
    func navigateToMembership()
    func navigateToAppSetting()
    func navigateToAnnouncements(viewcontroller: BaseViewController)
    func navigateToHomePage(viewcontroller: BaseViewController)
    func navigateToHome()
    func navigateToVerifyKyc()
}

// MARK: Interactor Input (Presenter -> Interactor)
protocol PresenterToInteractorSettingProtocol {
    var presenter: InteractorToPresenterSettingProtocol? { get set }
    var entity: InteractorToEntitySettingProtocol? { get set }
    var membershipData: MembershipModel? { get set }
    var getPayInProbData: GetPayInProbModel? { get set }
    var kycStatusData: UserKycStatusModel? { get set }
    var profileInfo: ProfileInfo? { get set }
    var feesDiscount: String? { get set }
    var referrerCount: String? { get set }
    var currentKyc: String? { get set }
    var iconColor: UIColor? { get set }
    var kycWarning: String? { get set }
    var kycButtonTitle: String? { get set }
    var hasProbToken: Bool { get }
    func getData()
    func getProfile()
    func postPayInProb(param: Bool)
}

// MARK: Interactor Output (Interactor -> Presenter)
protocol InteractorToPresenterSettingProtocol {
    func callingApiComplete()
    func loadApiError()
    func postFeesSwitchComplete(msg: String)
}

// MARK: Router Input (Presenter -> Router)
protocol PresenterToRouterSettingProtocol {
    func navigateToLogin()
    func navigateToReferral()
    func navigateToMembership()
    func navigateToAppSetting()
    func navigateToAnnouncements(viewcontroller: BaseViewController)
    func navigateToHomePage(viewcontroller: BaseViewController)
    func navigateToPurchase()
    func navigateToHome()
    func navigateToVerifyKyc(kycStatusModel: UserKycStatusDetailModel)
}

protocol InteractorToEntitySettingProtocol {
    func membership(completionHandler: @escaping (Result<MembershipModel, ServiceError>) -> Void)
    func referrerCount(completionHandler: @escaping (Result<ReferrerCountModel, ServiceError>) -> Void)
    func getPayInProb(completionHandler: @escaping (Result<GetPayInProbModel, ServiceError>) -> Void)
    func postPayInProb(param: Bool,
                       completionHandler: @escaping (Result<PostPayInProbModel, ServiceError>) -> Void)
    func checkStep(completionHandler: @escaping (Result<CheckStepModel, ServiceError>) -> Void)
    func userKycStatus(completionHandler: @escaping (Result<UserKycStatusModel, ServiceError>) -> Void)
    func getProfileInfo(completionHandler: @escaping (Result<ProfileInfo, ServiceError>) -> Void)
    func getBalance(completion: @escaping (Result<GetUserBalanceResponse, ServiceError>) -> Void)
    func getPhoneNumber(completion: @escaping (Result<PrimaryphoneResponse, ServiceError>) -> Void)
}
