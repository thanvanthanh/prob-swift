//
//  BuyCryptoPresenter.swift
//  Probit
//
//  Created by Thân Văn Thanh on 24/08/2022.
//  
//

import Foundation

class BuyCryptoPresenter: ViewToPresenterBuyCryptoProtocol {
    
    // MARK: Properties
    var view: PresenterToViewBuyCryptoProtocol?
    var interactor: PresenterToInteractorBuyCryptoProtocol?
    var router: PresenterToRouterBuyCryptoProtocol?
    var currentData: ListSupported? = nil
    var receive: String?
    var currencyToCrypto: String? { interactor?.currencyToCrypto }
    var cryptoToCurency: String? { interactor?.cryptoToCurency }
    var getPlaceholder: String? { interactor?.getPlaceholder }
    var cryptoPriceData: BuyCryptoPriceModel? { interactor?.cryptoPriceData }
    var listData: BuyCryptoModel? { interactor?.cryptoList }
    var paymentParams: PamentChanelParameters? = nil
    var screenType: BuyCryptoScreenType?
    var defaultCrypto: String?
    
    func navigateToPaymentMethod() {
        guard let paymentParams = paymentParams else { return }
        router?.navigateToPaymentMethod(params: paymentParams,
                                        receive: receive ?? "",
                                        exchange: cryptoToCurency ?? "")
    }

    func updateData(data: ListSupported, type: CryptoType) {
        view?.handleShowLoading()
        currentData = data
        view?.reloadCurrencyData(data: data, type: type)
    }
    
    func defaultFiat() {
        interactor?.defaultFiat()
    }
    
    func listCrypto() {
        view?.handleShowLoading()
        interactor?.listCrypto()
    }
    
    func cryptoPrice(fiat: String, crypto: String) {
        interactor?.cryptoPrice(fiat: fiat, crypto: crypto)
    }
    
    func navigateToListSupported(delegate: BuyCryptoDelegate,
                                 type: CryptoType,
                                 isSelectType: String) {
        let data = listData
        
        router?.navigateToListSupported(delegate: delegate,
                                        listData: data,
                                        type: type,
                                        isSelectType: isSelectType)
    }
    
    func navigateToLogin() {
        router?.navigateToLogin()
    }
    
    func changeConvertAction() {
        view?.completeListPrice()
    }
    
}

extension BuyCryptoPresenter: InteractorToPresenterBuyCryptoProtocol {
    
    func getPrice() {
        view?.completeListPrice()
    }
    
    func loadApiError() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.view?.loadApiError()
        }
    }
}
