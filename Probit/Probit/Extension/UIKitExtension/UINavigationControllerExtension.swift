//
//  UINavigationControllerExtension.swift
//  Probit
//
//  Created by Nguyen Quang on 30/08/2022.
//

import UIKit

public extension UINavigationController {

    func pop(transitionType type: CATransitionType = .fade, duration: CFTimeInterval = 0.3) {
        self.addTransition(transitionType: type,
                           subtype: .fromLeft,
                           duration: duration)
        self.popViewController(animated: false)
    }

    func push(viewController vc: UIViewController,
              isAnimated: Bool = true,
              ishidesBottomBar: Bool = true) {
        vc.hidesBottomBarWhenPushed = ishidesBottomBar
        self.pushViewController(vc, animated: isAnimated)
    }

    private func addTransition(transitionType type: CATransitionType = .fade,
                               subtype: CATransitionSubtype,
                               duration: CFTimeInterval = 0.3) {
        let transition = CATransition()
        transition.duration = duration
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = type
        transition.subtype = subtype
        
        self.view.layer.add(transition, forKey: nil)
    }
    
    func popToViewController(ofClass: AnyClass,
                             animated: Bool = true,
                             _ complete: ((Bool) -> Void)? = nil) {
        if let vc = viewControllers.last(where: { $0.isKind(of: ofClass) }) {
            popToViewController(vc, animated: animated)
            complete?(true)
        } else {
            complete?(false)
        }
    }
}

extension UINavigationController {    
    func hideHairline() {
        if let hairline = findHairlineImageViewUnder(navigationBar) {
            hairline.isHidden = true
        }
    }
    func restoreHairline() {
        if let hairline = findHairlineImageViewUnder(navigationBar) {
            hairline.isHidden = false
        }
    }
    func findHairlineImageViewUnder(_ view: UIView) -> UIImageView? {
        if view is UIImageView && view.bounds.size.height <= 1.0 {
            return view as? UIImageView
        }
        for subview in view.subviews {
            if let imageView = self.findHairlineImageViewUnder(subview) {
                return imageView
            }
        }
        return nil
    }
}

