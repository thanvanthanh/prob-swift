//
//  CommonWebViewContract.swift
//  Probit
//
//  Created by Nguyen Quang on 07/09/2022.
//  
//

import Foundation

// MARK: View Output (Presenter -> View)
protocol PresenterToViewCommonWebViewProtocol {
   
}

// MARK: View Input (View -> Presenter)
protocol ViewToPresenterCommonWebViewProtocol {
    var html: String? { get set }
    var urlString: String? { get set }
    var titleBackScreen: String? { get set }
    var titleNavigation: String? { get set }
    var fileName: String? { get set }
    var type: String? { get set }

    var view: PresenterToViewCommonWebViewProtocol? { get set }
    var interactor: PresenterToInteractorCommonWebViewProtocol? { get set }
    var router: PresenterToRouterCommonWebViewProtocol? { get set }
    func gotoLogin()
    func viewDidLoad()
}

// MARK: Interactor Input (Presenter -> Interactor)
protocol PresenterToInteractorCommonWebViewProtocol {
    var presenter: InteractorToPresenterCommonWebViewProtocol? { get set }
    var walletCurrencies: [WalletCurrency] { get set }
    func loadCurrency()
}

// MARK: Interactor Output (Interactor -> Presenter)
protocol InteractorToPresenterCommonWebViewProtocol {
}

// MARK: Router Input (Presenter -> Router)
protocol PresenterToRouterCommonWebViewProtocol {
    func gotoLogin()
}
