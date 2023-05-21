//
//  StakingAmountRouter.swift
//  Probit
//
//  Created by Đào Mỹ Đông on 30/09/2565 BE.
//  
//

import Foundation
import UIKit

enum StakingType : String{
    case STAKE = "STAKE"
    case UN_STAKE = "UN_STAKE"
    
    func titleNav(currencyTitle: String) -> String {
        switch self {
        case .STAKE:
            return  String(format:"activity_stake_title".Localizable(), currencyTitle)
        case .UN_STAKE:
            return String(format:"activity_unstake_title".Localizable(), currencyTitle)
        }
    }
}

class StakingAmountRouter: PresenterToRouterStakingAmountProtocol {
    var stakingType: StakingType
    var interactorDetail: StakeDetailsInteractorProtocol
    init(stakingType: StakingType,
         interactorDetail: StakeDetailsInteractorProtocol) {
        self.stakingType = stakingType
        self.interactorDetail = interactorDetail
    }
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
        let storyboard = UIStoryboard(name: "StakingAmount", bundle: nil)
        let viewController = storyboard.instantiateViewController(viewControllerType:StakingAmountViewController.self)
        
        let presenter: ViewToPresenterStakingAmountProtocol & InteractorToPresenterStakingAmountProtocol = StakingAmountPresenter()
        viewController.interactorDetail = self.interactorDetail
        viewController.stakingType = self.stakingType
        viewController.presenter = presenter
        viewController.presenter?.router = self
        viewController.presenter?.view = viewController
        viewController.presenter?.interactor = StakingAmountInteractor()
        viewController.presenter?.interactor?.presenter = presenter
        return viewController
    }
    
    func goToTerm(currencyId: String, period: Int, amount: String) {
        StakingAmountTermRouter(stakeTermType: stakingType,
                                interactorDetail: self.interactorDetail,
                                currencyId: currencyId,
                                period: period,
                                amount: amount).showScreen()
    }
}    
