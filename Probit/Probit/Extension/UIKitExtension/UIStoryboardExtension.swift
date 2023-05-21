//
//  UIStoryboardExtension.swift
//  Probit
//
//  Created by Beacon on 16/08/2022.
//

import UIKit

extension UIStoryboard {
    static let Splash = UIStoryboard(name: "Main", bundle: nil)
}

extension UIStoryboard {
    func instantiateViewController<T: UIViewController>(viewControllerType: T.Type) -> T {
        guard let viewController =
                instantiateViewController(withIdentifier: String(describing: viewControllerType)) as? T else {
            fatalError("Could not instantiateViewController with identifier: \(viewControllerType)")
        }
        
        return viewController
    }
}
