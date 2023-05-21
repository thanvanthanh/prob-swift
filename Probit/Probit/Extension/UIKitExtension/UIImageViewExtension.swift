
import UIKit

enum CurrencyIconType: Codable {
    case fiat
    case payment
    case provider
    case crypto
    
    var url: String {
        switch self {
        case .fiat:
            return "https://static.probit.com/common/logo_image/fiat/%@.svg"
        case .payment:
            return "https://static.probit.com/common/logo_image/buy_crypto_payment_method/%@.svg"
        case .crypto:
            return "https://static.probit.com/files/coin_logo/%@.png"
        case .provider:
            return "https://static.probit.com/common/logo_image/buy_crypto_provider/%@.svg"
        }
    }
}

extension UIImageView {
    func load(url: URL) {
        self.activityIndicator.startAnimating()
        self.sd_setImage(with: url) {[weak self]_,_,_,_ in
            self?.activityIndicator.stopAnimating()
        }
    }
    
    func setImage(_ url: String) {
        self.sd_setImage(with: URL(string: url)) {_,_,_,_ in
            
        }
    }
    
    func loadCurrencyImage(_ data: CurrencyType) {
        if let id = data.id {
            let iconType = data.iconType
            switch iconType {
            case .crypto:
                let strURL = String(format: iconType.url, id)
                sd_setImage(with: URL(string: strURL),
                            placeholderImage: UIImage(named: "ico_currency_default"))
            case .provider:
                let strURL = String(format: iconType.url, id)
                self.sd_setImage(with: URL(string: strURL),
                                 placeholderImage: UIImage(named: "ico_currency_default"))
            case .fiat:
                let strURL = String(format: iconType.url, id)
                self.sd_setImage(with: URL(string: strURL),
                                 placeholderImage: UIImage(named: "ico_currency_default"))
            case .payment:
                let strURL = String(format: iconType.url, id)
                self.sd_setImage(with: URL(string: strURL),
                                 placeholderImage: UIImage(named: "ico_currency_default"))
            }
        }
    }
    
    fileprivate var activityIndicator: UIActivityIndicatorView {
    get {

        if let indicator = self.subviews.first(where: { $0 is UIActivityIndicatorView }) as? UIActivityIndicatorView {
            return indicator
        }
        let activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
        activityIndicator.hidesWhenStopped = true
        self.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false

        let centerX = NSLayoutConstraint(item: self,
                                         attribute: .centerX,
                                         relatedBy: .equal,
                                         toItem: activityIndicator,
                                         attribute: .centerX,
                                         multiplier: 1,
                                         constant: 0)

        let centerY = NSLayoutConstraint(item: self,
                                         attribute: .centerY,
                                         relatedBy: .equal,
                                         toItem: activityIndicator,
                                         attribute: .centerY,
                                         multiplier: 1,
                                         constant: 0)

        self.addConstraints([centerX, centerY])
        return activityIndicator
      }
    }
}

extension UIImageView {
    
    func setTintImageView(imageName: String, colorTint: UIColor) {
        let tintImage = UIImage(named: imageName)?.withRenderingMode(.alwaysTemplate)
        self.image = tintImage
        self.tintColor = colorTint
    }
}

extension UIImage {
    func rotate(radians: CGFloat) -> UIImage {
        let rotatedSize = CGRect(origin: .zero, size: size)
            .applying(CGAffineTransform(rotationAngle: CGFloat(radians)))
            .integral.size
        UIGraphicsBeginImageContext(rotatedSize)
        if let context = UIGraphicsGetCurrentContext() {
            let origin = CGPoint(x: rotatedSize.width / 2.0,
                                 y: rotatedSize.height / 2.0)
            context.translateBy(x: origin.x, y: origin.y)
            context.rotate(by: radians)
            draw(in: CGRect(x: -origin.y, y: -origin.x,
                            width: size.width, height: size.height))
            let rotatedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()

            return rotatedImage ?? self
        }

        return self
    }
}
