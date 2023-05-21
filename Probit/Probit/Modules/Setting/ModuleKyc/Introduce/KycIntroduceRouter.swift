//
//  KycIntroduceRouter.swift
//  Probit
//
//  Created by Bradley Hoang on 01/11/2022.
//  
//

import UIKit

class KycIntroduceRouter: PresenterToRouterKycIntroduceProtocol {
    var kycStatusModel: UserKycStatusDetailModel
    
    init(kycStatusModel: UserKycStatusDetailModel) {
        self.kycStatusModel = kycStatusModel
    }
    
    func showScreen(leftTitle: String? = nil) {
        let destinationVC = createModule(leftTitle: leftTitle)
        destinationVC.getRootTabbarViewController().pushViewController(destinationVC, animated: true)
    }
    
    func setupRootView() {
        guard let appdelegate = UIApplication.shared.delegate as? AppDelegate,
              let window = appdelegate.window else { return }
        
        let destinationVC = createModule()
        window.rootViewController = UINavigationController.init(rootViewController: destinationVC)
        window.makeKeyAndVisible()
    }
    
    // MARK: Static methods
    func createModule(leftTitle: String? = nil) -> UIViewController {
        let storyboard = UIStoryboard(name: "KycIntroduce", bundle: nil)
        let viewController = storyboard.instantiateViewController(viewControllerType:KycIntroduceViewController.self)
        
        let presenter: ViewToPresenterKycIntroduceProtocol & InteractorToPresenterKycIntroduceProtocol = KycIntroducePresenter()
        
        if let leftTitle = leftTitle {
            viewController.leftTitle = leftTitle
        }
        viewController.hidesBottomBarWhenPushed = true
        viewController.presenter = presenter
        viewController.presenter?.router = self
        viewController.presenter?.view = viewController
        viewController.presenter?.interactor = KycIntroduceInteractor(kycStatusModel: kycStatusModel)
        viewController.presenter?.interactor?.presenter = presenter
        return viewController
    }
    
    func navigateToKycSelectCountry() {
        KycSelectCountryRouter().showScreen()
    }
    
    func navigateInputType() {
        KycPersonalInfoInputRouter().showScreen()
    }

    func navigateSelfImageClear() {
        PhotoIsClearRouter(stylePhoto: .FACE).showScreen()
    }
}
