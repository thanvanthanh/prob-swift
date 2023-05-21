//
//  InputPinRouter.swift
//  Probit
//
//  Created by Thân Văn Thanh on 22/08/2022.
//  
//

import Foundation
import UIKit

class InputPinRouter: PresenterToRouterInputPinProtocol {
    func showScreen(type: InputPinType) {
        let destinationVC = self.createModule(type: type)
        destinationVC.hidesBottomBarWhenPushed = true
        destinationVC.getRootTabbarViewController().pushViewController(destinationVC, animated: true)
    }
    
    func setupRootView(type: InputPinType) {
        guard let appdelegate = UIApplication.shared.delegate as? AppDelegate,
              let window = appdelegate.window else { return }
        
        let destinationVC = self.createModule(type: type)
        window.rootViewController = UINavigationController.init(rootViewController: destinationVC)
        window.makeKeyAndVisible()
    }
    
    // MARK: Static methods
    func createModule(type: InputPinType) -> UIViewController {
        let storyboard = UIStoryboard(name: "InputPin", bundle: nil)
        let viewController = storyboard.instantiateViewController(viewControllerType:InputPinViewController.self)
        
        let presenter: ViewToPresenterInputPinProtocol & InteractorToPresenterInputPinProtocol = InputPinPresenter()
        
        viewController.presenter = presenter
        viewController.presenter?.router = InputPinRouter()
        viewController.presenter?.view = viewController
        viewController.presenter?.interactor = InputPinInteractor()
        viewController.presenter?.interactor?.presenter = presenter
        viewController.presenter?.interactor?.type = type
        
        return viewController
    }
    
    func navigateToTerms() {
        let controller = TermsRouter().createModule(screenFrom: .signUp)
        controller.getRootViewController().navigationController?.pushViewController(controller, animated: true)
    }
    
    func navigateToComplete() {
        SignUpCompleteRouter().showScreen(type: .pinSetting)
    }
    
    func logoutWrongPinThirtyTimes(viewController: BaseViewController) {
        AppConstant.logout()
        viewController.dismiss(animated: true)
        DispatchQueue.main.async(execute: {
            AppDelegate.shared.setRootScreen()
        })
    }
    
    func navigateToLogout(viewController: BaseViewController) {
        PopupHelper.shared.show(viewController: viewController,
                                title: "dialog_forgot_password_title".Localizable(),
                                message: "dialog_forgot_password_content".Localizable(),
                                warning: "dialog_forgot_password_warning".Localizable(),
                                activeTitle: "common_confirm".Localizable(),
                                activeAction: {
            AppConstant.logout()
            viewController.popToRoot(isAnimated: false)
            LoginRouter().showScreen(type: .inputPin)
        }, cancelTitle: "dialog_cancel".Localizable(), cancelAction: nil)
    }
    
}
