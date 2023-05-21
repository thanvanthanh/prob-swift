//
//  ConfirmPaymentPresenter.swift
//  Probit
//
//  Created by Thân Văn Thanh on 26/08/2022.
//  
//

import Foundation

class ConfirmPaymentPresenter: ViewToPresenterConfirmPaymentProtocol {

    // MARK: Properties
    var view: PresenterToViewConfirmPaymentProtocol?
    var interactor: PresenterToInteractorConfirmPaymentProtocol?
    var router: PresenterToRouterConfirmPaymentProtocol?
    var paymentInfo: [PaymentInfo] { interactor?.paymentInfo ?? [] }
    var paymentParams: PamentChanelParameters? { interactor?.paymentParams }
    var receive: String?
    var exchange: String? { interactor?.exchange }
    var method: String? { interactor?.method }

    func viewDidLoad() {
        interactor?.getData()
    }
}

extension ConfirmPaymentPresenter: InteractorToPresenterConfirmPaymentProtocol {
    func dataListDidFetch() {
        view?.reloadData()
    }
    
    func navigateToCryptoRedirected() {
        guard let paymentParams = paymentParams else { return }
        router?.navigateToCryptoRedirected(params: paymentParams,
                                           receive: receive ?? "",
                                           method: method ?? "")
    }
    
}
