//
//  UIColorExtension.swift
//  Probit
//
//  Created by Beacon on 10/08/2022.
//

import UIKit

extension UIColor {
    public convenience init(rgb: (r: CGFloat, g: CGFloat, b: CGFloat)) {
        self.init(red: rgb.r/255, green: rgb.g/255, blue: rgb.b/255, alpha: 1.0)
    }
    
    convenience init(hex: Int, alpha: CGFloat = 1) {
        let components = (
            R: CGFloat((hex >> 16) & 0xff) / 255,
            G: CGFloat((hex >> 08) & 0xff) / 255,
            B: CGFloat((hex >> 00) & 0xff) / 255
        )
        self.init(red: components.R, green: components.G, blue: components.B, alpha: alpha)
    }
    
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
    
    func as1ptImage(height: CGFloat = 0.5) -> UIImage {
        UIGraphicsBeginImageContext(CGSize.init(width: 1, height: height))
        guard let ctx = UIGraphicsGetCurrentContext() else { return UIImage() }
        self.setFill()
        ctx.fill(CGRect(x: 0, y: 0, width: 1, height: height))
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else { return UIImage() }
        UIGraphicsEndImageContext()
        return image
    }
    
    func tabBarImage() -> UIImage {
        UIGraphicsBeginImageContext(CGSize.init(width: 1, height: 49))
        guard let ctx = UIGraphicsGetCurrentContext() else { return UIImage() }
        self.setFill()
        ctx.fill(CGRect(x: 0, y: 0, width: 1, height: 49))
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else { return UIImage() }
        UIGraphicsEndImageContext()
        return image
    }
    
    func navBarImage() -> UIImage {
        UIGraphicsBeginImageContext(CGSize.init(width: 1, height: 88))
        guard let ctx = UIGraphicsGetCurrentContext() else { return UIImage() }
        self.setFill()
        ctx.fill(CGRect(x: 0, y: 0, width: 1, height: 88))
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else { return UIImage() }
        UIGraphicsEndImageContext()
        return image
    }
}

extension UIColor {
    func generateThemeColor(name: String) -> UIColor {
        return UIColor.init(named: name) ?? .clear
    }
    //color_30258b_8e83de  color_f2f2f2_424242 color_f5f5f5_282828
    static let color_fafafa_000000_15   = UIColor().generateThemeColor(name: "color_fafafa_000000_15")
    static let color_fafafa_424242      = UIColor().generateThemeColor(name: "color_fafafa_424242")
    static let color_e6e6e6_7b7b7b      = UIColor().generateThemeColor(name: "color_e6e6e6_7b7b7b")
    static let color_424242_c8c8c8      = UIColor().generateThemeColor(name: "color_424242_c8c8c8")
    static let color_d9d6f4_6f6ff7      = UIColor().generateThemeColor(name: "color_d9d6f4_6f6ff7")
    static let color_ececec_2a2a2a      = UIColor().generateThemeColor(name: "color_ececec_2a2a2a")
    static let color_424242_7b7b7b      = UIColor().generateThemeColor(name: "color_424242_7b7b7b")
    static let color_30258b_8e83de      = UIColor().generateThemeColor(name: "color_30258b_8e83de")
    static let color_30258b_3a31ba      = UIColor().generateThemeColor(name: "color_30258b_3a31ba")
    static let color_f2f2f2_424242      = UIColor().generateThemeColor(name: "color_f2f2f2_424242")
    static let color_f5f5f5_282828      = UIColor().generateThemeColor(name: "color_f5f5f5_282828")
    static let color_eceaf9_1c1972      = UIColor().generateThemeColor(name: "color_eceaf9_1c1972")
    static let color_4231c8_6f6ff7      = UIColor().generateThemeColor(name: "color_4231c8_6f6ff7")
    static let color_f5f5f5_2a2a2a      = UIColor().generateThemeColor(name: "color_f5f5f5_2a2a2a")
    static let color_f5f5f5_646464      = UIColor().generateThemeColor(name: "color_f5f5f5_646464")
    static let color_f5f5f5_383838      = UIColor().generateThemeColor(name: "color_f5f5f5_383838")
    static let color_646464_7b7b7b      = UIColor().generateThemeColor(name: "color_646464_7b7b7b")
    static let color_646464_fafafa      = UIColor().generateThemeColor(name: "color_646464_fafafa")
    static let color_fafafa_181818      = UIColor().generateThemeColor(name: "color_fafafa_181818")
    static let color_ffffff_2a2a2a      = UIColor().generateThemeColor(name: "color_ffffff_2a2a2a")
    static let color_ffffff_181818      = UIColor().generateThemeColor(name: "color_ffffff_181818")
    static let color_eaeaea_424242      = UIColor().generateThemeColor(name: "color_eaeaea_424242")
    static let color_7b7b7b_282828      = UIColor().generateThemeColor(name: "color_7b7b7b_282828")
    static let color_7b7b7b_fafafa      = UIColor().generateThemeColor(name: "color_7b7b7b_fafafa")
    static let color_eceaf9_150e4f      = UIColor().generateThemeColor(name: "color_eceaf9_150e4f")
    static let color_eaeaea_282828      = UIColor().generateThemeColor(name: "color_eaeaea_282828")
    static let color_7b7b7b_424242      = UIColor().generateThemeColor(name: "color_7b7b7b_424242")
    static let color_fafafa_7b7b7b      = UIColor().generateThemeColor(name: "color_fafafa_7b7b7b")
    static let color_fafafa_646464      = UIColor().generateThemeColor(name: "color_fafafa_646464")
    static let color_fafafa_6f6ff7      = UIColor().generateThemeColor(name: "color_fafafa_6f6ff7")
    static let color_e6e6e6_646464      = UIColor().generateThemeColor(name: "color_e6e6e6_646464")
    static let color_e6e6e6_424242      = UIColor().generateThemeColor(name: "color_e6e6e6_424242")
    static let color_e6e6e6_2a2a2a      = UIColor().generateThemeColor(name: "color_e6e6e6_2a2a2a")
    static let color_e6e6e6_282828      = UIColor().generateThemeColor(name: "color_e6e6e6_282828")
    static let color_282828_fafafa      = UIColor().generateThemeColor(name: "color_282828_fafafa")
    static let color_282828_7b7b7b      = UIColor().generateThemeColor(name: "color_282828_7b7b7b")
    static let color_282828_b6b6b6      = UIColor().generateThemeColor(name: "color_282828_b6b6b6")
    static let color_d2d2d2_424242      = UIColor().generateThemeColor(name: "color_d2d2d2_424242")
    static let color_282828_06_e6e6e6   = UIColor().generateThemeColor(name: "color_282828_06_e6e6e6")
    static let color_b6b6b6_7b7b7b      = UIColor().generateThemeColor(name: "color_b6b6b6_7b7b7b")
    static let color_b6b6b6_282828      = UIColor().generateThemeColor(name: "color_b6b6b6_282828")
    static let color_b6b6b6_424242      = UIColor().generateThemeColor(name: "color_b6b6b6_424242")
    static let color_b6b6b6_646464      = UIColor().generateThemeColor(name: "color_b6b6b6_646464")
    static let color_b6b6b6_fafafa      = UIColor().generateThemeColor(name: "color_b6b6b6_fafafa")
    static let color_424242_fafafa      = UIColor().generateThemeColor(name: "color_424242_fafafa")
    static let color_424242_6f6ff7      = UIColor().generateThemeColor(name: "color_424242_6f6ff7")
    static let color_c8c8c8_646464      = UIColor().generateThemeColor(name: "color_c8c8c8_646464")
    static let color_c8c8c8_7b7b7b      = UIColor().generateThemeColor(name: "color_c8c8c8_7b7b7b")
    static let color_c8c8c8_b6b6b6      = UIColor().generateThemeColor(name: "color_c8c8c8_b6b6b6")
    static let color_7b7b7b_b6b6b6      = UIColor().generateThemeColor(name: "color_7b7b7b_b6b6b6")
    static let color_7b7b7b_646464      = UIColor().generateThemeColor(name: "color_7b7b7b_646464")
    static let color_d9d9d9_424242      = UIColor().generateThemeColor(name: "color_d9d9d9_424242")
    static let color_d9d9d9_7b7b7b      = UIColor().generateThemeColor(name: "color_d9d9d9_7b7b7b")
    static let color_dadada_7b7b7b      = UIColor().generateThemeColor(name: "color_dadada_7b7b7b")
    static let color_dadada_424242      = UIColor().generateThemeColor(name: "color_dadada_424242")
    static let color_f25d4e             = UIColor.init(hexString: "F25D4E")
    static let color_fafafa             = UIColor.init(hexString: "FAFAFA")
    static let color_7b7b7b             = UIColor.init(hexString: "7B7B7B")
    static let color_12c479             = UIColor.init(hexString: "12C479")
    static let color_green300           = UIColor().generateThemeColor(name: "color_green300")
    static let color_green500           = UIColor().generateThemeColor(name: "color_green500")
    static let color_orange300          = UIColor().generateThemeColor(name: "color_orange300")
    static let color_orange500          = UIColor().generateThemeColor(name: "color_orange500")
    static let color_gray500            = UIColor.init(hexString: "B6B6B6")
    static let color_white_black        = UIColor().generateThemeColor(name: "color_black_white")
    static let color_current_sell       = UIColor().generateThemeColor(name: "color_current_sell")
    static let color_current_buy        = UIColor().generateThemeColor(name: "color_current_buy")
    static let color_total_buy        = UIColor().generateThemeColor(name: "color_total_buy")
    static let color_total_sell        = UIColor().generateThemeColor(name: "color_total_sell")
    static let color_background_view = UIColor().generateThemeColor(name: "color_background_view")
    
    
    enum Basic {
        static let white = UIColor.white
        static let black = UIColor.black
        static let clear = UIColor.clear
        
        /// F25D4E
        static let red = UIColor(hexString: "F25D4E")
        
        /// 12C479
        static let green = UIColor(hexString: "12C479")
        
        /// 4231C8
        static let blue = UIColor(hexString: "4231C8")
        
        /// 282828
        static let mainText = UIColor(hexString: "282828")
        
        /// B6B6B6
        static let grayText = UIColor(hexString: "B6B6B6")
        
        /// 7B7B7B
        static let grayText6 = UIColor(hexString: "7B7B7B")
        
        /// 424242
        static let grayText7 = UIColor.init(named: "color_424242_fafafa") ?? UIColor(hexString: "424242")
        
        /// E5E5E5
        static let background = UIColor(hexString: "E5E5E5")
        
        /// FAFAFA
        static let lightbackground = UIColor(hexString: "FAFAFA")
        
        /// E6E6E6
        static let spacingBottom = UIColor.init(named: "color_e6e6e6_424242") ?? UIColor(hexString: "E6E6E6")
        
        /// F2F2F2
        static let line = UIColor(hexString: "F2F2F2")
        
        /// F25D4E Alpha 0.1
        static let red01 = UIColor(hexString: "F25D4E").withAlphaComponent(0.1)
        
        /// FCE8EA
        static let red02 = UIColor(hexString: "#FCE8EA")
        
        
        /// EC5565
        static let red03 = UIColor(hexString: "#EC5565")
        
        
        /// FAFAFA Alpha 0.3
        static let light30 = UIColor(hexString: "FAFAFA").withAlphaComponent(0.3)
        
        /// FAFAFA
        static let lightGray = UIColor(hexString: "FAFAFA")
    }
    
    static let dimmedLightBackground = UIColor(white: 100.0/255.0, alpha: 0.3)
    static let dimmedDarkBackground = UIColor(white: 50.0/255.0, alpha: 0.3)
    static let dimmedDarkestBackground = UIColor(white: 0, alpha: 0.5)
    static let musicBackgroundDark = UIColor(red: 36, green: 39, blue: 42, alpha: 1)
}

extension UIColor {
    func toHexString() -> String{
        let components = self.cgColor.components
        let r: CGFloat = components?[0] ?? 0.0
        let g: CGFloat = components?[1] ?? 0.0
        let b: CGFloat = components?[2] ?? 0.0
        
        let hexString = String.init(format: "#%02lX%02lX%02lX", lroundf(Float(r * 255)), lroundf(Float(g * 255)), lroundf(Float(b * 255)))
        return hexString
    }
}

extension UIColor {
    var light: UIColor {
        let lightAppearance = UITraitCollection(userInterfaceStyle: .light)
        return self.resolvedColor(with: lightAppearance)
    }

    var dark: UIColor {
        let darkAppearance = UITraitCollection(userInterfaceStyle: .dark)
        return self.resolvedColor(with: darkAppearance)
    }
}
