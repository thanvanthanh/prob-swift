//
//  FloatingView.swift
//  Probit
//
//  Created by Thân Văn Thanh on 07/10/2022.
//

import Foundation
import SwiftEntryKit

enum FloatingType {
    case defaults
    case success
    case error
}

class FloatingView {
    
    class func show(title: String,
                    desc: String,
                    type: FloatingType,
                    insets: UIEdgeInsets) {
        switch type {
        case .defaults:
            showNotificationMessage(attributes: setupFloatPresets(bgColor: .musicBackground),
                                    title: title,
                                    desc: desc,
                                    textColor: .black,
                                    insets: insets)
        case .success:
            showNotificationMessage(attributes: setupFloatPresets(bgColor: .succesColorBG),
                                    title: title,
                                    desc: desc,
                                    textColor: .successColorTitle,
                                    insets: insets)
        case .error:
            showNotificationMessage(attributes: setupFloatPresets(bgColor: .errorColorBG),
                                    title: title,
                                    desc: desc,
                                    textColor: .errorColorTitle,
                                    insets: insets)
        }
    }
    
    private class func showNotificationMessage(attributes: EKAttributes,
                                               title: String,
                                               desc: String,
                                               textColor: EKColor,
                                               imageName: String? = nil,
                                               insets: UIEdgeInsets) {
        let title = EKProperty.LabelContent(
            text: title,
            style: .init(font: UIFont.medium(size: 16),
                         color: textColor,
                         alignment: .center,
                         displayMode: .inferred
            ),
            accessibilityIdentifier: "title"
        )
        let description = EKProperty.LabelContent(
            text: desc,
            style: .init(font: UIFont.medium(size: 16),
                         color: textColor,
                         alignment: .center,
                         displayMode: .inferred
            ),
            accessibilityIdentifier: "description"
        )
        var image: EKProperty.ImageContent?
        if let imageName = imageName {
            image = EKProperty.ImageContent(
                image: UIImage(named: imageName)!.withRenderingMode(.alwaysTemplate),
                displayMode: .inferred,
                size: CGSize(width: 35, height: 35),
                tint: textColor,
                accessibilityIdentifier: "thumbnail"
            )
        }
        let simpleMessage = EKSimpleMessage(
            image: image,
            title: title,
            description: description
        )
        var messageInsets = EKNotificationMessage.Insets.default
        messageInsets.contentInsets = insets
        let notificationMessage = EKNotificationMessage(simpleMessage: simpleMessage, insets: messageInsets)
        let contentView = EKNotificationMessageView(with: notificationMessage)
        SwiftEntryKit.display(entry: contentView, using: attributes)
    }
    
    private class func setupFloatPresets(bgColor: EKColor) -> EKAttributes {
        var attributes = EKAttributes()
        
        attributes = .topFloat
        attributes.roundCorners = .all(radius: UIScreen.main.minEdge/2)
        attributes.displayMode = .inferred
        attributes.hapticFeedbackType = .success
        attributes.entryBackground = .color(color: bgColor)
        
        let topViewController = UIApplication.shared.getTopViewController()
        let topBarHeight = (topViewController?.navigationController?.navigationBar.frame.height ?? 44)
        attributes.positionConstraints.verticalOffset = topBarHeight
        
        attributes.popBehavior = .animated(
            animation: .init(
                translate: .init(duration: 0.3),
                scale: .init(from: 1, to: 0.7, duration: 0.7)
            )
        )
        
        attributes.statusBar = .inferred
        attributes.scroll = .enabled(
            swipeable: true,
            pullbackAnimation: .easeOut
        )
        attributes.positionConstraints.maxSize = .init(
            width: .constant(value: UIScreen.main.minEdge),
            height: .intrinsic
        )
        return attributes
    }
    
}

extension UIScreen {
    var minEdge: CGFloat {
        return UIScreen.main.bounds.minEdge
    }
}

extension CGRect {
    var minEdge: CGFloat {
        return min(width, height)
    }
}

extension EKColor {
    
    static var dimmedLightBackground: EKColor {
        return EKColor(light: .dimmedLightBackground,
                       dark: .dimmedDarkestBackground)
    }
    
    static var musicBackground: EKColor {
        return EKColor(light: .white,
                       dark: .musicBackgroundDark)
    }
    
    static var blue: EKColor {
        return EKColor(light: UIColor.Basic.blue,
                       dark: UIColor.Basic.blue)
    }
    
    static var red02: EKColor {
        return EKColor(light: UIColor.Basic.red02,
                       dark: UIColor.Basic.red02)
    }
    
    static var red03: EKColor {
        return EKColor(light: UIColor.Basic.red03,
                       dark: UIColor.Basic.red03)
    }
    
    static var succesColorBG: EKColor {
        return EKColor(light: UIColor(hexString: "#E3FFF4"),
                       dark: UIColor(hexString: "#164C35"))
    }
    
    static var successColorTitle: EKColor {
        return EKColor(light: UIColor(hexString: "#12C479"),
                       dark: UIColor(hexString: "#12C479"))
    }
    
    static var errorColorBG: EKColor {
        return EKColor(light: UIColor(hexString: "#FCE8EA"),
                       dark: UIColor(hexString: "#592D28"))
    }
    
    static var errorColorTitle: EKColor {
        return EKColor(light: UIColor(hexString: "#EC5565"),
                       dark: UIColor(hexString: "#F25D4E"))
    }
    
}
