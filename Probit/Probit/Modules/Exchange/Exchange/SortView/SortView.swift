//
//  SortView.swift
//  Probit
//
//  Created by Nguyen Quang on 26/08/2022.
//

import UIKit

class SortView: BaseView {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var mainStackView: UIStackView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var iconUp: UIImageView!
    @IBOutlet weak var iconDown: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.cornerRadius = 3
        backgroundColor = .color_ececec_2a2a2a
        resetView()
        iconUp.image = UIImage(named: "ico_exchange_up")?.withRenderingMode(.alwaysTemplate)
        iconDown.image = UIImage(named: "ico_exchange_down")?.withRenderingMode(.alwaysTemplate)
    }
    
    func setTitle(_ title: String)  {
        nameLabel.text = title
    }

    func resetView() {
        iconUp.tintColor = UIColor.init(hexString: "B6B6B6")
        iconDown.tintColor = UIColor.init(hexString: "B6B6B6")
    }
    
    func sortUp() {
        iconUp.tintColor = UIColor.init(hexString: "424242")
        iconDown.tintColor = UIColor.init(hexString: "B6B6B6")
    }
    
    func sortDown() {
        iconUp.tintColor = UIColor.init(hexString: "B6B6B6")
        iconDown.tintColor = UIColor.init(hexString: "424242")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>,
                               with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        DispatchQueue.main.async { [weak self] in
            guard let `self` = self else { return }
            self.containerView.backgroundColor = .color_ececec_2a2a2a
            self.nameLabel.textColor = .color_424242_7b7b7b
            UIView.animate(withDuration: 0.2,
                           delay: 0.0,
                           options: .curveLinear,
                           animations: {
                self.nameLabel.textColor = HighlightType.outlineButton1.textColor
                self.containerView.backgroundColor = HighlightType.outlineButton1.backgroundColor
            }, completion: nil)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>,
                               with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        DispatchQueue.main.async { [weak self] in
            guard let `self` = self else { return }
            self.containerView.backgroundColor = HighlightType.outlineButton1.backgroundColor
            self.nameLabel.textColor = HighlightType.outlineButton1.textColor
            UIView.animate(withDuration: 0.2,
                           delay: 0.0,
                           options: .curveLinear,
                           animations: {
                self.containerView.backgroundColor = .color_ececec_2a2a2a
                self.nameLabel.textColor = .color_424242_7b7b7b
            }, completion: nil)
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>,
                                   with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        DispatchQueue.main.async { [weak self] in
            guard let `self` = self else { return }
            self.containerView.backgroundColor = HighlightType.outlineButton1.backgroundColor
            self.nameLabel.textColor = HighlightType.outlineButton1.textColor
            UIView.animate(withDuration: 0.2,
                           delay: 0.0,
                           options: .curveLinear,
                           animations: {
                self.containerView.backgroundColor = .color_ececec_2a2a2a
                self.nameLabel.textColor = .color_424242_7b7b7b
            }, completion: nil)
        }
    }
}
