//
//  PaymentMethodRouter.swift
//  Probit
//
//  Created by Thân Văn Thanh on 24/08/2022.
//  
//

import Foundation
import UIKit

class PaymentMethodRouter: PresenterToRouterPaymentMethodProtocol {

    func showScreen(params: PamentChanelParameters) {
        let destinationVC = self.createModule(params: params)
        print(params)
        destinationVC.getRootTabbarViewController().pushViewController(destinationVC, animated: true)
    }
    
    func setupRootView(params: PamentChanelParameters) {
        guard let appdelegate = UIApplication.shared.delegate as? AppDelegate,
              let window = appdelegate.window else { return }
        
        let destinationVC = self.createModule(params: params)
        window.rootViewController = UINavigationController.init(rootViewController: destinationVC)
        window.makeKeyAndVisible()
    }
    
    // MARK: Static methods
    func createModule(params: PamentChanelParameters) -> UIViewController {
        let storyboard = UIStoryboard(name: "PaymentMethod", bundle: nil)
        let viewController = storyboard.instantiateViewController(viewControllerType:PaymentMethodViewController.self)
        
        let presenter: ViewToPresenterPaymentMethodProtocol & InteractorToPresenterPaymentMethodProtocol = PaymentMethodPresenter()
        let entity: InteractorToEntityListSupportedProtocol = PaymentMethodEntity()
        
        viewController.presenter = presenter
        viewController.presenter?.router = PaymentMethodRouter()
        viewController.presenter?.view = viewController
        viewController.presenter?.interactor = PaymentMethodInteractor()
        viewController.presenter?.interactor?.entity = entity
        viewController.presenter?.interactor?.presenter = presenter
        viewController.presenter?.interactor?.paymentParams = params
        
        return viewController
    }
    
    func navigateToConfirmPayment(params: PamentChanelParameters,
                                  receive: String,
                                  exchange: String,
                                  method: String) {
        ConfirmPaymentRouter().showScreen(params: params,
                                          receive: receive,
                                          exchange: exchange,
                                          method: method)
    }
    
}
