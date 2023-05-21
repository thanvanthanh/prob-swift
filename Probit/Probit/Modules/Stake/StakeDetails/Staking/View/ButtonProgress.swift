//
//  ButtonProgress.swift
//  Probit
//
//  Created by Đào Mỹ Đông on 30/09/2565 BE.
//

import UIKit

class ButtonProgress: BaseView {
    
    @IBOutlet weak var backGroundView: UIView!
    @IBOutlet weak var viewLabel: UIView!
    @IBOutlet weak var whiteView: UIView!
    @IBOutlet weak var titleLabel: UILabel!

    override func awakeFromNib() {
       super.awakeFromNib()

       //custom logic goes here
    }
    
    open var slice: Slice?
    let radius:CGFloat = 100

    public struct Slice {
        public var color: UIColor!
        public var value: Double!
    }
    
    override func setupUI() {
        self.backgroundColor = .clear
        self.setBackgroundColor(color: .clear)
    }
    
    func setupView(slice: Slice, viewLabelColor: UIColor) {
        self.backGroundView.cornerRadius = self.frame.height / 2
        self.viewLabel.cornerRadius = (self.frame.height - 2) / 2
        self.whiteView.cornerRadius = (self.frame.height - 2) / 2
        self.whiteView.backgroundColor = .color_fafafa_181818
        self.viewLabel.backgroundColor = viewLabelColor
        self.titleLabel.textColor = slice.color
        self.titleLabel.text = "\(slice.value.fractionDigits(min: 0, max: 2))%"
        let endAngle = ((slice.value / 100) * 2 * CGFloat(Double.pi)) - CGFloat(Double.pi / 2)
        let path = UIBezierPath()
        // center of the view
        let center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)

        path.move(to: center)
        path.addArc(withCenter: center,
                    radius: 100,
                    startAngle: -CGFloat(Double.pi / 2),
                    endAngle: endAngle,
                    clockwise: true)
        slice.color.setFill()
        path.fill()
        let layer = CAShapeLayer()
        layer.path = path.cgPath
        layer.fillColor = slice.color.cgColor
        self.backGroundView.layer.addSublayer(layer)
    }
}
