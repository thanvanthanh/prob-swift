//
//  BaseTableViewCell.swift
//  Probit
//
//  Created by Beacon on 10/08/2022.
//

import UIKit

class BaseTableViewCell: UITableViewCell {
    var bgColor: UIColor = .color_fafafa_181818
    var highlightType: HighlightType = .normal
    private var isApplyHover: Bool = true
    
    override func awakeFromNib() {
        super.awakeFromNib()
        localizable()
        setupRightToLeft(AppConstant.isLanguageRightToLeft)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupCell(object: Any) {

    }
    
    func setHighlightType(_ state: HighlightType) {
        self.highlightType = state
    }
    
    func setStateApplyHover(_ state: Bool) {
        self.isApplyHover = state
    }

    func setupCell(object: Any, indexPath: IndexPath? = nil) {
        
    }
    
    func localizable() {
        
    }
    
    func setupRightToLeft(_ isRTL: Bool) {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>,
                               with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        guard isApplyHover else { return }
        DispatchQueue.main.async { [weak self] in
            guard let `self` = self else { return }
            self.backgroundColor = self.bgColor
            UIView.animate(withDuration: 0.2,
                           delay: 0.0,
                           options: .curveLinear,
                           animations: {
                self.backgroundColor = self.highlightType.backgroundColor
            }, completion: nil)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>,
                               with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        guard isApplyHover else { return }
        DispatchQueue.main.async { [weak self] in
            guard let `self` = self else { return }
            self.backgroundColor = self.highlightType.backgroundColor
            UIView.animate(withDuration: 0.2,
                           delay: 0.0,
                           options: .curveLinear,
                           animations: {
                self.backgroundColor = self.bgColor
            }, completion: nil)
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>,
                                   with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        guard isApplyHover else { return }
        DispatchQueue.main.async { [weak self] in
            guard let `self` = self else { return }
            self.backgroundColor = self.highlightType.backgroundColor
            UIView.animate(withDuration: 0.2,
                           delay: 0.0,
                           options: .curveLinear,
                           animations: {
                self.backgroundColor = self.bgColor
            }, completion: nil)
        }
    }
}
