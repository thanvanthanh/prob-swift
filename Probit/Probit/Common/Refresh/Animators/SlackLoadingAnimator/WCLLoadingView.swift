
import UIKit

class WCLLoadingView: UIView, CAAnimationDelegate {
    var lineWidth:CGFloat = 0
    var lineLength:CGFloat = 0
    var margin:CGFloat = 0
    var duration:Double = 2
    var interval:Double = 1
    var colors:[UIColor] = [UIColor(rgb: (157, 212, 233)) , UIColor(rgb: (245, 189, 88)),  UIColor(rgb: (255, 49, 126)) , UIColor(rgb: (111, 201, 181))]
    private(set) var status:AnimationStatus = .normal
    private var lines:[CAShapeLayer] = []
    
    enum AnimationStatus {
        case normal
        case animating
        case pause
    }
    
    //MARK: Public Methods
    func startAnimation() {
        angleAnimation()
        lineAnimationOne()
        lineAnimationTwo()
        lineAnimationThree()
    }

    func pauseAnimation() {
        layer.pauseAnimation()
        for lineLayer in lines {
            lineLayer.pauseAnimation()
        }
        status = .pause
    }

    func resumeAnimation() {
        layer.resumeAnimation()
        for lineLayer in lines {
            lineLayer.resumeAnimation()
        }
        status = .animating
    }

    func stopAnimation() {
        layer.removeAllAnimations()
        for lineLayer in lines {
            lineLayer.removeAllAnimations()
        }
        status = .normal
    }
    
    //MARK: Initial Methods
    convenience init(frame: CGRect , colors: [UIColor]) {
        self.init()
        self.frame = frame
        self.colors = colors
        config()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        config()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        config()
    }
    
    //MARK: Animation Delegate
    func animationDidStart(_ anim: CAAnimation) {
        if let animation = anim as? CABasicAnimation {
            if animation.keyPath == "transform.rotation.z" {
                status = .animating
            }
        }
    }

    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if let animation = anim as? CABasicAnimation {
            if animation.keyPath == "strokeEnd" {
                if flag {
                    status = .normal
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(interval) * Int64(NSEC_PER_SEC)) / Double(NSEC_PER_SEC), execute: {
                        if self.status != .animating {
                            self.startAnimation()
                        }
                    })
                }
            }
        }
    }
    
    //MARK: Privater Methods
    private func drawLineShapeLayer() {
        let startPoint = [point(lineWidth/2, y: margin),
                          point(lineLength - margin, y: lineWidth/2),
                          point(lineLength - lineWidth/2, y: lineLength - margin),
                          point(margin, y: lineLength - lineWidth/2)]
        
        let endPoint   = [point(lineLength - lineWidth/2, y: margin) ,
                         point(lineLength - margin, y: lineLength - lineWidth/2) ,
                         point(lineWidth/2, y: lineLength - margin) ,
                         point(margin, y: lineWidth/2)]
        for i in 0...3 {
            let line:CAShapeLayer = CAShapeLayer()
            line.lineWidth   = lineWidth
            line.lineCap     = CAShapeLayerLineCap.round
            line.opacity     = 0.8
            line.strokeColor = colors[i].cgColor
            line.path        = getLinePath(startPoint[i], endPoint: endPoint[i]).cgPath
            layer.addSublayer(line)
            lines.append(line)
        }
        
    }

    private func getLinePath(_ startPoint: CGPoint, endPoint: CGPoint) -> UIBezierPath {
        let path = UIBezierPath()
        path.move(to: startPoint)
        path.addLine(to: endPoint)
        return path
    }
    
    private func angleAnimation() {
        let angleAnimation                 = CABasicAnimation.init(keyPath: "transform.rotation.z")
        angleAnimation.beginTime           = CACurrentMediaTime()
        angleAnimation.fromValue           = angle(-30)
        angleAnimation.toValue             = angle(690)
        angleAnimation.fillMode            = CAMediaTimingFillMode.forwards
        angleAnimation.isRemovedOnCompletion = false
        angleAnimation.duration            = duration
        angleAnimation.delegate            = self
        layer.add(angleAnimation, forKey: "angleAnimation")
    }

    private func lineAnimationOne() {
        let lineAnimationOne                 = CABasicAnimation.init(keyPath: "strokeEnd")
        lineAnimationOne.beginTime           = CACurrentMediaTime()
        lineAnimationOne.duration            = duration/2
        lineAnimationOne.fillMode            = CAMediaTimingFillMode.forwards
        lineAnimationOne.isRemovedOnCompletion = false
        lineAnimationOne.fromValue           = 1
        lineAnimationOne.toValue             = 0
        for i in 0...3 {
            let lineLayer = lines[i]
            lineLayer.add(lineAnimationOne, forKey: "lineAnimationOne")
        }
    }
    
    private func lineAnimationTwo() {
        for i in 0...3 {
            var keypath = "transform.translation.x"
            if i%2 == 1 {
                keypath = "transform.translation.y"
            }
            let lineAnimationTwo                   = CABasicAnimation.init(keyPath: keypath)
            lineAnimationTwo.beginTime             = CACurrentMediaTime() + duration/2
            lineAnimationTwo.duration              = duration/4
            lineAnimationTwo.fillMode              = CAMediaTimingFillMode.forwards
            lineAnimationTwo.isRemovedOnCompletion = false
            lineAnimationTwo.autoreverses          = true
            lineAnimationTwo.fromValue             = 0
            if i < 2 {
                lineAnimationTwo.toValue = lineLength/4
            }else {
                lineAnimationTwo.toValue = -lineLength/4
            }
            let lineLayer = lines[i]
            lineLayer.add(lineAnimationTwo, forKey: "lineAnimationTwo")
        }
        
        let scale = (lineLength - 2*margin)/(lineLength - lineWidth)
        for i in 0...3 {
            var keypath = "transform.translation.y"
            if i%2 == 1 {
                keypath = "transform.translation.x"
            }
            let lineAnimationTwo                   = CABasicAnimation.init(keyPath: keypath)
            lineAnimationTwo.beginTime             = CACurrentMediaTime() + duration/2
            lineAnimationTwo.duration              = duration/4
            lineAnimationTwo.fillMode              = CAMediaTimingFillMode.forwards
            lineAnimationTwo.isRemovedOnCompletion = false
            lineAnimationTwo.autoreverses          = true
            lineAnimationTwo.fromValue             = 0
            if i == 0 || i == 3 {
                lineAnimationTwo.toValue = lineLength/4 * scale
            }else {
                lineAnimationTwo.toValue = -lineLength/4 * scale
            }
            let lineLayer = lines[i]
            lineLayer.add(lineAnimationTwo, forKey: "lineAnimationThree")
        }
    }

    private func lineAnimationThree() {
        let lineAnimationFour                   = CABasicAnimation.init(keyPath: "strokeEnd")
        lineAnimationFour.beginTime             = CACurrentMediaTime() + duration
        lineAnimationFour.duration              = duration/4
        lineAnimationFour.fillMode              = CAMediaTimingFillMode.forwards
        lineAnimationFour.isRemovedOnCompletion = false
        lineAnimationFour.fromValue             = 0
        lineAnimationFour.toValue               = 1
        for i in 0...3 {
            if i == 3 {
                lineAnimationFour.delegate = self
            }
            let lineLayer = lines[i]
            lineLayer.add(lineAnimationFour, forKey: "lineAnimationFour")
        }
    }
    
    //MARK: Private Methods
    private func point(_ x:CGFloat , y:CGFloat) -> CGPoint {
        return CGPoint(x: x, y: y)
    }
    
    private func angle(_ angle: Double) -> CGFloat {
        return CGFloat(angle *  (Double.pi/180))
    }
    
    private func config() {
        layoutIfNeeded()
        lineLength = max(frame.width, frame.height)
        lineWidth  = lineLength/6.0
        margin     = lineLength/4.5 + lineWidth/2
        drawLineShapeLayer()
        transform = CGAffineTransform.identity.rotated(by: angle(-30))
    }
}

extension CALayer {
    func pauseAnimation() {
        let pauseTime = convertTime(CACurrentMediaTime(), from: nil)
        timeOffset    = pauseTime
        speed         = 0
    }
    
    func resumeAnimation() {
        let pausedTime = timeOffset
        speed          = 1
        timeOffset     = 0
        beginTime      = 0
        let sincePause = convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        beginTime      = sincePause
    }
}
