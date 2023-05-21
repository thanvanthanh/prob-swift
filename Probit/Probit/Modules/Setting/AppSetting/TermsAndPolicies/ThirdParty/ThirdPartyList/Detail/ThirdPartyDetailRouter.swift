//
//  ThirdPartyDetailRouter.swift
//  Probit
//
//  Created by Thân Văn Thanh on 08/12/2022.
//  
//

import Foundation
import UIKit

class ThirdPartyDetailRouter: PresenterToRouterThirdPartyDetailProtocol {
    func showScreen(html: String) {
        let destinationVC = self.createModule(html: html)
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
    func createModule(html: String = "") -> UIViewController {
        let storyboard = UIStoryboard(name: "ThirdPartyDetail", bundle: nil)
        let viewController = storyboard.instantiateViewController(viewControllerType:ThirdPartyDetailViewController.self)
        
        let presenter: ViewToPresenterThirdPartyDetailProtocol & InteractorToPresenterThirdPartyDetailProtocol = ThirdPartyDetailPresenter()
        
        viewController.presenter = presenter
        viewController.presenter?.router = ThirdPartyDetailRouter()
        viewController.presenter?.view = viewController
        viewController.presenter?.interactor = ThirdPartyDetailInteractor()
        viewController.presenter?.interactor?.presenter = presenter
        viewController.presenter?.html = html
        
        return viewController
    }
    
    func navigateToWeb(url: URL) {
        guard let topViewController = UIApplication.shared.getTopViewController() else { return }
        PopupHelper.shared.show(viewController: topViewController,
                                title: "kyc_fail_to_read_notice_title".Localizable(),
                                message: "dialog_navigateaway_content".Localizable(),
                                activeTitle: "dialog_go".Localizable(),
                                activeAction: {
            UIApplication.shared.open(url)
        }, cancelTitle: "dialog_cancel".Localizable(), cancelAction: nil)
    }
}
