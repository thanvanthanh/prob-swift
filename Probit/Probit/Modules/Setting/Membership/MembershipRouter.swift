//
//  MembershipRouter.swift
//  Probit
//
//  Created by Thân Văn Thanh on 30/08/2022.
//  
//

import Foundation
import UIKit

class MembershipRouter: PresenterToRouterMembershipProtocol {
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
        let storyboard = UIStoryboard(name: "Membership", bundle: nil)
        let viewController = storyboard.instantiateViewController(viewControllerType:MembershipViewController.self)
        
        let presenter: ViewToPresenterMembershipProtocol & InteractorToPresenterMembershipProtocol = MembershipPresenter()
        let entity: InteractorToEntityMembershipProtocol = MembershipEntity()
        
        viewController.hidesBottomBarWhenPushed = true
        viewController.presenter = presenter
        viewController.presenter?.router = MembershipRouter()
        viewController.presenter?.view = viewController
        let interactor = MembershipInteractor()
        viewController.presenter?.interactor = interactor
        viewController.presenter?.stakeInteracter = interactor
        viewController.presenter?.interactor?.presenter = presenter
        viewController.presenter?.interactor?.entity = entity
        
        return viewController
    }
    
    func navigateToTradingFeeWebsite(viewcontroller: BaseViewController) {
        PopupHelper.shared.show(viewController: viewcontroller,
                                title: "kyc_fail_to_read_notice_title".Localizable(),
                                message: "dialog_navigateaway_content".Localizable(),
                                activeTitle: "dialog_go".Localizable(),
                                activeAction: {
            guard let url = URL(string: AppConstant.Link.tradingFee) else { return }
            UIApplication.shared.open(url)
        }, cancelTitle: "dialog_cancel".Localizable(), cancelAction: nil)
    }
}
