//
//  ReferralContract.swift
//  Probit
//
//  Created by Thân Văn Thanh on 29/08/2022.
//  
//

import Foundation


// MARK: View Output (Presenter -> View)
protocol PresenterToViewReferralProtocol: BaseViewProtocol {
    func callingApiComplete()
    func loadApiError()
}


// MARK: View Input (View -> Presenter)
protocol ViewToPresenterReferralProtocol {
    
    var view: PresenterToViewReferralProtocol? { get set }
    var interactor: PresenterToInteractorReferralProtocol? { get set }
    var router: PresenterToRouterReferralProtocol? { get set }
    var referrerCount: String? { get }
    var referrerCode: String? { get }
    var commissionFee: String? { get }
    var referrerEarned: [ReferrerEarnedModel]? { get }
    func getData()
}


// MARK: Interactor Input (Presenter -> Interactor)
protocol PresenterToInteractorReferralProtocol {
    
    var presenter: InteractorToPresenterReferralProtocol? { get set }
    var entity: InteractorToEntityReferralProtocol? { get set }
    var referrerCount: String? { get set }
    var referrerCode: String? { get set }
    var commissionFee: String? { get set }
    var referrerEarned: [ReferrerEarnedModel]? { get set }
    func getData()
}


// MARK: Interactor Output (Interactor -> Presenter)
protocol InteractorToPresenterReferralProtocol {
    func callingApiComplete()
    func loadApiError()
}


// MARK: Router Input (Presenter -> Router)
protocol PresenterToRouterReferralProtocol {
    
}

protocol InteractorToEntityReferralProtocol {
    func membership(completionHandler: @escaping (Result<MembershipModel, ServiceError>) -> Void)
    func referrerCount(completionHandler: @escaping (Result<ReferrerCountModel, ServiceError>) -> Void)
    func referrerCode(completionHandler: @escaping (Result<ReferralCodeModel, ServiceError>) -> Void)
    func referrerEarned(completionHandler: @escaping (Result<ReferrerEarned, ServiceError>) -> Void)
}
