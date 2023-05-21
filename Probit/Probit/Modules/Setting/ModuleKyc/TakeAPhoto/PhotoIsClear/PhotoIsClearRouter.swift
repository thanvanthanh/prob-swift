//
//  PhotoIsClearRouter.swift
//  Probit
//
//  Created by Đào Mỹ Đông on 08/11/2565 BE.
//  
//

import Foundation
import UIKit

class PhotoIsClearRouter: PresenterToRouterPhotoIsClearProtocol {
    var stylePhoto: StylePhoto
    init(stylePhoto: StylePhoto) {
        self.stylePhoto = stylePhoto
    }
    func showScreen() {
        let destinationVC = self.createModule()
        destinationVC.getRootTabbarViewController().pushViewController(destinationVC, animated: true)
    }
    
    func setupRootView() {
        let destinationVC = self.createModule()
        guard let appdelegate = UIApplication.shared.delegate as? AppDelegate,
              let window = appdelegate.window else { return }
        window.rootViewController = UINavigationController.init(rootViewController: destinationVC)
        window.makeKeyAndVisible()
    }
    
    // MARK: Static methods
     func createModule() -> UIViewController {
        let storyboard = UIStoryboard(name: "PhotoIsClear", bundle: nil)
        let viewController = storyboard.instantiateViewController(viewControllerType:PhotoIsClearViewController.self)
        
        let presenter: ViewToPresenterPhotoIsClearProtocol & InteractorToPresenterPhotoIsClearProtocol = PhotoIsClearPresenter()
        
        viewController.presenter = presenter
        viewController.presenter?.router = self
        viewController.presenter?.view = viewController
        viewController.presenter?.interactor = PhotoIsClearInteractor(stylePhoto: stylePhoto)
        viewController.presenter?.interactor?.presenter = presenter
        return viewController
    }
    
    func navigateReTakePhoto(stylePhoto: StylePhoto) {
        let destinationVC = self.createModule()
        let nav = destinationVC
            .getRootTabbarViewController()
        guard let vc = nav.viewControllers.last(where: { $0.isKind(of: TakeAPhotoViewController.self) }) as? TakeAPhotoViewController else {
            TakeAPhotoRouter(stylePhoto: stylePhoto).showScreen()
            return
        }
        if vc.stylePhoto == stylePhoto {
            nav.popToViewController(vc, animated: true)
        } else {
            TakeAPhotoRouter(stylePhoto: stylePhoto).showScreen()
        }
    }
}
