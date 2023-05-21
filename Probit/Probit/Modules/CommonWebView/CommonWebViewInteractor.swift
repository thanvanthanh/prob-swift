//
//  CommonWebViewInteractor.swift
//  Probit
//
//  Created by Nguyen Quang on 07/09/2022.
//  
//

import Foundation

class CommonWebViewInteractor: PresenterToInteractorCommonWebViewProtocol {
    // MARK: Properties
    var presenter: InteractorToPresenterCommonWebViewProtocol?
    var getCurrencyWithPlatform: GetCurrencyWithPlatformAction
    var walletCurrencies: [WalletCurrency] = []
    
    public init() {
        self.getCurrencyWithPlatform = GetCurrencyWithPlatformAction(dataSource: GatewayApiProductService() )
    }
    
    func loadCurrency() {
        getCurrencyWithPlatform.apiCall { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let res):
                var currencies: [WalletCurrency] = []
                res.data.forEach {
                    let currency = WalletCurrency()
                    currency.mapping($0)
                    currencies.append(currency)
                }
                self.walletCurrencies = currencies
            case .failure(_):
                break
            }
        }
    }
}
