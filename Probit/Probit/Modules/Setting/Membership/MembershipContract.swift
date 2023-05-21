//
//  MembershipContract.swift
//  Probit
//
//  Created by Thân Văn Thanh on 30/08/2022.
//  
//

import Foundation

// MARK: View Output (Presenter -> View)
protocol PresenterToViewMembershipProtocol: BaseViewProtocol {
    func callingApiComplete()
    func loadApiError()
}

// MARK: View Input (View -> Presenter)
protocol ViewToPresenterMembershipProtocol {
    
    var view: PresenterToViewMembershipProtocol? { get set }
    var interactor: PresenterToInteractorMembershipProtocol? { get set }
    var router: PresenterToRouterMembershipProtocol? { get set }
    var stakeInteracter: StakeDetailsInteractorProtocol? { get set }
    var membershipData: MembershipModel? { get }
    var userBalanceData: String? { get }
    var feesDiscount: String? { get }
    var progressBarRate: Float? { get }
    var myStakeAmount: String? { get }
    var countProbToLevel: String? { get }
    func getData()
    func navigateToTradingFeeWebsite(viewcontroller: BaseViewController)
    func navigateToStake()
}

// MARK: Interactor Input (Presenter -> Interactor)
protocol PresenterToInteractorMembershipProtocol {
    var presenter: InteractorToPresenterMembershipProtocol? { get set }
    var entity: InteractorToEntityMembershipProtocol? { get set }
    var membershipData: MembershipModel? { get set }
    var userBalanceData: String? { get set }
    var feesDiscount: String? { get set }
    var progressBarRate: Float? { get set }
    var myStakeAmount: String? { get set }
    var countProbToLevel: String? { get set }
    func getData()
}

// MARK: Interactor Output (Interactor -> Presenter)
protocol InteractorToPresenterMembershipProtocol {
    func callingApiComplete()
    func loadApiError()
}

// MARK: Router Input (Presenter -> Router)
protocol PresenterToRouterMembershipProtocol {
    func navigateToTradingFeeWebsite(viewcontroller: BaseViewController)
}

protocol InteractorToEntityMembershipProtocol {
    func membership(completionHandler: @escaping (Result<MembershipModel, ServiceError>) -> Void)
    func getUserBalance(completionHandler: @escaping (Result<GetUserBalanceResponse, ServiceError>) -> Void)
}
