//
//  BuyCryptoInteractor.swift
//  Probit
//
//  Created by Thân Văn Thanh on 24/08/2022.
//  
//

import Foundation

class BuyCryptoInteractor: PresenterToInteractorBuyCryptoProtocol {
    // MARK: Properties
    var presenter: InteractorToPresenterBuyCryptoProtocol?
    var entity: InteractorToEntityBuyCryptoProtocol?
    var cryptoList: BuyCryptoModel? = nil
    var cryptoPriceData: BuyCryptoPriceModel? = nil
    var currencyToCrypto: String?
    var cryptoToCurency: String?
    var getPlaceholder: String?
    let getCurrencyWithPlatform = GetCurrencyWithPlatformAction(dataSource: GatewayApiProductService())
    var currencies: [WalletCurrency] = []
    
    func defaultFiat() {
        entity?.defaultFiat(completionHandler: { result in
            switch result {
            case .success:
                print("success")
            case .failure:
                print("failure")
            }
        })
    }

    func listCrypto() {
        let group = DispatchGroup()
        
        group.enter()
        entity?.listCrypto(completionHandler: { [weak self] result in
            guard let `self` = self else { return }
            switch result {
            case .success(let data):
                self.cryptoList = data
            case .failure:
                self.presenter?.loadApiError()
            }
            group.leave()
        })
        
        group.enter()
        getCurrencyWithPlatform.apiCall { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let res):
                self.currencies.removeAll()
                res.data.forEach {
                    let currency = WalletCurrency()
                    currency.mapping($0)
                    self.currencies.append(currency)
                }
            case .failure(_):
                break
            }
            group.leave()
        }
        
        group.notify(queue: DispatchQueue.global()) { [weak self] in
            guard let self = self else { return }
            if let data = self.cryptoList?.data {
                let cryptoCount = data.crypto.count
                for index in 0..<cryptoCount {
                    var crypto = data.crypto[index]
                    let walletCurrency = self.currencies.first(where: {$0.id == crypto.currencyID})
                    let displayName = walletCurrency?.displayName ?? crypto.currencyID
                    crypto.displayName = [AppConstant.locale: displayName]
                    self.cryptoList?.data?.crypto[index] = crypto
                }
            }
        }
    }
    
    func cryptoPrice(fiat: String, crypto: String) {
        entity?.cryptoPrice(fiat: fiat,
                            crypto: crypto,
                            completionHandler: { [weak self] result in
            guard let `self` = self else { return }
            switch result {
            case let .success(data):
                self.cryptoPriceData = data
                let model = ExchangeBuyCryptoModel(min: data.data.fiatMinAmount,
                                                   max: data.data.fiatMaxAmount,
                                                   amount: data.data.fiatAmount,
                                                   fiat: fiat,
                                                   crypto: crypto)
                self.exchangeConvert(model: model)
                self.presenter?.getPrice()
            case .failure:
                self.presenter?.loadApiError()
            }
        })
    }
    
    func exchangeConvert(model: ExchangeBuyCryptoModel) {
        let min = model.min.replaceCurrency()
        let max = model.max.replaceCurrency()
        let amount = model.amount.replaceCurrency()
        self.getPlaceholder = "\(min) - \(max)"
        
        let convert = model.amount.convertExchangeWidthRound()
        
        let currencyToCryptoLtr = "1 \(model.fiat) ≈ \(convert) \(model.crypto)"
        let currencyToCryptoRtl = "\(model.crypto) \(convert) ≈\(model.fiat) 1"
        self.currencyToCrypto = AppConstant.isLanguageRightToLeft ? currencyToCryptoRtl : currencyToCryptoLtr
        
        let cryptoToCurencyLtr = "1 \(model.crypto) ≈ \(amount) \(model.fiat)"
        let cryptoToCurencyRtl = "\(model.fiat) \(amount) ≈ \(model.crypto) 1"
        self.cryptoToCurency = AppConstant.isLanguageRightToLeft ? cryptoToCurencyRtl : cryptoToCurencyLtr

    }
}
