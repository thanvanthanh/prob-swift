//
//  StakingRouter.swift
//  Probit
//
//  Created by Đào Mỹ Đông on 23/09/2565 BE.
//  
//

import Foundation
import UIKit

class StakingRouter: PresenterToRouterStakingProtocol {
    var interactorDetail: StakeDetailsInteractorProtocol
    init(interactorDetail: StakeDetailsInteractorProtocol) {
        self.interactorDetail = interactorDetail
    }
    func showScreen(displayName: String? ) {
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
        let storyboard = UIStoryboard(name: "Staking", bundle: nil)
        let viewController = storyboard.instantiateViewController(viewControllerType:StakingViewController.self)
        
        let presenter: ViewToPresenterStakingProtocol & InteractorToPresenterStakingProtocol = StakingPresenter()
        viewController.presenter = presenter
        viewController.presenter?.router = self
        viewController.presenter?.view = viewController
        viewController.presenter?.interactor = StakingInteractor()
        viewController.presenter?.interactor?.presenter = presenter
        viewController.presenter?.interactor?.displayName = interactorDetail.walletCurrency?.currency?.displayName?.localized
        return viewController
    }
    
    func navigateToStakeAmount() {
        StakingAmountRouter(stakingType: .STAKE,
                            interactorDetail: interactorDetail).showScreen()
    }
    
    func navigateToUnStake() {
        StakingAmountRouter(stakingType: .UN_STAKE,
                            interactorDetail: interactorDetail).showScreen()
    }
    
    func navigateToStakeHistory() {
        StakeHistoryRouter(interactorDetail: interactorDetail).showScreen()
    }
}
