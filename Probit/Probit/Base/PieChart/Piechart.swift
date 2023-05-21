//
//  File.swift
//  Probit
//
//  Created by Đào Mỹ Đông on 27/09/2565 BE.
//


import UIKit
/**
 * Piechart
 */
open class Piechart: UIControl {
    
    /**
     * Slice
     */
    public struct Slice {
        public var color: UIColor!
        public var value: Double!
        public var text: String!
    }
    
    /**
     * Radius
     */
    public struct Radius {
        public var inner: Double = 49
        public var outer: Double = 55
    }
    
    /**
      * private
      */
    
    /**
     * public
     */
    open var radius: Radius = Radius()
    open var total: Double!
    open var slices: [Slice] = []
    
    let viewTitle = UIView()
    let stackView = UIStackView()

    
    /**
     * methods
     */
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
    }
    
    convenience init() {
        self.init(frame: CGRect.zero)
        self.slices = slices
        viewTitle.backgroundColor = .clear
        viewTitle.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        viewTitle.addSubview(stackView)
        self.addSubview(viewTitle)
    }
    
    open override func draw(_ rect: CGRect) {
        super.draw(rect)
        let center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        
        let backGround = UIBezierPath()
        backGround.move(to: center)
        backGround.addArc(withCenter: center,
                    radius: radius.outer,
                    startAngle: -CGFloat(Double.pi / 2),
                    endAngle: (CGFloat(Double.pi) + CGFloat(Double.pi / 2)),
                    clockwise: true)
        let edgeColor = UIColor(hexString: "#d9d9d9")
        edgeColor.setFill()
        backGround.fill()

        var startValue: CGFloat = 0
        var endAngle: CGFloat = 0
        var totalSlices: CGFloat = 0
        for (_, slice) in slices.enumerated() {
            let startAngle = (startValue * 2 * CGFloat(Double.pi)) - CGFloat(Double.pi / 2)
            let endValue = startValue + (slice.value / self.total)
            totalSlices += slice.value
            endAngle = (endValue * 2 * CGFloat(Double.pi)) - CGFloat(Double.pi / 2)
            let path = UIBezierPath()
            path.move(to: center)
            path.addArc(withCenter: center,
                        radius: radius.outer,
                        startAngle: startAngle,
                        endAngle: endAngle,
                        clockwise: true)
            slice.color.setFill()
            path.fill()
            startValue += slice.value / self.total
        }
        // create center donut hole
        let innerPath = UIBezierPath()
        innerPath.move(to: center)
        innerPath.addArc(withCenter: center,
                         radius: radius.inner,
                         startAngle: 0,
                         endAngle: CGFloat(Double.pi) * 2, clockwise: true)
        let defaultColor = UIColor.color_fafafa_181818
        defaultColor.setFill()
        innerPath.fill()
    }
    
    func settupChartView(slices: [Slice]) {
        self.slices = slices
        stackView.removeFullyAllArrangedSubviews()
        for (_, slice) in slices.enumerated() {
            let titleLabel = LegendItemView()
            titleLabel.setupView(color: slice.color, title: slice.text)
            stackView.addArrangedSubview(titleLabel)
        }
        NSLayoutConstraint.activate([
            viewTitle.heightAnchor.constraint(equalToConstant: self.radius.inner),
            viewTitle.widthAnchor.constraint(equalToConstant:  self.radius.inner),
            viewTitle.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0),
            viewTitle.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0),
        ])
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: viewTitle.topAnchor, constant: 0),
            stackView.leadingAnchor.constraint(equalTo: viewTitle.leadingAnchor, constant: 6),
            stackView.trailingAnchor.constraint(equalTo: viewTitle.trailingAnchor, constant: 0),
            stackView.bottomAnchor.constraint(equalTo: viewTitle.bottomAnchor, constant: 0)
        ])
        self.setNeedsDisplay()
    }
}
