//
//  KycCalendarRouter.swift
//  Probit
//
//  Created by Bradley Hoang on 09/11/2022.
//  
//

import UIKit

class KycCalendarRouter: PresenterToRouterKycCalendarProtocol {
    func showScreen(delegate: KycCalendarDelegate,
                    selectedDate: Date) {
        let destinationVC = createModule(delegate: delegate,
                                         selectedDate: selectedDate)
        destinationVC.modalTransitionStyle = .crossDissolve
        destinationVC.modalPresentationStyle = .overFullScreen
        destinationVC.getRootTabbarViewController().present(destinationVC, animated: true)
    }
    
    func setupRootView(delegate: KycCalendarDelegate,
                       selectedDate: Date) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate,
              let window = appDelegate.window else { return }
        
        let destinationVC = createModule(delegate: delegate,
                                         selectedDate: selectedDate)
        window.rootViewController = UINavigationController.init(rootViewController: destinationVC)
        window.makeKeyAndVisible()
    }
    
    // MARK: Static methods
    func createModule(delegate: KycCalendarDelegate,
                      selectedDate: Date) -> UIViewController {
        let storyboard = UIStoryboard(name: "KycCalendar", bundle: nil)
        let viewController = storyboard.instantiateViewController(viewControllerType:KycCalendarViewController.self)
        
        let presenter: ViewToPresenterKycCalendarProtocol & InteractorToPresenterKycCalendarProtocol = KycCalendarPresenter()
        
        viewController.presenter = presenter
        viewController.presenter?.router = KycCalendarRouter()
        viewController.presenter?.view = viewController
        viewController.presenter?.delegate = delegate
        viewController.presenter?.selectedDate = selectedDate
        viewController.presenter?.interactor = KycCalendarInteractor()
        viewController.presenter?.interactor?.presenter = presenter
        
        return viewController
    }
    
    func dismissView(_ view: UIViewController) {
        view.dismiss(animated: true)
    }
}
