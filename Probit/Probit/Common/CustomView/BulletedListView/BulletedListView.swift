//
//  BulletedListView.swift
//  Probit
//
//  Created by Nguyen Quang on 13/10/2022.
//

import UIKit

class BulletedListView: BaseView {
    
    @IBOutlet weak var containerDotView: UIView!
    @IBOutlet weak var dotView: UIView!
    
    @IBOutlet weak var containerImageView: UIView!
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var contentLabel: UILabel!
    
    init(content: String,
         font: UIFont? = nil,
         color: UIColor? = UIColor.color_7b7b7b_fafafa ) {
        super.init(frame: .zero)
        containerImageView.isHidden = true
        contentLabel.text = content
        contentLabel.textColor = color
        if let font = font {
            contentLabel.font = font
        }
    }
    
    init(html: String) {
        super.init(frame: .zero)
        iconImage.isHidden = true
        containerDotView.isHidden = false
        
        contentLabel.set(html: html,
                         family: UIFont.FontStyles.medium.name,
                         size: 14, color: "#282828")
        dotView.backgroundColor = UIColor(hexString: "282828")
    }
    
    init(caution: String,
         hiddenDot: Bool = false,
         font: UIFont? = .font(style: .regular, size: 14.0),
         color: UIColor? = UIColor.color_7b7b7b_b6b6b6 ) {
        super.init(frame: .zero)
        containerImageView.isHidden = true
        containerDotView.isHidden = hiddenDot

        contentLabel.text = caution
        contentLabel.font = font
        contentLabel.textColor = color
        dotView.backgroundColor = .color_7b7b7b_b6b6b6
        contentLabel.textAlignment = AppConstant.isLanguageRightToLeft ? .right : .left
    }
    
    init(photoDescripstion: String, icon: UIImage? = nil) {
        super.init(frame: .zero)
        if let icon = icon {
            containerImageView.isHidden = false
            iconImage.image = icon
            containerDotView.isHidden = true
        } else {
            containerImageView.isHidden = true
            containerDotView.isHidden = false
        }
        contentLabel.text = photoDescripstion
        
        contentLabel.font = .font(style: .regular, size: 14.0)
        contentLabel.textColor = .color_fafafa
        dotView.backgroundColor = .color_fafafa
    }
    
    init(attributedText: NSAttributedString) {
        super.init(frame: .zero)
        contentLabel.attributedText = attributedText
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        
    }
}
