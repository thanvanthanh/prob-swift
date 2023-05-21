//
//  PaymentMethodPresenter.swift
//  Probit
//
//  Created by Thân Văn Thanh on 24/08/2022.
//  
//

import Foundation

class PaymentMethodPresenter: ViewToPresenterPaymentMethodProtocol {
    
    // MARK: Properties
    var view: PresenterToViewPaymentMethodProtocol?
    var interactor: PresenterToInteractorPaymentMethodProtocol?
    var router: PresenterToRouterPaymentMethodProtocol?
    var paymentChanelList: Paymentchanel? { interactor?.paymentChanelList }
    var paymentParams: PamentChanelParameters? { interactor?.paymentParams }
    var paymentMethodSection: [PaymentMethodSection] { interactor?.paymentMethodSection ?? [] }
    var receive: String?
    var amount: String?
    var method: String?
    
    func getListPaymentMethod() {
        view?.showLoading()
        interactor?.getData()
    }
    
    func paymentMethodSelected(item: IndexPath) {
        interactor?.selectedItem(item: item)
    }
    
    func navigateToConfirmPayment() {
        guard let paymentParams = paymentParams else { return }
        router?.navigateToConfirmPayment(params: paymentParams,
                                         receive: receive ?? "",
                                         exchange: amount ?? "",
                                         method: method ?? "")
    }
}

extension PaymentMethodPresenter: InteractorToPresenterPaymentMethodProtocol {
    
    func paymentMethodComplete() {
        view?.hideLoading()
        view?.reloadData()
    }
    
    func handleApiError() {
        view?.hideLoading()
        view?.handleApiError()
    }
}
