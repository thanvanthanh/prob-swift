//
//  PurchaseContract.swift
//  Probit
//
//  Created by Bradley Hoang on 27/09/2022.
//  
//

import Foundation

// MARK: View Output (Presenter -> View)
protocol PresenterToViewPurchaseProtocol {
    func showLoading()
    func hideLoading()
    func updateUI()
    func updateCountdownTime(with time: Int, isBlink: Bool)
    func showError(error: ServiceError)
    func showSuccess(message: String)
    func showCompleteVC(purchaseModel: PurchaseModel, oldMemberShip: MembershipDetailModel?)
}

// MARK: View Input (View -> Presenter)
protocol ViewToPresenterPurchaseProtocol {
    var view: PresenterToViewPurchaseProtocol? { get set }
    var interactor: PresenterToInteractorPurchaseProtocol? { get set }
    var router: PresenterToRouterPurchaseProtocol? { get set }
    var membership: MembershipDetailModel? { get }
    var coinConversionConfig: CoinConversionConfigModel? { get }
    var userBalances: [UserBalance] { get }
    var stakeCurrency: StakeCurrency? { get }
    func viewDidLoad()
    func startTimer()
    func buyCurrency()
}

// MARK: Interactor Input (Presenter -> Interactor)
protocol PresenterToInteractorPurchaseProtocol {
    var presenter: InteractorToPresenterPurchaseProtocol? { get set }
    func getConversionRate(completed: @escaping() -> Void) 
    var membership: MembershipDetailModel? { get }
    var coinConversionConfig: CoinConversionConfigModel? { get }
    var purchaseConversionRate: PurchaseConversionRate? { get }
    var userBalances: [UserBalance] { get }
    var stakeCurrency: StakeCurrency? { get }
    var walletCurrency: WalletCurrency? { get }
    var purchaseRequest: PurchaseRequest { get set}
    func getDataLoged()
    func reloadDataLoged(purchaseModel: PurchaseModel)
    func getDataWithoutLogin()
    func startTimer()
    func stopTimer()
    func buyCurrency()
}

// MARK: Interactor Output (Interactor -> Presenter)
protocol InteractorToPresenterPurchaseProtocol {
    func getDataSuccess()
    func getDataFailed(_ error: ServiceError)
    func updateCountdownTime(with time: Int, isBlink: Bool)
    func purchaseSucces(purchaseModel: PurchaseModel)
    func reloadConversionRate()
    func reloadDataLogedSuccess(purchaseModel: PurchaseModel, oldMemberShip: MembershipDetailModel?)
}

// MARK: Router Input (Presenter -> Router)
protocol PresenterToRouterPurchaseProtocol {
}
