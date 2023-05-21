//
//  AppInfoRouter.swift
//  Probit
//
//  Created by Thân Văn Thanh on 31/08/2022.
//  
//

import Foundation
import UIKit

class AppInfoRouter: PresenterToRouterAppInfoProtocol {
    func showScreen() {
        let destinationVC = self.createModule()
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
    func createModule() -> UIViewController {
        let storyboard = UIStoryboard(name: "AppInfo", bundle: nil)
        let viewController = storyboard.instantiateViewController(viewControllerType:AppInfoViewController.self)
        
        let presenter: ViewToPresenterAppInfoProtocol & InteractorToPresenterAppInfoProtocol = AppInfoPresenter()
        
        viewController.presenter = presenter
        viewController.presenter?.router = AppInfoRouter()
        viewController.presenter?.view = viewController
        viewController.presenter?.interactor = AppInfoInteractor()
        viewController.presenter?.interactor?.presenter = presenter
        
        return viewController
    }
    
    func navigateToHomePage(viewController: BaseViewController) {
        PopupHelper.shared.show(viewController: viewController,
                                title: "kyc_fail_to_read_notice_title".Localizable(),
                                message: "dialog_navigateaway_content".Localizable(),
                                activeTitle: "dialog_go".Localizable(),
                                activeAction: {
            guard let url = URL(string: AppConstant.Link.homePage) else { return }
            UIApplication.shared.open(url)
        }, cancelTitle: "dialog_cancel".Localizable(), cancelAction: nil)
    }
}
