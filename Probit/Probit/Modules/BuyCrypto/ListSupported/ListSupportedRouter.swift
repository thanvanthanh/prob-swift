//
//  ListSupportedRouter.swift
//  Probit
//
//  Created by Thân Văn Thanh on 24/08/2022.
//  
//

import Foundation
import UIKit

class ListSupportedRouter: PresenterToRouterListSupportedProtocol {
    func showScreen(delegate: BuyCryptoDelegate? = nil,
                    listData: BuyCryptoModel? = nil,
                    type: CryptoType,
                    isSelectType: String) {
        let destinationVC = self.createModule(delegate: delegate,
                                              listData: listData,
                                              type: type ,
                                              isSelectType: isSelectType)
        destinationVC.getRootTabbarViewController().pushViewController(destinationVC, animated: true)
    }
    
    func setupRootView() {
        guard let appdelegate = UIApplication.shared.delegate as? AppDelegate,
              let window = appdelegate.window else { return }
        
        let destinationVC = self.createModule()
        window.rootViewController = UINavigationController.init(rootViewController: destinationVC)
        window.makeKeyAndVisible()
    }
    
    // MARK: Static methods
    func createModule(delegate: BuyCryptoDelegate? = nil,
                      listData: BuyCryptoModel? = nil,
                      type: CryptoType? = .crypto,
                      isSelectType: String? = nil) -> UIViewController {
        let storyboard = UIStoryboard(name: "ListSupported", bundle: nil)
        let viewController = storyboard.instantiateViewController(viewControllerType:ListSupportedViewController.self)
        
        let presenter: ViewToPresenterListSupportedProtocol & InteractorToPresenterListSupportedProtocol = ListSupportedPresenter(delegate: delegate)
        
        viewController.presenter = presenter
        viewController.presenter?.router = ListSupportedRouter()
        viewController.presenter?.view = viewController
        viewController.presenter?.isSelectType = isSelectType ?? ""
        viewController.presenter?.interactor = ListSupportedInteractor()
        viewController.presenter?.interactor?.listData = listData ?? nil
        viewController.presenter?.interactor?.cryptoType = type
        viewController.presenter?.interactor?.presenter = presenter
        
        return viewController
    }
    
}
