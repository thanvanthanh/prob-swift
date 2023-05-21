//
//  CryptoRedirectedPresenter.swift
//  Probit
//
//  Created by Thân Văn Thanh on 26/08/2022.
//  
//

import Foundation

class CryptoRedirectedPresenter: ViewToPresenterCryptoRedirectedProtocol {

    // MARK: Properties
    var view: PresenterToViewCryptoRedirectedProtocol?
    var interactor: PresenterToInteractorCryptoRedirectedProtocol?
    var router: PresenterToRouterCryptoRedirectedProtocol?
    var params: PamentChanelParameters? { interactor?.params }
    var receive: String? { interactor?.receive }
    var method: String? { interactor?.method }
    
    func cryptoCheckout() {
        let params = PaymentCheckoutParams(provider: (method ?? "").lowercased(),
                                           fiatAmount: params?.fiatAmount ?? "",
                                           fiat: params?.fiat ?? "",
                                           crypto: params?.crypto ?? "")
        interactor?.checkout(params: params)
    }
    
    func checkPayment() {
        interactor?.checkPayment()
    }
    
    func navigateToWallet() {
        guard let currency = interactor?.walletCurrencies?.first(where: {$0.id == params?.crypto}) else { return }
        router?.navigateToWallet(currency: currency)
    }
    
    func getCurrency() {
        interactor?.getCurrency()
    }
}

extension CryptoRedirectedPresenter: InteractorToPresenterCryptoRedirectedProtocol {
    
    func navigateToPaymentWebView(url: String) {
        router?.navigateToPaymentWebView(url: url)
    }
    
    func checkPayment(result: String) {
        view?.checkPayment(result: result)
    }
    
    func checkoutSuccess() {
        view?.reloadCheckout()
    }
    
    func checkoutFailure(message: String) {
        view?.checkoutFailure(message: message)
    }
}
