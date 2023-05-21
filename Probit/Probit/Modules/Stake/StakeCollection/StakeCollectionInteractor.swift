//
//  StakeCollectionInteractor.swift
//  Probit
//
//  Created by Đào Mỹ Đông on 22/09/2565 BE.
//  
//

import Foundation

class StakeCollectionInteractor: PresenterToInteractorStakeCollectionProtocol {
    // MARK: Properties
    var presenter: InteractorToPresenterStakeCollectionProtocol?
    var type: StakeCollectionType
    var stakeList: [StakeEventModel] = []
    var stakeFilted: [StakeEventModel] = []
    var stakeCurrencies: [StakeCurrency] = []
    var walletCurrencies: [WalletCurrency] = []
    init(type: StakeCollectionType) {
        self.type =  type
    }
}
