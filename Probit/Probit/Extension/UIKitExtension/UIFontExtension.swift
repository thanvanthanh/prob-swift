//
//  UIFont.swift

import UIKit

extension UIFont {
    
    enum FontStyles {
        case regular, italic, bold, medium
        var name: String {
            switch self {
            case .regular: return "SFProDisplay-Regular"
            case .italic:  return "SFProDisplay-Italic"
            case .bold:    return "SFProDisplay-Bold"
            case .medium:  return "SFProDisplay-Medium"
            }
        }
    }
    
    static func font(style: FontStyles, size: CGFloat) -> UIFont {
        guard let font = UIFont(name: style.name, size: size) else {
            // If we don't have the font, let's return at least the system's default on the requested size
            return UIFont.systemFont(ofSize: size)
        }
        return font
    }
        
    static func primary(size: CGFloat = 16) -> UIFont {
        font(style: .regular, size: size)
    }
    
    static func important(size: CGFloat = 16) -> UIFont {
        font(style: .bold, size: size)
    }
    
    static func medium(size: CGFloat = 16) -> UIFont {
        font(style: .medium, size: size)
    }
}
