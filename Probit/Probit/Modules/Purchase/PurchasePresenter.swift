//
//  PurchasePresenter.swift
//  Probit
//
//  Created by Bradley Hoang on 27/09/2022.
//  
//

import Foundation

final class PurchasePresenter: ViewToPresenterPurchaseProtocol {
    // MARK: Properties
    var view: PresenterToViewPurchaseProtocol?
    var interactor: PresenterToInteractorPurchaseProtocol?
    var router: PresenterToRouterPurchaseProtocol?
    
    var membership: MembershipDetailModel? { interactor?.membership }
    var coinConversionConfig: CoinConversionConfigModel? { interactor?.coinConversionConfig }
    var userBalances: [UserBalance] { interactor?.userBalances ?? [] }
    var stakeCurrency: StakeCurrency? { interactor?.stakeCurrency }
    
    func viewDidLoad() {
        interactor?.startTimer()
        getData()
    }
    
    func startTimer() {
        interactor?.startTimer()
    }
    
    func buyCurrency() {
        view?.showLoading()
        interactor?.buyCurrency()
    }
}

// MARK: - InteractorToPresenterPurchaseProtocol
extension PurchasePresenter: InteractorToPresenterPurchaseProtocol {
    func reloadDataLogedSuccess(purchaseModel: PurchaseModel, oldMemberShip: MembershipDetailModel?) {
        view?.showCompleteVC(purchaseModel: purchaseModel, oldMemberShip: oldMemberShip)
    }
    
    func reloadConversionRate(){
        view?.showLoading()
        self.interactor?.getConversionRate { [weak self] in
            self?.interactor?.startTimer()
            self?.getDataSuccess()
        }
    }
    
    func purchaseSucces(purchaseModel: PurchaseModel) {
        view?.hideLoading()
        interactor?.reloadDataLoged(purchaseModel: purchaseModel)
    }
    
    func getDataSuccess() {
        view?.updateUI()
        view?.hideLoading()
    }
    
    func getDataFailed(_ error: ServiceError) {
        view?.hideLoading()
        view?.showError(error: error)
    }
    
    func updateCountdownTime(with time: Int, isBlink: Bool) {
        view?.updateCountdownTime(with: time, isBlink: isBlink)
    }
}

// MARK: - Private
private extension PurchasePresenter {
    func getData() {
        view?.showLoading()
        if AppConstant.isLogin {
            interactor?.getDataLoged()
        } else {
            interactor?.getDataWithoutLogin()
        }
    }
}
