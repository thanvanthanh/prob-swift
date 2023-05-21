//
//  CryptoRedirectedContract.swift
//  Probit
//
//  Created by Thân Văn Thanh on 26/08/2022.
//  
//

import Foundation


// MARK: View Output (Presenter -> View)
protocol PresenterToViewCryptoRedirectedProtocol {
    func reloadCheckout()
    func checkoutFailure(message: String)
    func checkPayment(result: String)
}


// MARK: View Input (View -> Presenter)
protocol ViewToPresenterCryptoRedirectedProtocol {
    
    var view: PresenterToViewCryptoRedirectedProtocol? { get set }
    var interactor: PresenterToInteractorCryptoRedirectedProtocol? { get set }
    var router: PresenterToRouterCryptoRedirectedProtocol? { get set }
    var params: PamentChanelParameters? { get }
    var receive: String? { get }
    var method: String? {get }
    func cryptoCheckout()
    func checkPayment()
    func navigateToWallet()
    func getCurrency()
}


// MARK: Interactor Input (Presenter -> Interactor)
protocol PresenterToInteractorCryptoRedirectedProtocol {
    
    var presenter: InteractorToPresenterCryptoRedirectedProtocol? { get set }
    var entity: InteractorToEntityCryptoRedirectedProtocol? { get set }
    var params: PamentChanelParameters? { get set }
    var receive: String? { get set }
    var method: String? {get set }
    var paymentId: String? { get set }
    var checkoutResponse: PaymentCheckoutModel? { get set }
    var walletCurrencies: [WalletCurrency]? { get set }

    func checkout(params: PaymentCheckoutParams)
    func checkPayment()
    func getCurrency()
}


// MARK: Interactor Output (Interactor -> Presenter)
protocol InteractorToPresenterCryptoRedirectedProtocol {
    func checkoutSuccess()
    func checkoutFailure(message: String)
    func navigateToPaymentWebView(url: String)
    func checkPayment(result: String)
}


// MARK: Router Input (Presenter -> Router)
protocol PresenterToRouterCryptoRedirectedProtocol {
    func navigateToPaymentWebView(url: String)
    func navigateToWallet(currency: WalletCurrency)
}

protocol InteractorToEntityCryptoRedirectedProtocol {
    
    func checkout(params: PaymentCheckoutParams,
                       completionHandler: @escaping (Result<PaymentCheckoutModel, ServiceError>) -> Void)
    
    func checkPayment(paymentId: String,
                       completionHandler: @escaping (Result<CheckPaymentModel, ServiceError>) -> Void)
}
