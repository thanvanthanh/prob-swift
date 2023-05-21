//
//  MoreRouter.swift
//  Probit
//
//  Created by Nguyen Quang on 21/09/2022.
//  
//

import Foundation
import UIKit

class MoreRouter: PresenterToRouterMoreProtocol {
    func showScreen() {
        let destinationVC = self.createModule()
        destinationVC.getRootTabbarViewController().push(viewController: destinationVC)
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
        let storyboard = UIStoryboard(name: "More", bundle: nil)
        let viewController = storyboard.instantiateViewController(viewControllerType:MoreViewController.self)
        
        let presenter: ViewToPresenterMoreProtocol & InteractorToPresenterMoreProtocol = MorePresenter()
        
        viewController.presenter = presenter
        viewController.presenter?.router = MoreRouter()
        viewController.presenter?.view = viewController
        viewController.presenter?.interactor = MoreInteractor()
        viewController.presenter?.interactor?.presenter = presenter
        
        return viewController
    }
    
    func navigateNextScreen(type: MoreItem, viewController: BaseViewController) {
        switch type {
        case .exclusive, .ieo, .autoHold:
            navigateToWebView(type: type)
        case .announcements, .FAQ, .contactUs:
            navigateToProBitWebsite(type: type, viewController: viewController)
        case .buyCrypto:
            navigateToBuyCrypto()
        case .referralProgram:
            navigateToReferralProgram()
        case .purchasePROB:
            navigateToPurchase(viewController: viewController)
        case .tradingCompetition:
            navigateToTradingCompetition()
        case .stake:
            navigateToStake()
        case .airdrops:
            AirdropsRouter().showScreen()
        }
    }
    
    func navigateToStake() {
        StakeRouter().showScreen()
    }
    
    func navigateToBuyCrypto() {
        BuyCryptoRouter().showScreen(type: .toMore)
    }
    
    func navigateToReferralProgram() {
        if AppConstant.isLogin {
            ReferralRouter().showScreen()
        } else {
            guard let lastViewController = UIViewController().getRootTabbarViewController().viewControllers.last else { return }
            PopupHelper.shared.show(viewController: lastViewController,
                                    title: "dialog_login_needed_title".Localizable(),
                                    message: "dialog_login_needed_content".Localizable(),
                                    activeTitle: "login_btn_login".Localizable(),
                                    activeAction: {
                LoginRouter(delegate: lastViewController as? LoginViewControllerDelegate).showScreen(requestType: .referralProgram)
            },
                                    cancelTitle: "dialog_cancel".Localizable(), cancelAction: nil)
        }
    }
    
    func navigateToPurchase(viewController: BaseViewController) {
        PurchaseRouter().showScreen()
    }
    
    func navigateToTradingCompetition() {
        TradingCompetitionRouter().showScreen()
    }
    
    func navigateToWebView(type: MoreItem) {
        CommonWebViewRouter().showScreen(titleBackScreen: "v2icon_home_more".Localizable(),
                                         urlString: type.urlString,
                                         titleNavigation: "\(type.title) - ProBit Global")
    }
    
    func navigateToProBitWebsite(type: MoreItem,
                                 viewController: BaseViewController) {
        PopupHelper.shared.show(viewController: viewController,
                                title: "kyc_fail_to_read_notice_title".Localizable(),
                                message: "dialog_navigateaway_content".Localizable(),
                                activeTitle: "dialog_go".Localizable(),
                                activeAction: {
            guard let url = URL(string: type.urlString) else { return }
            UIApplication.shared.open(url)
        }, cancelTitle: "dialog_cancel".Localizable(), cancelAction: nil)
    }
}
