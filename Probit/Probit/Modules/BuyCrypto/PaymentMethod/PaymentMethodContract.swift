//
//  PaymentMethodContract.swift
//  Probit
//
//  Created by Thân Văn Thanh on 24/08/2022.
//  
//

import Foundation


// MARK: View Output (Presenter -> View)
protocol PresenterToViewPaymentMethodProtocol: BaseViewProtocol {
    func reloadData()
    func handleApiError()
}

// MARK: View Input (View -> Presenter)
protocol ViewToPresenterPaymentMethodProtocol {
    
    var view: PresenterToViewPaymentMethodProtocol? { get set }
    var interactor: PresenterToInteractorPaymentMethodProtocol? { get set }
    var router: PresenterToRouterPaymentMethodProtocol? { get set }
    var paymentChanelList: Paymentchanel? { get }
    func getListPaymentMethod()
    func navigateToConfirmPayment()
    func paymentMethodSelected(item: IndexPath)
    var paymentParams: PamentChanelParameters? { get }
    var receive: String? { get set }
    var amount: String? { get set }
    var method: String? { get set }
    
    var paymentMethodSection: [PaymentMethodSection] { get }
}

// MARK: Interactor Input (Presenter -> Interactor)
protocol PresenterToInteractorPaymentMethodProtocol {
    var presenter: InteractorToPresenterPaymentMethodProtocol? { get set }
    var entity: InteractorToEntityListSupportedProtocol? { get set }
    var paymentChanelList: Paymentchanel? { get set }
    var paymentParams: PamentChanelParameters? { get set }
    func getData()
    func selectedItem(item: IndexPath)
    func paymentChannels(params: PamentChanelParameters)
    var paymentMethodSection: [PaymentMethodSection] { get set }
}

// MARK: Interactor Output (Interactor -> Presenter)
protocol InteractorToPresenterPaymentMethodProtocol {
    func paymentMethodComplete()
    func handleApiError()
}

// MARK: Router Input (Presenter -> Router)
protocol PresenterToRouterPaymentMethodProtocol {
    func navigateToConfirmPayment(params: PamentChanelParameters,
                                  receive: String,
                                  exchange: String,
                                  method: String)
}

protocol InteractorToEntityListSupportedProtocol {
    func paymentChanel(params: PamentChanelParameters,
                       completionHandler: @escaping (Result<PaymentChannelsModel, ServiceError>) -> Void)
}
