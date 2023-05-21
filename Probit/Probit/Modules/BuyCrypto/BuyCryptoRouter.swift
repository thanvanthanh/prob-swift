//
//  BuyCryptoRouter.swift
//  Probit
//
//  Created by Thân Văn Thanh on 24/08/2022.
//  
//

import UIKit

enum BuyCryptoScreenType {
    case toHome
    case toMore
    case toWalet
    case toStake
}

class BuyCryptoRouter: PresenterToRouterBuyCryptoProtocol {
    
    let presenter: ViewToPresenterBuyCryptoProtocol & InteractorToPresenterBuyCryptoProtocol = BuyCryptoPresenter()
    var viewController: BuyCryptoViewController?
    
    func showScreen(type: BuyCryptoScreenType, defaultCrypto: String = "BTC") {
        self.viewController = self.createModule(type: type, defaultCrypto: defaultCrypto) as? BuyCryptoViewController
        guard let desVC = self.viewController else { return }
        desVC.getRootTabbarViewController().push(viewController: desVC)
    }
    
    func setupRootView(type: BuyCryptoScreenType) {
        guard let appdelegate = UIApplication.shared.delegate as? AppDelegate,
              let window = appdelegate.window else { return }
        self.viewController = self.createModule(type: type) as? BuyCryptoViewController

        guard let destinationVC = self.viewController else { return }
        window.rootViewController = UINavigationController.init(rootViewController: destinationVC)
        window.makeKeyAndVisible()
    }
    
    // MARK: Static methods
    func createModule(type: BuyCryptoScreenType, defaultCrypto: String = "BTC") -> UIViewController {
        let storyboard = UIStoryboard(name: "BuyCrypto", bundle: nil)
        let viewController = storyboard.instantiateViewController(viewControllerType:BuyCryptoViewController.self)
        let entity: InteractorToEntityBuyCryptoProtocol = BuyCryptoEntity()
        viewController.hidesBottomBarWhenPushed = true
        viewController.presenter = presenter
        viewController.presenter?.router = BuyCryptoRouter()
        viewController.presenter?.view = viewController
        viewController.presenter?.interactor = BuyCryptoInteractor()
        viewController.presenter?.interactor?.entity = entity
        viewController.presenter?.interactor?.presenter = presenter
        viewController.presenter?.screenType = type
        viewController.presenter?.defaultCrypto = defaultCrypto
        return viewController
    }
    
    func navigateToListSupported(delegate: BuyCryptoDelegate,
                                 listData: BuyCryptoModel?,
                                 type: CryptoType,
                                 isSelectType: String) {
        ListSupportedRouter().showScreen(delegate: delegate,
                                         listData: listData,
                                         type: type,
                                         isSelectType: isSelectType)
    }
    
    func navigateToPaymentMethod(params: PamentChanelParameters,
                                 receive: String,
                                 exchange: String?) {
        PaymentMethodRouter().showScreen(params: params)
    }
    
    func navigateToLogin() {
        LoginRouter().showScreen()
    }
}
