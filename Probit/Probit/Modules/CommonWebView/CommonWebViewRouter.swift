//
//  CommonWebViewRouter.swift
//  Probit
//
//  Created by Nguyen Quang on 07/09/2022.
//  
//

import Foundation
import UIKit

class CommonWebViewRouter: PresenterToRouterCommonWebViewProtocol {
    func showScreen(titleBackScreen: String?,
                    urlString: String?,
                    html: String? = nil,
                    titleNavigation: String?,
                    fileName: String? = nil,
                    type: String? = nil) {
        let destinationVC = self.createModule(titleBackScreen: titleBackScreen,
                                              html: html, urlString: urlString,
                                              titleNavigation: titleNavigation,
                                              fileName: fileName,
                                              type: type)
        guard let rootViewController = UIApplication.shared.getTopViewController() else { return }
        rootViewController.navigationController?.push(viewController: destinationVC)
    }
    
    // MARK: Static methods
    func createModule(titleBackScreen: String?,
                      html: String?,
                      urlString: String?,
                      titleNavigation: String?,
                      fileName: String?,
                      type: String?) -> UIViewController {
        let storyboard = UIStoryboard(name: "CommonWebView", bundle: nil)
        let viewController = storyboard.instantiateViewController(viewControllerType:CommonWebViewViewController.self)
        
        let presenter: ViewToPresenterCommonWebViewProtocol & InteractorToPresenterCommonWebViewProtocol = CommonWebViewPresenter()
        
        viewController.presenter = presenter
        viewController.presenter?.html = html
        viewController.presenter?.urlString = urlString
        viewController.presenter?.titleBackScreen = titleBackScreen
        viewController.presenter?.titleNavigation = titleNavigation
        viewController.presenter?.fileName = fileName
        viewController.presenter?.type = type

        viewController.presenter?.router = CommonWebViewRouter()
        viewController.presenter?.view = viewController
        viewController.presenter?.interactor = CommonWebViewInteractor()
        viewController.presenter?.interactor?.presenter = presenter
        
        return viewController
    }
    
    func gotoLogin() {
        LoginRouter().showScreen()
    }
}
