//
//  BuyCryptoContract.swift
//  Probit
//
//  Created by Thân Văn Thanh on 24/08/2022.
//  
//

import Foundation

// MARK: View Output (Presenter -> View)
protocol PresenterToViewBuyCryptoProtocol: BaseViewProtocol {
    func reloadCurrencyData(data: ListSupported, type: CryptoType)
    func completeListPrice()
    func loadApiError()
    func handleShowLoading()
}

// MARK: View Input (View -> Presenter)
protocol ViewToPresenterBuyCryptoProtocol {
    
    var view: PresenterToViewBuyCryptoProtocol? { get set }
    var interactor: PresenterToInteractorBuyCryptoProtocol? { get set }
    var router: PresenterToRouterBuyCryptoProtocol? { get set }
    var currentData: ListSupported? { get set }
    var paymentParams: PamentChanelParameters? { get set }
    var receive: String? { get set }
    var currencyToCrypto: String? { get }
    var screenType: BuyCryptoScreenType? { get set }
    var cryptoToCurency: String? { get }
    var getPlaceholder: String? { get }
    var defaultCrypto: String? { get set }
    var listData: BuyCryptoModel? { get }
    var cryptoPriceData: BuyCryptoPriceModel? { get }
    
    func navigateToListSupported(delegate: BuyCryptoDelegate,
                                 type: CryptoType,
                                 isSelectType: String)
    func navigateToPaymentMethod()
    func navigateToLogin()
    func updateData(data: ListSupported, type: CryptoType)
    func listCrypto()
    func defaultFiat()
    func cryptoPrice(fiat: String, crypto: String)
    func changeConvertAction()
}


// MARK: Interactor Input (Presenter -> Interactor)
protocol PresenterToInteractorBuyCryptoProtocol {
    var cryptoList: BuyCryptoModel? { get set }
    var cryptoPriceData: BuyCryptoPriceModel? { get set }
    var presenter: InteractorToPresenterBuyCryptoProtocol? { get set }
    var entity: InteractorToEntityBuyCryptoProtocol? { get set }
    var currencyToCrypto: String? { get set }
    var cryptoToCurency: String? { get set }
    var getPlaceholder: String? { get set }
    func defaultFiat()
    func listCrypto()
    func cryptoPrice(fiat: String, crypto: String)
    func exchangeConvert(model: ExchangeBuyCryptoModel)
}

// MARK: Interactor Output (Interactor -> Presenter)
protocol InteractorToPresenterBuyCryptoProtocol {
    func getPrice()
    func loadApiError()
}


// MARK: Router Input (Presenter -> Router)
protocol PresenterToRouterBuyCryptoProtocol {
    func navigateToListSupported(delegate: BuyCryptoDelegate,
                                 listData: BuyCryptoModel?,
                                 type: CryptoType,
                                 isSelectType: String)
    
    func navigateToPaymentMethod(params: PamentChanelParameters,
                                 receive: String,
                                 exchange: String?)
    func navigateToLogin()
}

protocol InteractorToEntityBuyCryptoProtocol {
    func defaultFiat(completionHandler: @escaping (Result<DefaultFiatModel, ServiceError>) -> Void)
    
    func listCrypto(completionHandler: @escaping (Result<BuyCryptoModel, ServiceError>) -> Void)
    
    func cryptoPrice(fiat: String,
                     crypto: String,
                     completionHandler: @escaping (Result<BuyCryptoPriceModel, ServiceError>) -> Void)
}
