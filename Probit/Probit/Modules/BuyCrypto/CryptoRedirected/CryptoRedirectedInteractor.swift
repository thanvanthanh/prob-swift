//
//  CryptoRedirectedInteractor.swift
//  Probit
//
//  Created by Thân Văn Thanh on 26/08/2022.
//  
//

import Foundation

class CryptoRedirectedInteractor: PresenterToInteractorCryptoRedirectedProtocol {
    // MARK: Properties
    var presenter: InteractorToPresenterCryptoRedirectedProtocol?
    var entity: InteractorToEntityCryptoRedirectedProtocol?
    var checkoutResponse: PaymentCheckoutModel?
    var params: PamentChanelParameters?
    var receive: String?
    var exchange: String?
    var method: String?
    var paymentId: String?
    var getCurrencyWithPlatform: GetCurrencyWithPlatformAction
    var getFixedRate: GetFixedRateAction
    var walletCurrencies: [WalletCurrency]?

    init() {
        self.getCurrencyWithPlatform = GetCurrencyWithPlatformAction(dataSource: GatewayApiProductService())
        self.getFixedRate = GetFixedRateAction(quote: "USDT", dataSource: GatewayApiProductService())
    }
    
    func checkout(params: PaymentCheckoutParams) {
        entity?.checkout(params: params,
                         completionHandler: { result in
            switch result {
            case .success(let data):
                print("success")
                self.checkoutResponse = data
                self.paymentId = data.data.paymentId
                self.presenter?.checkoutSuccess()
                self.presenter?.navigateToPaymentWebView(url: Constant.Server.baseAPIURL + data.data.redirectPath.dropFirst())
            case .failure(let fail):
                self.presenter?.checkoutFailure(message: fail.issueCode.message)
            }
        })
    }
    
    func checkPayment() {
        entity?.checkPayment(paymentId: paymentId ?? "",
                             completionHandler: { result in
            switch result {
            case .success(let data):
                self.presenter?.checkPayment(result: data.result)
            case .failure(let fail):
                print(fail.issueCode.message)
                print("Fail")
            }
        })
    }
    
    func getCurrency() {
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
                self.loadFixeRate()
            case .failure(_):
                break
            }
        }
    }
    
    func loadFixeRate() {
        getFixedRate.apiCall { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let cryptoRate):
                guard let currencyCount = self.walletCurrencies?.count, currencyCount > 0 else { return }
                for index in 0..<currencyCount {
                    if let currencyId = self.walletCurrencies?[index].id, let rateString = cryptoRate.data?[currencyId] {
                        self.walletCurrencies?[index].fixedRate = Double(rateString)
                    }
                }
            case .failure(_):
                break
            }
        }
    }
}
