//
//  ConfirmPaymentContract.swift
//  Probit
//
//  Created by Thân Văn Thanh on 26/08/2022.
//  
//

import Foundation


// MARK: View Output (Presenter -> View)
protocol PresenterToViewConfirmPaymentProtocol {
    func reloadData()
}


// MARK: View Input (View -> Presenter)
protocol ViewToPresenterConfirmPaymentProtocol {
    
    var view: PresenterToViewConfirmPaymentProtocol? { get set }
    var interactor: PresenterToInteractorConfirmPaymentProtocol? { get set }
    var router: PresenterToRouterConfirmPaymentProtocol? { get set }
    var paymentInfo: [PaymentInfo] { get }
    var paymentParams: PamentChanelParameters? { get }
    func viewDidLoad()
    func navigateToCryptoRedirected()
    var receive: String? { get set }
    var exchange: String? { get }
    var method: String? { get }
}


// MARK: Interactor Input (Presenter -> Interactor)
protocol PresenterToInteractorConfirmPaymentProtocol {
    
    var presenter: InteractorToPresenterConfirmPaymentProtocol? { get set }
    var paymentInfo: [PaymentInfo] { get set }
    var paymentParams: PamentChanelParameters? { get set }
    var exchange: String? { get set }
    var method: String? { get set }
    func getData()

}


// MARK: Interactor Output (Interactor -> Presenter)
protocol InteractorToPresenterConfirmPaymentProtocol {
    func dataListDidFetch()
}


// MARK: Router Input (Presenter -> Router)
protocol PresenterToRouterConfirmPaymentProtocol {
    func navigateToCryptoRedirected(params: PamentChanelParameters,
                                    receive: String,
                                    method: String)
}
