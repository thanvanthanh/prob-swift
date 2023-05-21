//
//  StakeCollectionRouter.swift
//  Probit
//
//  Created by Đào Mỹ Đông on 22/09/2565 BE.
//  
//

import Foundation
import UIKit

enum StakeCollectionType {
    case UP_COMING
    case RUNNING
    case ALL
}

class StakeCollectionRouter: PresenterToRouterStakeCollectionProtocol {
    var viewController: StakeCollectionViewController?
    func showScreen(type: StakeCollectionType) {
        let destinationVC = self.createModule(type: type)
            destinationVC.getRootViewController().navigationController?.pushViewController(destinationVC, animated: true)
    }
    
    func setupRootView(type: StakeCollectionType) {
        guard let appdelegate = UIApplication.shared.delegate as? AppDelegate,
              let window = appdelegate.window else { return }
        let destinationVC = self.createModule(type: type)
        window.rootViewController = UINavigationController.init(rootViewController: destinationVC)
        window.makeKeyAndVisible()
    }
    
    // MARK: Static methods
    func createModule(type: StakeCollectionType) -> UIViewController {
        let storyboard = UIStoryboard(name: "StakeCollection", bundle: nil)
        viewController = storyboard.instantiateViewController(viewControllerType:StakeCollectionViewController.self)
        let presenter: ViewToPresenterStakeCollectionProtocol & InteractorToPresenterStakeCollectionProtocol = StakeCollectionPresenter()
        viewController?.presenter = presenter
        viewController?.presenter?.router = self
        viewController?.presenter?.view = viewController
        viewController?.presenter?.interactor = StakeCollectionInteractor(type: type)
        viewController?.presenter?.interactor?.presenter = presenter
        return viewController!
    }
    
    func navigateToStakeDetails(stakeEvent: StakeEventModel,
                                stakeCurrency: StakeCurrency?,
                                walletCurrency: WalletCurrency) {
        if AppConstant.isLogin {
            StakeDetailsRouter(parentTypeVC: .STAKE).showScreen(stakeEvent: stakeEvent,
                                            stakeCurrency: stakeCurrency,
                                            walletCurrency: walletCurrency)
        } else {
            guard let viewController = self.viewController else { return  }
            PopupHelper.shared.show(viewController: viewController.getRootTabbarViewController(),
                                    title: "dialog_login_needed_title".Localizable(),
                                    message: "dialog_login_needed_content".Localizable(),
                                    activeTitle: "login_btn_login".Localizable(),
                                    activeAction: {
                LoginRouter().showScreen()
            }, cancelTitle: "dialog_cancel".Localizable(), cancelAction: nil)
        }
    }
}
