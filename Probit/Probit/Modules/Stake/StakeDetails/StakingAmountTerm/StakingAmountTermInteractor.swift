//
//  StakingAmountTerm.swift
//  Probit
//
//  Created by Đào Mỹ Đông on 03/10/2565 BE.
//

import Foundation
class StakingAmountTermInteractor: PresenterToInteractorStakingAmountTermProtocol {
    // MARK: Properties
    var presenter: InteractorToPresenterStakingAmountTermProtocol?
    var currencyId: String
    var period: Int
    var amount: String
    init(currencyId: String, period: Int, amount: String) {
        self.currencyId = currencyId
        self.period = period
        self.amount = amount
    }
    
    func doStake() {
        StakeAPI.shared.postStake(currencyId,
                                  period,
                                  amount) { [weak self] res in
            guard let self = self else {return}
            switch res {
            case .success( _):
                self.presenter?.handleSuccess()
            case .failure(let error):
                self.presenter?.handleError(error)
            }
        }
    }
    
    func doUnStake() {
        StakeAPI.shared.postUnStake(currencyId,
                                  amount) { [weak self] res in
            guard let self = self else {return}
            switch res {
            case .success( _):
                self.presenter?.handleSuccess()
            case .failure(let error):
                self.presenter?.handleError(error)
            }
        }
    }
}

struct CautionModel {
    var content: String
    var isAttributedString: Bool
}
