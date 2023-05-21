//
//  TermsRouter.swift
//  Probit
//
//  Created by Nguyen Quang on 22/08/2022.
//  
//

import Foundation
import UIKit

class TermsRouter: PresenterToRouterTermsProtocol {
    func showScreen(animated: Bool = true,
                    screenFrom: AuthScreenFrom = .signUp) {
        guard let topVC = UIApplication.shared.getTopViewController() else { return }
        let destinationVC = self.createModule(screenFrom: screenFrom)
        destinationVC.hidesBottomBarWhenPushed = true
        topVC.navigationController?.pushViewController(destinationVC, animated: animated)
    }
    
    func setupRootView() {
        guard let appdelegate = UIApplication.shared.delegate as? AppDelegate,
              let window = appdelegate.window else { return }
        
        let destinationVC = self.createModule(screenFrom: .signUp)
        window.rootViewController = UINavigationController.init(rootViewController: destinationVC)
        window.makeKeyAndVisible()
    }
    
    // MARK: Static methods
    func createModule(screenFrom: AuthScreenFrom) -> UIViewController {
        let storyboard = UIStoryboard(name: "Terms", bundle: nil)
        let viewController = storyboard.instantiateViewController(viewControllerType:TermsViewController.self)
        
        let presenter: ViewToPresenterTermsProtocol & InteractorToPresenterTermsProtocol = TermsPresenter()
        let entity: InteractorToEntityTermsProtocol = TermsEntity()
        
        viewController.presenter = presenter
        viewController.presenter?.router = TermsRouter()
        viewController.presenter?.view = viewController
        viewController.presenter?.interactor = TermsInteractor()
        viewController.presenter?.interactor?.presenter = presenter
        viewController.presenter?.interactor?.screenFrom = screenFrom
        viewController.presenter?.interactor?.entity = entity
        
        return viewController
    }
    
    func nextScreen(screenFrom: AuthScreenFrom, agreements: Agreements?) {
        guard screenFrom == .signUp else {
            TabbarRouter().setupRootView()
            return
        }
        SignUpRouter().showScreen(agreements: agreements)
    }
    
    func navigateToWebView(url: String) {
        CommonWebViewRouter().showScreen(titleBackScreen: "Terms and Conditions",
                                         urlString: nil,
                                         html: url,
                                         titleNavigation: "")
    }
}
