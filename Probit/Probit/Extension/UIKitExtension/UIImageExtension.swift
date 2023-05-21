//
//  UIImage.swift
//  Probit
//
//  Created by Nguyen Quang on 12/09/2022.
//

import UIKit

enum ImageResizingMethod {
    case crop
    case cropStart
    case cropEnd
    case scale
}

extension UIImage {
    
    convenience init?(color: UIColor,
                      size: CGSize = CGSize(width: 1.0, height: 1.0),
                      cornerRadius: CGFloat = 0.0,
                      borderWidth: CGFloat = 0.0,
                      borderColor: UIColor = UIColor.clear) {
        let rect = CGRect(origin: .zero, size: size).insetBy(dx: borderWidth / 2.0, dy: borderWidth / 2.0)
        
        UIGraphicsBeginImageContextWithOptions(size, false, 1.0)
        let bezierPath = UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius)
        bezierPath.lineWidth = borderWidth
        
        color.setFill()
        bezierPath.fill()
        
        borderColor.setStroke()
        bezierPath.stroke()
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
    
    var tint: UIImage {
        return self.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
    }
    
    func tranlucent(alpha: CGFloat) -> UIImage? {
        if alpha == 1.0 {
            return self
        }
        
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        self.draw(at: CGPoint.zero, blendMode: CGBlendMode.normal, alpha: alpha)
        let resultImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return resultImage
    }
    
    func alFixOrientation() -> UIImage {
        if self.imageOrientation == .up {
            return self
        }
        
        var transform = CGAffineTransform.identity
        switch self.imageOrientation {
        case .down, .downMirrored:           // EXIF = 3, 4
            transform = transform.translatedBy(x: size.width, y: size.height)
            transform = transform.rotated(by: CGFloat(Double.pi))
            
        case .left, .leftMirrored:           // EXIF = 6, 5
            transform = transform.translatedBy(x: size.width, y: 0)
            transform = transform.rotated(by: CGFloat(Double.pi / 2))
            
        case .right, .rightMirrored:          // EXIF = 8, 7
            transform = transform.translatedBy(x: 0, y: size.height)
            transform = transform.rotated(by: -CGFloat((Double.pi / 2)))
        default:
            ()
        }
        
        switch self.imageOrientation {
        case .upMirrored, .downMirrored:     // EXIF = 2, 4
            transform = transform.translatedBy(x: size.width, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
            
        case .leftMirrored, .rightMirrored:   // EXIF = 5, 7
            transform = transform.translatedBy(x: size.height, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        default:
            ()
        }
        
        guard let context = CGContext(data: nil,
                                      width: Int(size.width),
                                      height: Int(size.height),
                                      bitsPerComponent: cgImage!.bitsPerComponent,
                                      bytesPerRow: 0,
                                      space: cgImage!.colorSpace!,
                                      bitmapInfo: cgImage!.bitmapInfo.rawValue)
        else {
            return self
        }
        
        context.concatenate(transform)
        switch imageOrientation {
        case .left, .leftMirrored, .right, .rightMirrored:
            context.draw(cgImage!, in: CGRect(x: 0, y: 0, width: size.height, height: size.width))
        default:
            context.draw(cgImage!, in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        }
        
        if let newImageRef = context.makeImage() {
            let newImage = UIImage(cgImage: newImageRef)
            return newImage
        }
        
        return self
    }
    
    @nonobjc
    func fitSize(fitSize: CGSize, resizeMethod: ImageResizingMethod) -> UIImage? {
        let imageScaleFactor: CGFloat = self.scale
        
        let sourceWidth: CGFloat = self.size.width * imageScaleFactor
        let sourceHeight: CGFloat = self.size.height * imageScaleFactor
        
        let targetWidth: CGFloat = fitSize.width
        let targetHeight: CGFloat = fitSize.height
        
        let cropping = resizeMethod != ImageResizingMethod.scale
        
        let sourceRatio: CGFloat = sourceWidth / sourceHeight
        let targetRatio: CGFloat = targetWidth / targetHeight
        
        var scaleWidth = (sourceRatio <= targetRatio)
        scaleWidth = (cropping) ? scaleWidth : !scaleWidth
        
        var scalingFactor: CGFloat = 0.0
        var scaledWidth: CGFloat = 0.0
        var scaledHeight: CGFloat = 0.0
        
        if scaleWidth {
            scalingFactor = 1.0 / sourceRatio
            scaledWidth = targetWidth
            scaledHeight = round(targetWidth * scalingFactor)
        } else {
            scalingFactor = sourceRatio
            scaledWidth = round(targetHeight * scalingFactor)
            scaledHeight = targetHeight
        }
        
        let scaleFactor: CGFloat = scaledHeight / sourceHeight
        
        var sourceRect = CGRect.zero
        var destRect = CGRect.zero
        
        if cropping {
            destRect = CGRect(x: 0.0, y: 0.0, width: targetWidth, height: targetHeight)
            var destX: CGFloat = 0.0
            var destY: CGFloat = 0.0
            
            if resizeMethod == ImageResizingMethod.crop {
                destX = round((scaledWidth - targetWidth) / 2.0)
                destY = round((scaledHeight - targetHeight) / 2.0)
            } else if resizeMethod == ImageResizingMethod.cropStart {
                if scaleWidth {
                    destX = 0.0
                    destY = 0.0
                } else {
                    destX = 0.0
                    destY = round((scaledHeight - targetHeight) / 2.0)
                }
            } else {
                if scaleWidth {
                    destX = round((scaledWidth - targetWidth) / 2.0)
                    destY = round(scaledHeight - targetHeight)
                } else {
                    destX = round(scaledWidth - targetWidth)
                    destY = round((scaledHeight - targetHeight) / 2.0)
                }
            }
            
            sourceRect = CGRect(x: destX / scaleFactor, y: destY / scaleFactor, width: targetWidth / scaleFactor, height: targetHeight / scaleFactor)
        } else {
            sourceRect = CGRect(x: 0.0, y: 0.0, width: sourceWidth, height: sourceHeight)
            destRect = CGRect(x: 0.0, y: 0.0, width: scaledWidth, height: scaledHeight)
        }
        
        if let cgImage = self.cgImage?.cropping(to: sourceRect) {
            var resultImage: UIImage?
            
            UIGraphicsBeginImageContextWithOptions(destRect.size, false, 0.0)
            let image: UIImage = UIImage(cgImage: cgImage, scale: 0.0, orientation: self.imageOrientation)
            image.draw(in: destRect)
            resultImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            return resultImage
        } else {
            return nil
        }
    }
    
    func croppedToFitSize(fitSize: CGSize) -> UIImage? {
        return self.fitSize(fitSize: fitSize, resizeMethod: .crop)
    }
    
    func scaledToFitSize(fitSize: CGSize) -> UIImage? {
        return self.fitSize(fitSize: fitSize, resizeMethod: .scale)
    }
    
    func colored(with color: UIColor) -> UIImage? {
        return self.colored(with: color, size: self.size)
    }
    
    func colored(with color: UIColor, size: CGSize) -> UIImage? {
        var result: UIImage? = self
        let image = self.tint
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        
        color.set()
        image.draw(in: CGRect(origin: CGPoint.zero, size: size))
        
        if let image = UIGraphicsGetImageFromCurrentImageContext() {
            result = image
        }
        
        UIGraphicsEndImageContext()
        
        return result
    }
    
    func imageByLanguage() -> UIImage {
        if AppConstant.isLanguageRightToLeft {
            return self.withHorizontallyFlippedOrientation()
        } else {
            return self
        }
    }
    
}

extension UIImageView {
    func detectImageByLanguge() {
        if AppConstant.isLanguageRightToLeft {
            self.image = self.image?.imageByLanguage()
        }
    }
}

extension UIImage {
    
    func resized(withPercentage percentage: CGFloat, isOpaque: Bool = true) -> UIImage? {
        let canvas = CGSize(width: size.width * percentage, height: size.height * percentage)
        let format = imageRendererFormat
        format.opaque = isOpaque
        return UIGraphicsImageRenderer(size: canvas, format: format).image {_ in
            draw(in: CGRect(origin: .zero, size: canvas))
        }
    }
    
    func compress(to kb: Int, allowedMargin: CGFloat = 0.2) -> Data {
        if let imgData = self.jpegData(compressionQuality: 1.0), imgData.count / 1_024 <= kb {
            return imgData
        }
        
        let bytes = kb * 1_024
        var compression: CGFloat = 1.0
        let step: CGFloat = 0.05
        var holderImage = self
        var complete = false
        while !complete {
            if let data = holderImage.jpegData(compressionQuality: 1.0) {
                let ratio = data.count / bytes
                if data.count < Int(CGFloat(bytes) * (1 + allowedMargin)) {
                    complete = true
                    return data
                } else {
                    let multiplier: CGFloat = CGFloat((ratio / 5) + 1)
                    compression -= (step * multiplier)
                }
            }
            
            guard let newImage = holderImage.resized(withPercentage: compression) else { break }
            holderImage = newImage
        }
        return Data()
    }
}
