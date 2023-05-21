//
//  AppSettingTermsAndPoliciesRouter.swift
//  Probit
//
//  Created by Thân Văn Thanh on 31/08/2022.
//  
//

import Foundation
import UIKit

class AppSettingTermsAndPoliciesRouter: PresenterToRouterAppSettingTermsAndPoliciesProtocol {
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
        let storyboard = UIStoryboard(name: "AppSettingTermsAndPolicies", bundle: nil)
        let viewController = storyboard.instantiateViewController(viewControllerType:AppSettingTermsAndPoliciesViewController.self)
        
        let presenter: ViewToPresenterAppSettingTermsAndPoliciesProtocol & InteractorToPresenterAppSettingTermsAndPoliciesProtocol = AppSettingTermsAndPoliciesPresenter()
        let entity: InteractorToEntityAppSettingTermsAndPoliciesProtocol = AppSettingTermsAndPoliciesEntity()
        
        viewController.presenter = presenter
        viewController.presenter?.router = AppSettingTermsAndPoliciesRouter()
        viewController.presenter?.view = viewController
        viewController.presenter?.interactor = AppSettingTermsAndPoliciesInteractor()
        viewController.presenter?.interactor?.presenter = presenter
        viewController.presenter?.interactor?.entity = entity
        
        return viewController
    }
    
    func showAlert(msg: String) {
        let topViewController = UIApplication.shared.getTopViewController()
        topViewController?.showPopupHelper("dialog_notice".Localizable(),
                                           message: msg,
                                           acceptTitle: "common_confirm".Localizable(),
                                           cancleTitle: nil, acceptAction: nil,
                                           cancelAction: nil)
    }
    
    func navigateToWebView(url: String) {
        CommonWebViewRouter().showScreen(titleBackScreen: "fragment_settings_terms".Localizable(),
                                         urlString: nil,
                                         html: url,
                                         titleNavigation: "")
    }
    
    func headerAction(terms: TermsAndPolicies) {
        switch terms.title {
        case .privacy:
            navigateToWeb(url: AppConstant.Link.privacy)
        case .terms:
            navigateToWeb(url: AppConstant.Link.termsOfService)
        case .thirdParty:
            ThirdPartyRouter().showScreen()            
        default: break
        }
    }
    
    private func navigateToWeb(url: String) {
        guard let topViewController = UIApplication.shared.getTopViewController() else { return }
        PopupHelper.shared.show(viewController: topViewController,
                                title: "kyc_fail_to_read_notice_title".Localizable(),
                                message: "dialog_navigateaway_content".Localizable(),
                                activeTitle: "dialog_go".Localizable(),
                                activeAction: {
            guard let url = URL(string: url) else { return }
            UIApplication.shared.open(url)
        }, cancelTitle: "dialog_cancel".Localizable(), cancelAction: nil)
    }
    
}
