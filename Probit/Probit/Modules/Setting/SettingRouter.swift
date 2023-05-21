//
//  SettingRouter.swift
//  Probit
//
//  Created by Thân Văn Thanh on 29/08/2022.
//  
//

import Foundation
import UIKit

class SettingRouter: PresenterToRouterSettingProtocol {
    func showScreen() {
        let destinationVC = self.createModule()
        destinationVC.getRootViewController().navigationController?.pushViewController(destinationVC, animated: true)
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
        let storyboard = UIStoryboard(name: "Setting", bundle: nil)
        let viewController = storyboard.instantiateViewController(viewControllerType:SettingViewController.self)
        
        let presenter: ViewToPresenterSettingProtocol & InteractorToPresenterSettingProtocol = SettingPresenter()
        let entity: InteractorToEntitySettingProtocol = SettingEntity()
        
        viewController.presenter = presenter
        viewController.presenter?.router = SettingRouter()
        viewController.presenter?.view = viewController
        viewController.presenter?.interactor = SettingInteractor()
        viewController.presenter?.interactor?.presenter = presenter
        viewController.presenter?.interactor?.entity = entity
        
        return viewController
    }
    
    func navigateToLogin() {
        LoginRouter().showScreen()
    }
    
    func navigateToHome() {
        HomeRouter().changeSelectedTabbar()
    }
    
    func navigateToPurchase() {
        PurchaseRouter().showScreen()
    }
    
    func navigateToReferral() {
        ReferralRouter().showScreen()
    }
    
    func navigateToMembership() {
        MembershipRouter().showScreen()
    }
    
    func navigateToAppSetting() {
        AppSettingRouter().showScreen()
    }
    
    func navigateToVerifyKyc(kycStatusModel: UserKycStatusDetailModel) {
        KycIntroduceRouter(kycStatusModel: kycStatusModel).showScreen()
    }
    
    func navigateToAnnouncements(viewcontroller: BaseViewController) {
        PopupHelper.shared.show(viewController: viewcontroller,
                                title: "kyc_fail_to_read_notice_title".Localizable(),
                                message: "dialog_navigateaway_content".Localizable(),
                                activeTitle: "dialog_go".Localizable(),
                                activeAction: {
            guard let url = URL(string: AppConstant.Link.announcements) else { return }
            UIApplication.shared.open(url)
        }, cancelTitle: "dialog_cancel".Localizable(), cancelAction: nil)
    }
    
    func navigateToHomePage(viewcontroller: BaseViewController) {
        PopupHelper.shared.show(viewController: viewcontroller,
                                title: "kyc_fail_to_read_notice_title".Localizable(),
                                message: "dialog_navigateaway_content".Localizable(),
                                activeTitle: "dialog_go".Localizable(),
                                activeAction: {
            guard let url = URL(string: AppConstant.Link.homePage) else { return }
            UIApplication.shared.open(url)
        }, cancelTitle: "dialog_cancel".Localizable(), cancelAction: nil)
    }
    
}
