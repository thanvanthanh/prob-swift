//
//  StakeDetailsRouter.swift
//  Probit
//
//  Created by Đào Mỹ Đông on 23/09/2565 BE.
//  
//

import Foundation
import UIKit

class StakeDetailsRouter: PresenterToRouterStakeDetailsProtocol {
    var parentTypeVC: TypeViewController

    init(parentTypeVC: TypeViewController) {
        self.parentTypeVC = parentTypeVC
    }
    
    func showScreen(stakeEvent: StakeEventModel,
                    stakeCurrency: StakeCurrency?,
                    walletCurrency: WalletCurrency) {
        let destinationVC = self.createModule(stakeEvent: stakeEvent,
                                              stakeCurrency: stakeCurrency,
                                              walletCurrency: walletCurrency)
        destinationVC.getRootTabbarViewController().push(viewController: destinationVC, ishidesBottomBar: true)
    }
    
    func setupRootView(stakeEvent: StakeEventModel,
                       stakeCurrency: StakeCurrency?,
                       walletCurrency: WalletCurrency) {
        guard let appdelegate = UIApplication.shared.delegate as? AppDelegate,
              let window = appdelegate.window else { return }
        
        let destinationVC = self.createModule(stakeEvent: stakeEvent,
                                              stakeCurrency: stakeCurrency,
                                              walletCurrency: walletCurrency)
        window.rootViewController = UINavigationController.init(rootViewController: destinationVC)
        window.makeKeyAndVisible()
    }
    
    // MARK: Static methods
    func createModule(stakeEvent: StakeEventModel,
                      stakeCurrency: StakeCurrency?,
                      walletCurrency: WalletCurrency) -> UIViewController {
        let storyboard = UIStoryboard(name: "StakeDetails", bundle: nil)
        let viewController = storyboard.instantiateViewController(viewControllerType:StakeDetailsViewController.self)
        let presenter: ViewToPresenterStakeDetailsProtocol & InteractorToPresenterStakeDetailsProtocol = StakeDetailsPresenter()
        
        viewController.presenter = presenter
        viewController.presenter?.router = self
        viewController.presenter?.view = viewController
        viewController.presenter?.interactor = StakeDetailsInteractor(stakeEvent: stakeEvent,
                                                                      stakeCurrency: stakeCurrency,
                                                                      walletCurrency:  walletCurrency,
                                                                      parentTypeVC: parentTypeVC)
        viewController.presenter?.interactor?.presenter = presenter
        
        return viewController
    }
}
