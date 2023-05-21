//
//  ScannerOverlayPreviewLayer.swift
//  Probit
//
//  Created by Đào Mỹ Đông on 07/11/2565 BE.
//

import AVFoundation
import UIKit

public enum StylePhoto: Equatable {
    case FACE
    case CARD(cardType: TypeCardId)
    var maskSize: CGSize {
        switch self {
        case .FACE:
            return CGSize(width: 250, height: 330)
        case .CARD:
            return CGSize(width: 340, height: 200)
        }
    }
    
    var imageHeigt: CGFloat {
        let screenWidth = UIScreen.main.bounds.width
        switch self {
        case .FACE:
            return (screenWidth - 64) * maskSize.height / maskSize.width
        case .CARD:
            return (screenWidth - 32) * maskSize.height / maskSize.width
        }
    }
    
    func maskContainer(bounds: CGRect, bottomEdge: CGFloat) ->  CGRect {
        switch self {
        case .FACE:
            return CGRect(x: (bounds.width / 2) - (maskSize.width / 2),
                          y: (bounds.height - bottomEdge - maskSize.height)/2,
                          width: maskSize.width,
                          height: maskSize.height)
        case .CARD:
            return CGRect(x: (bounds.width / 2) - (maskSize.width / 2),
                          y: (bounds.height - bottomEdge - maskSize.height)/2,
                          width: maskSize.width,
                          height: maskSize.height)
        }
    }
    
    var nameSever: String {
        switch self {
        case .FACE:
            return "selfie_image"
        case .CARD(let cardType):
            return cardType.nameSever
        }
    }
    
    var defaultPoisition: AVCaptureDevice.Position {
        switch self {
        case .FACE:
            return .front
        case .CARD:
            return .back
        }
    }
    
#if swift(>=4.1)
   #else
   static func ==(lhs: StylePhoto, rhs: StylePhoto) -> Bool {
       switch (lhs, rhs) {
       case .FACE, .FACE :
           return true
       case .CARD(let lhsCardType), .CARD(let rhsCardType):
           return lhsCardType.rawValue == rhsCardType.rawValue
       default:
           return false
       }
   }
   #endif
}

public class ScannerOverlayPreviewLayer: AVCaptureVideoPreviewLayer {
    
    // MARK: - OverlayScannerPreviewLayer
    
    public var cornerLength: CGFloat = 30
    public var bottomEdge: CGFloat = 0
    public var lineWidth: CGFloat = 2
    public var lineColor: UIColor = .white
    public var lineCap: CAShapeLayerLineCap = .round
    public var stylePhoto: StylePhoto = .FACE
    
    public var maskSize: CGSize {
        return stylePhoto.maskSize
    }
    
    public var rectOfInterest: CGRect {
        metadataOutputRectConverted(fromLayerRect: maskContainer)
    }
    
    public override var frame: CGRect {
        didSet {
            setNeedsDisplay()
        }
    }
    
    public var maskContainer: CGRect {
        return stylePhoto.maskContainer(bounds: bounds, bottomEdge: self.bottomEdge)
    }
    
    // MARK: - Drawing
    
    public override func draw(in ctx: CGContext) {
        super.draw(in: ctx)
        
        // MARK: - Background Mask
        let path = CGMutablePath()
        path.addRect(bounds)
        switch stylePhoto {
        case .FACE:
            path.addRoundedRect(in: maskContainer,
                                cornerWidth: maskSize.width/2,
                                cornerHeight: maskSize.height/2,
                                transform: .identity)
            
            let maskLayer = CAShapeLayer()
            maskLayer.path = path
            maskLayer.fillColor = backgroundColor
            maskLayer.fillRule = .evenOdd
            
            maskLayer.lineWidth = 2.0
            maskLayer.strokeColor = UIColor.white.cgColor
            maskLayer.lineDashPattern = [9,9]
            addSublayer(maskLayer)
        default:
            path.addRoundedRect(in: maskContainer,
                                cornerWidth: cornerRadius,
                                cornerHeight: cornerRadius)
            
            let maskLayer = CAShapeLayer()
            maskLayer.path = path
            maskLayer.fillColor = backgroundColor
            maskLayer.fillRule = .evenOdd
            addSublayer(maskLayer)
            // MARK: - Edged Corners
            if cornerRadius > cornerLength { cornerRadius = cornerLength }
            if cornerLength > maskContainer.width / 2 { cornerLength = maskContainer.width / 2 }
            
            let upperLeftPoint = CGPoint(x: maskContainer.minX, y: maskContainer.minY)
            let upperRightPoint = CGPoint(x: maskContainer.maxX, y: maskContainer.minY)
            let lowerRightPoint = CGPoint(x: maskContainer.maxX, y: maskContainer.maxY)
            let lowerLeftPoint = CGPoint(x: maskContainer.minX, y: maskContainer.maxY)
            
            let upperLeftCorner = UIBezierPath()
            upperLeftCorner.move(to: upperLeftPoint.offsetBy(dx: 0, dy: cornerLength))
            upperLeftCorner.addArc(withCenter: upperLeftPoint.offsetBy(dx: cornerRadius, dy: cornerRadius),
                                   radius: cornerRadius, startAngle: .pi, endAngle: 3 * .pi / 2, clockwise: true)
            upperLeftCorner.addLine(to: upperLeftPoint.offsetBy(dx: cornerLength, dy: 0))
            
            let upperRightCorner = UIBezierPath()
            upperRightCorner.move(to: upperRightPoint.offsetBy(dx: -cornerLength, dy: 0))
            upperRightCorner.addArc(withCenter: upperRightPoint.offsetBy(dx: -cornerRadius, dy: cornerRadius),
                                    radius: cornerRadius, startAngle: 3 * .pi / 2, endAngle: 0, clockwise: true)
            upperRightCorner.addLine(to: upperRightPoint.offsetBy(dx: 0, dy: cornerLength))
            
            let lowerRightCorner = UIBezierPath()
            lowerRightCorner.move(to: lowerRightPoint.offsetBy(dx: 0, dy: -cornerLength))
            lowerRightCorner.addArc(withCenter: lowerRightPoint.offsetBy(dx: -cornerRadius, dy: -cornerRadius),
                                    radius: cornerRadius, startAngle: 0, endAngle: .pi / 2, clockwise: true)
            lowerRightCorner.addLine(to: lowerRightPoint.offsetBy(dx: -cornerLength, dy: 0))
            
            let bottomLeftCorner = UIBezierPath()
            bottomLeftCorner.move(to: lowerLeftPoint.offsetBy(dx: cornerLength, dy: 0))
            bottomLeftCorner.addArc(withCenter: lowerLeftPoint.offsetBy(dx: cornerRadius, dy: -cornerRadius),
                                    radius: cornerRadius, startAngle: .pi / 2, endAngle: .pi, clockwise: true)
            bottomLeftCorner.addLine(to: lowerLeftPoint.offsetBy(dx: 0, dy: -cornerLength))
            
            let combinedPath = CGMutablePath()
            combinedPath.addPath(upperLeftCorner.cgPath)
            combinedPath.addPath(upperRightCorner.cgPath)
            combinedPath.addPath(lowerRightCorner.cgPath)
            combinedPath.addPath(bottomLeftCorner.cgPath)
            
            let shapeLayer = CAShapeLayer()
            shapeLayer.path = combinedPath
            shapeLayer.strokeColor = lineColor.cgColor
            shapeLayer.fillColor = UIColor.clear.cgColor
            shapeLayer.lineWidth = lineWidth
            shapeLayer.lineCap = lineCap
            addSublayer(shapeLayer)
        }
    }
}

internal extension CGPoint {
    
    // MARK: - CGPoint+offsetBy
    
    func offsetBy(dx: CGFloat, dy: CGFloat) -> CGPoint {
        var point = self
        point.x += dx
        point.y += dy
        return point
    }
}
