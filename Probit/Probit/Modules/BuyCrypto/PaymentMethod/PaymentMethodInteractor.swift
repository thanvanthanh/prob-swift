//
//  PaymentMethodInteractor.swift
//  Probit
//
//  Created by Thân Văn Thanh on 24/08/2022.
//  
//

import Foundation

class PaymentMethodInteractor: PresenterToInteractorPaymentMethodProtocol {
    var paymentParams: PamentChanelParameters?
    // MARK: Properties
    var paymentMethodSection: [PaymentMethodSection] = []
    var paymentChanelList: Paymentchanel?
    var presenter: InteractorToPresenterPaymentMethodProtocol?
    var entity: InteractorToEntityListSupportedProtocol?
    var currentSelected: String?
    
    func paymentChannels(params: PamentChanelParameters) {
        entity?.paymentChanel(params: params,
                              completionHandler: { [weak self] result in
            guard let `self` = self else { return }
            switch result {
            case .success(let data):
                self.paymentChanelList = data.data
                let type = " \(params.fiat)/\(params.crypto)"
                guard let response = data.data else { return }
                
                var providers: [ServiceProvider] = []
                self.paymentMethodSection = []
                if let moonPay = response.moonpay {
                    let method = ServiceProvider(name: "common_buycrypto_moonpay".Localizable(),
                                                 price: (moonPay.fiatAmount ?? ""),
                                                 amount: (moonPay.fiatAmount ?? "") + type,
                                                 image: "",
                                                 paymentType: moonPay.method ?? [],
                                                 range: moonPay.details?.range ?? [],
                                                 isSelected: self.currentSelected.value == "common_buycrypto_moonpay".Localizable(),
                                                 available: moonPay.available ?? false,
                                                 promotion: moonPay.details?.promotion)
                    providers.append(method)
                }
                
                if let banxa = response.banxa {
                    let method = ServiceProvider(name: "common_buycrypto_banxa".Localizable(),
                                                 price: (banxa.fiatAmount ?? ""),
                                                 amount: (banxa.fiatAmount ?? "") + type,
                                                 image: "",
                                                 paymentType: banxa.method ?? [],
                                                 range: banxa.details?.range ?? [],
                                                 isSelected: self.currentSelected.value == "common_buycrypto_banxa".Localizable(),
                                                 available: banxa.available ?? false,
                                                 promotion: banxa.details?.promotion)
                    providers.append(method)
                }
                
                if let xanpool = response.xanpool {
                   let method = ServiceProvider(name: "common_buycrypto_xanpool".Localizable(),
                                                price: (xanpool.fiatAmount ?? ""),
                                                amount: (xanpool.fiatAmount ?? "") + type,
                                                image: "",
                                                paymentType: xanpool.method ?? [],
                                                range: xanpool.details?.range ?? [],
                                                isSelected: self.currentSelected.value == "common_buycrypto_xanpool".Localizable(),
                                                available: xanpool.available ?? false,
                                                promotion: xanpool.details?.promotion)
                    providers.append(method)
                }
                
                if let simplex = response.simplex {
                    let method = ServiceProvider(name: "common_buycrypto_simplex".Localizable(),
                                                 price: (simplex.fiatAmount ?? ""),
                                                 amount: (simplex.fiatAmount ?? "") + type,
                                                 image: "",
                                                 paymentType: simplex.method ?? [],
                                                 range: simplex.details?.range ?? [],
                                                 isSelected: self.currentSelected.value == "common_buycrypto_simplex".Localizable(),
                                                 available: simplex.available ?? false,
                                                 promotion: simplex.details?.promotion)
                    
                    providers.append(method)
                    
                }
                
                if let coinify = response.coinify {
                    let method = ServiceProvider(name: "common_buycrypto_coinify".Localizable(),
                                                 price: (coinify.fiatAmount ?? ""),
                                                 amount: (coinify.fiatAmount ?? "") + type,
                                                 image: "",
                                                 paymentType: coinify.method ?? [],
                                                 range: coinify.details?.range ?? [],
                                                 isSelected: self.currentSelected.value == "common_buycrypto_coinify".Localizable(),
                                                 available: coinify.available ?? false,
                                                 promotion: coinify.details?.promotion)
                    
                    providers.append(method)
                    
                }
                
                
                var paymentMethodSection: [PaymentMethodSection] = [
                    .init(type: .header, headerSection: HeaderPaymentMethod(), listData: [])
                ]
                let listPromotion = providers.filter { $0.promotion != nil }
                let listNormal = providers.filter { $0.promotion == nil }.sorted { lhs, rhs in
                    return lhs.available && !(rhs.available)
                }
                if listPromotion.count > 0 {
                    paymentMethodSection.append(.init(type: .promotion,
                                                      headerSection: PromotionHeader(type: .promotion),
                                                      listData: listPromotion))
                    if self.currentSelected == nil {
                        listPromotion[0].isSelected = true
                        self.currentSelected = listPromotion[0].name
                    }
                }
                if self.currentSelected == nil, listNormal.count > 0 {
                    listNormal[0].isSelected = true
                    self.currentSelected = listNormal[0].name
                }
                paymentMethodSection.append(.init(type: .service,
                                                  headerSection: PromotionHeader(type: .service),
                                                  listData: listNormal))
                self.paymentMethodSection = paymentMethodSection
                self.presenter?.paymentMethodComplete()
            case .failure:
                self.presenter?.handleApiError()
            }
        })
    }
    
    func getData() {
        guard let params = paymentParams else { return }
        paymentChannels(params: params)
    }
    
    func selectedItem(item: IndexPath) {
        paymentMethodSection.enumerated().forEach { index, value in
            value.listData.enumerated().forEach { index1, _ in
                paymentMethodSection[index].listData[index1].isSelected = false
            }
        }
        paymentMethodSection[item.section].listData[item.row].isSelected = !paymentMethodSection[item.section].listData[item.row].isSelected
        currentSelected = paymentMethodSection[item.section].listData[item.row].name
        presenter?.paymentMethodComplete()
    }
}
