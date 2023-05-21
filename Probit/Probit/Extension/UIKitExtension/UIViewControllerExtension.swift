//
//  UIViewControllerExtension.swift
//  Probit
//
//  Created by Beacon on 10/08/2022.
//

import UIKit
import SwiftEntryKit

extension UIViewController {
    // MARK: - Handle Root View
    func getRootViewController() -> UIViewController {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return BaseViewController()
        }
        
        if  let rootVC = appDelegate.window?.rootViewController as? BaseViewController {
            return rootVC
        }
        if let rootNav = appDelegate.window?.rootViewController as? UINavigationController, let firstVC = rootNav.viewControllers.first as? BaseViewController {
            return firstVC
        }
        return BaseViewController()
    }
    
    func getRootTabbarViewController() -> UINavigationController {
        let defaultController = UINavigationController(rootViewController: getRootViewController())
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate,
              let window = appDelegate.window,
              let rootController = window.rootViewController as? TabbarViewController else {
            return defaultController
        }
        let selectedIndex = rootController.selectedIndex
        
        guard let currentController = rootController.viewControllers?[selectedIndex] as? UINavigationController else {
            return defaultController
        }
        return currentController
    }
    
    
    func setupSelectedIndex(index: Int) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate,
              let window = appDelegate.window,
              let rootController = window.rootViewController as? TabbarViewController else { return }
        rootController.selectedIndex = index
    }
    
    func getLastViewControllerInNav() -> UIViewController {
        let rootViewController = self.getRootViewController()
        return rootViewController.navigationController?.viewControllers.last ?? BaseViewController()
    }
    
    // MARK: - Translation ViewController
    func pushTo<T: UIViewController>(desVC: T.Type, from storyboard: UIStoryboard = UIStoryboard.Splash, animated: Bool = true) -> T {
        let viewController = storyboard.instantiateViewController(viewControllerType: desVC.self)
        getRootViewController().navigationController?.pushViewController(viewController, animated: animated)
        return viewController
    }
    
    func pop(isAnimated: Bool = true) {
        self.navigationController?.popViewController(animated: isAnimated)
    }
    
    func popToViewController(index: Int = 0, animation: Bool = false) {
        guard let desVC = self.navigationController?.viewControllers[index] else { return }
        self.navigationController?.popToViewController(desVC, animated: animation)
    }
    
    func getCurrentIndex() -> Int {
        return (self.navigationController?.viewControllers.count ?? 0) - 1
    }
    
    func popToRoot(isAnimated: Bool = false) {
        getRootTabbarViewController().popToRootViewController(animated: isAnimated)
    }
    
    func present<T: UIViewController>(desVC: T.Type, from storyboard: UIStoryboard = UIStoryboard.Splash,
                                      style: UIModalPresentationStyle = .overCurrentContext,
                                      transitionType: CATransitionSubtype = .fromBottom,
                                      animated: Bool = true, hasNav: Bool = false,
                                      isClear: Bool = false) -> T {
        let viewController = storyboard.instantiateViewController(viewControllerType: desVC.self)
        
        viewController.view.backgroundColor = isClear ? UIColor.clear : viewController.view.backgroundColor
        if animated {
            let transition = CATransition()
            transition.duration = 0.4
            transition.type = CATransitionType.push
            transition.subtype = transitionType
            view.window?.layer.add(transition, forKey: kCATransition)
        }
        
        if  hasNav {
            let nav = UINavigationController.init(rootViewController: viewController)
            nav.modalPresentationStyle = style
            getRootViewController().present(nav, animated: false, completion: nil)
            return viewController
        }
        
        viewController.modalPresentationStyle = style
        getRootViewController().present(viewController, animated: false, completion: nil)
        return viewController
    }
    
    func dismiss(isAnimated: Bool = true, transitionType: CATransitionSubtype = .fromTop, onCompleted: @escaping () -> ()) {
        if isAnimated {
            let transition = CATransition()
            transition.duration = 0.4
            transition.type = CATransitionType.push
            transition.subtype = transitionType
            view.window?.layer.add(transition, forKey: kCATransition)
        }
        dismiss(animated: false, completion: onCompleted)
    }
    
    // MARK: -  Show Alert Controller
    func showActionSheet(title: String = "",selectionArray: [String], onTapped: @escaping (String) -> (), onCancel: @escaping () -> ()) {
        DispatchQueue.main.async {
            let actionSheetController: UIAlertController = UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)
            for title in selectionArray {
                actionSheetController.addAction(UIAlertAction(title: title, style: UIAlertAction.Style.default, handler: {_ in
                    DispatchQueue.main.async {
                        onTapped(title)
                    }
                }))
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .destructive) { (action:UIAlertAction!) in
                DispatchQueue.main.async {
                    onCancel()
                }
            }
            actionSheetController.addAction(cancelAction)
            self.present(actionSheetController, animated: true, completion: nil)
        }
    }
    
    func showAlert(title: String = "", message: String = "", onCancel: @escaping () -> ()) {
        DispatchQueue.main.async {
            let actionSheetController: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "OK", style: .destructive) { (action:UIAlertAction!) in
                onCancel()
            }
            actionSheetController.addAction(cancelAction)
            self.present(actionSheetController, animated: true, completion: nil)
        }
    }
    
    func hideKeyboardWhenTappedAround(isCancelTouchInView: Bool = false) {
        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tapGesture)
        tapGesture.cancelsTouchesInView = isCancelTouchInView
    }
}

extension UIViewController {
    func showPopupHelper(_ title: String?,
                         message: String?,
                         warning: String? = nil,
                         acceptTitle: String?,
                         cancleTitle: String?,
                         touchDismiss: Bool = true,
                         messageColor: UIColor? = nil,
                         acceptAction: (() -> Void)?,
                         cancelAction: (() -> Void)?) {
        DispatchQueue.main.async {
            PopupHelper.shared.show(viewController: self,
                                    title: title,
                                    message: message,
                                    warning: warning,
                                    activeTitle: acceptTitle,
                                    activeAction: acceptAction,
                                    cancelTitle: cancleTitle,
                                    cancelAction: cancelAction,
                                    touchDismiss: touchDismiss,
                                    messageColor: messageColor)
        }
    }
    
    func dismissPopup() {
        DispatchQueue.main.async {
            PopupHelper.shared.dismissPopup()
        }
    }
    
    func showFloatsMessage(title: String? = nil,
                           message: String? = nil,
                           type: FloatingType = .defaults,
                           insets: UIEdgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 12, right: 16)) {
        FloatingView.show(title: title ?? "", desc: message ?? "", type: type, insets: insets)
    }
    
    func showSuccess(message: String) {
        self.showFloatsMessage(message: message, type: .success)
    }
    
    func showError(error: ServiceError) {
        self.showFloatsMessage(message: error.message, type: .error)
    }
    
    func showErrorWarningPopup(_ acceptAction: (() -> Void)? = nil,
                               _ cancelAction: (() -> Void)? = nil) {
        showPopupHelper("dialog_notice".Localizable(),
                        message: "common_genericapierror".Localizable(),
                        warning: nil,
                        acceptTitle: "common_confirm".Localizable(),
                        cancleTitle: "dialog_cancel".Localizable(),
                        messageColor: UIColor.color_282828_fafafa,
                        acceptAction: { [weak self] in
            guard let self = self else { return }
            self.navigationController?.popToViewController(ofClass: SettingViewController.self)
        }, cancelAction: nil)
    }
}

extension UIPageViewController {
    var isPagingEnabled: Bool {
        get {
            var isEnabled: Bool = true
            for view in view.subviews {
                if let subView = view as? UIScrollView {
                    isEnabled = subView.isScrollEnabled
                }
            }
            return isEnabled
        }
        set {
            for view in view.subviews {
                if let subView = view as? UIScrollView {
                    subView.isScrollEnabled = newValue
                }
            }
        }
    }
}

extension UIApplication {
    
    func getTopViewController(base: UIViewController? = UIApplication.shared.mainKeyWindow?.rootViewController) -> UIViewController? {
        
        if let nav = base as? UINavigationController {
            return getTopViewController(base: nav.visibleViewController)
            
        } else if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
            return getTopViewController(base: selected)
            
        } else if let presented = base?.presentedViewController {
            return getTopViewController(base: presented)
        }
        return base
    }
    
    var mainKeyWindow: UIWindow? {
        if #available(iOS 13, *) {
            return connectedScenes.flatMap { ($0 as? UIWindowScene)?.windows ?? [] }.first { $0.isKeyWindow }
        } else {
            return keyWindow
        }
    }
}
