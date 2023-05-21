//
//  FillterHistoryRouter.swift
//  Probit
//
//  Created by Đào Mỹ Đông on 12/10/2565 BE.
//  
//

import Foundation
import UIKit

class FillterHistoryRouter: PresenterToRouterFillterHistoryProtocol {
    var filterDelegate: FilterSearchViewDelegate

    init(delegate: FilterSearchViewDelegate) {
        self.filterDelegate = delegate
    }
    func showScreen(isHideCurrency: Bool = false) {
        let destinationVC = self.createModule(isHideCurrency: isHideCurrency)
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
    func createModule(isHideCurrency: Bool = false) -> UIViewController {
        let storyboard = UIStoryboard(name: "FillterHistory", bundle: nil)
        let viewController = storyboard.instantiateViewController(viewControllerType:FillterHistoryViewController.self)
        
        let presenter: ViewToPresenterFillterHistoryProtocol & InteractorToPresenterFillterHistoryProtocol = FillterHistoryPresenter()
        viewController.hidesBottomBarWhenPushed = true
        viewController.filterDelegate = filterDelegate
        viewController.presenter = presenter
        viewController.presenter?.isHideCurrencyView = isHideCurrency
        viewController.presenter?.router = self
        viewController.presenter?.view = viewController
        viewController.presenter?.interactor = FillterHistoryInteractor()
        viewController.presenter?.interactor?.presenter = presenter
        return viewController
    }
}

