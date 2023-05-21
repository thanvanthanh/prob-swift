//
//  PopUpHelper.swift
//  DemoAlert
//
//  Created by Thanh Than Van on 09/08/2022.
//

import UIKit
enum CompleteTypePopup {
    case STAKE
    case PURCHASE
    case PURCHASE_STAKE_LEVER_UP
    case PURCHASE_STAKE
}

typealias Action = (() -> Void)

class PopupHelper {
    static let shared = PopupHelper()
    
    var destinationViewController: UIViewController?
    
    func show(viewController: UIViewController,
              title: String?,
              message: String?,
              warning: String? = nil,
              activeTitle: String?,
              activeAction: Action?,
              cancelTitle: String?,
              cancelAction: Action?,
              touchDismiss: Bool = true,
              isCameraView: Bool? = nil,
              messageColor: UIColor? = nil,
              warningColor: UIColor? = nil) {
        
        let alertVC = CommonAlertVC.init(nibName: "CommonAlertVC", bundle: nil)
        alertVC
            .load()
            .setTitle(title)
            .setMessage(message, color: messageColor)
            .setWarning(warning, color: warningColor)
            .setActiveButton(activeTitle)
            .setActiveButton(activeAction)
            .setCancelButton(cancelTitle)
            .setCancelButton(cancelAction)
            .setForCamera(isCameraView ?? false)
            .setTouchToDismiss(enable: touchDismiss)
        destinationViewController = alertVC
        
        alertVC.modalPresentationStyle = .overFullScreen
        alertVC.modalTransitionStyle = .crossDissolve
        viewController.present(alertVC, animated: true)
    }
    
    func showSuccessVC(viewController: UIViewController,
                       title: String,
                       image: String,
                       onDismiss: @escaping () -> Void) {
        let alertVC = CompleteAlertVC.init(nibName: "CompleteAlertVC", bundle: nil)
        alertVC
            .load()
            .setTitle(title)
            .setImage(image)
            .setOnDismiss(onDismiss: onDismiss)
            .setUpType(.STAKE)
        destinationViewController = alertVC
        alertVC.modalPresentationStyle = .fullScreen
        alertVC.modalTransitionStyle = .crossDissolve
        viewController.present(alertVC, animated: true)
    }
    
    func showPurchaseCompleteVC(viewController: UIViewController,
                                title: String,
                                image: String,
                                typeScreen: CompleteTypePopup,
                                onDismiss: @escaping () -> Void) {
        let alertVC = CompleteAlertVC.init(nibName: "CompleteAlertVC", bundle: nil)
        alertVC
            .load()
            .setTitle(title)
            .setImage(image)
            .setOnDismiss(onDismiss: onDismiss)
            .setUpType(typeScreen)
        destinationViewController = alertVC
        alertVC.modalPresentationStyle = .fullScreen
        alertVC.modalTransitionStyle = .crossDissolve
        viewController.present(alertVC, animated: true)
    }
    
    func showGuideVC (viewController: UIViewController,
                      title: String,
                      message: String,
                      image: UIImage?,
                      onDismiss: (() -> Void)? = nil) {
        let alertVC = GuideAlertVC.init(nibName: "GuideAlertVC", bundle: nil)
        alertVC
            .load()
            .setTitle(title)
            .setImage(image)
            .setOnDismiss(onDismiss: onDismiss)
        
        destinationViewController = alertVC
        alertVC.modalPresentationStyle = .fullScreen
        alertVC.modalTransitionStyle = .crossDissolve
        viewController.present(alertVC, animated: true)
    }
    
    func dismissPopup() {
        destinationViewController?.dismiss(animated: false)
    }
}
