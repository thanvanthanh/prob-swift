//
//  ObjectExtension.swift
//  Probit
//
//  Created by Beacon on 10/08/2022.
//

import Foundation
import UIKit

extension NSObject {
    var className: String {
        return String(describing: type(of: self))
    }
    
    class var className: String {
        return String(describing: self)
    }
    
    var isDarkMode: Bool {
        return UITraitCollection.current.userInterfaceStyle == .dark
    }
    
    func json() -> String? {
        guard let data = try? JSONSerialization.data(withJSONObject: self, options: []) else {
            return nil
        }
        return String(data: data, encoding: String.Encoding.utf8)
    }
}
