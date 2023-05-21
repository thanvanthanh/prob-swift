//
//  AppSettingLanguageRouter.swift
//  Probit
//
//  Created by Thân Văn Thanh on 31/08/2022.
//  
//

import Foundation
import UIKit

class AppSettingLanguageRouter: PresenterToRouterAppSettingLanguageProtocol {
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
        let storyboard = UIStoryboard(name: "AppSettingLanguage", bundle: nil)
        let viewController = storyboard.instantiateViewController(viewControllerType:AppSettingLanguageViewController.self)
        
        let presenter: ViewToPresenterAppSettingLanguageProtocol & InteractorToPresenterAppSettingLanguageProtocol = AppSettingLanguagePresenter()
        
        viewController.presenter = presenter
        viewController.presenter?.router = AppSettingLanguageRouter()
        viewController.presenter?.view = viewController
        viewController.presenter?.interactor = AppSettingLanguageInteractor()
        viewController.presenter?.interactor?.presenter = presenter
        
        return viewController
    }
    
}
