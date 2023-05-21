//
//  AppSettingRouter.swift
//  Probit
//
//  Created by Thân Văn Thanh on 30/08/2022.
//  
//

import Foundation
import UIKit

class AppSettingRouter: PresenterToRouterAppSettingProtocol {
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
        let storyboard = UIStoryboard(name: "AppSetting", bundle: nil)
        let viewController = storyboard.instantiateViewController(viewControllerType:AppSettingViewController.self)
        
        let presenter: ViewToPresenterAppSettingProtocol & InteractorToPresenterAppSettingProtocol = AppSettingPresenter()
        
        viewController.hidesBottomBarWhenPushed = true
        viewController.presenter = presenter
        viewController.presenter?.router = AppSettingRouter()
        viewController.presenter?.view = viewController
        viewController.presenter?.interactor = AppSettingInteractor()
        viewController.presenter?.interactor?.presenter = presenter
        
        return viewController
    }
    
    func navigateToAppSettingLanguage() {
        AppSettingLanguageRouter().showScreen()
    }
    
    func navigateToTickerColor(delegate: TickerColorDelegate,
                               currentData: TickerColor) {
        TickerColorRouter().showScreen(delegate: delegate, tickerColor: currentData)
    }
    
    func navigateToAppInfo() {
        AppInfoRouter().showScreen()
    }
    
    func navigateToTermsAndPolicies() {
        AppSettingTermsAndPoliciesRouter().showScreen()
    }
    
    func navigateToNotifications() {
        NotificationsRouter().showScreen()
    }
    
    func navigateToAppLock() {
        AppLockRouter().showScreen()
    }
    
    func navigateToProBitWebsite(viewController: BaseViewController) {
        PopupHelper.shared.show(viewController: viewController,
                                title: "appsetting_delete_account_notice_title".Localizable(),
                                message: "dialog_before_logout_tips".Localizable(),
                                activeTitle: "common_delete".Localizable(),
                                activeAction: {
            guard let url = URL(string: AppConstant.Link.contactUs) else { return }
            UIApplication.shared.open(url)
        }, cancelTitle: "dialog_cancel".Localizable(), cancelAction: nil)
    }
    
}
