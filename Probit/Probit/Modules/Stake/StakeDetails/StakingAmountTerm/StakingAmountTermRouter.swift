//
//  StakingAmountTermRouter.swift
//  Probit
//
//  Created by Đào Mỹ Đông on 03/10/2565 BE.
//  
//

import Foundation
import UIKit

class StakingAmountTermRouter: PresenterToRouterStakingAmountTermProtocol {
    var stakeTermType: StakingType
    var currencyId: String
    var period: Int
    var amount: String
    var interactorDetail: StakeDetailsInteractorProtocol
    init(stakeTermType: StakingType,
         interactorDetail: StakeDetailsInteractorProtocol,
         currencyId: String,
         period: Int, amount: String) {
        self.stakeTermType = stakeTermType
        self.currencyId = currencyId
        self.period = period
        self.amount = amount
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
        let storyboard = UIStoryboard(name: "StakingAmountTerm", bundle: nil)
        let viewController = storyboard.instantiateViewController(viewControllerType:StakingAmountTermViewController.self)
        
        let presenter: ViewToPresenterStakingAmountTermProtocol & InteractorToPresenterStakingAmountTermProtocol = StakingAmountTermPresenter(interactorDetail: self.interactorDetail)
        viewController.currencyId = self.currencyId
        viewController.presenter = presenter
        viewController.presenter?.router = self
        viewController.presenter?.view = viewController
        viewController.presenter?.interactor = StakingAmountTermInteractor(currencyId: currencyId, period: period, amount: amount)
        viewController.presenter?.interactor?.presenter = presenter
        return viewController
    }
    
}
