//
//  HeaderTermsAndPolicies.swift
//  Probit
//
//  Created by Thân Văn Thanh on 31/08/2022.
//

import UIKit

protocol HeaderTermsAndPoliciesDelegate: AnyObject {
    func longTapHeader(model: TermsAndPolicies?)
}

class HeaderTermsAndPolicies: BaseView {
    
    @IBOutlet weak var actionView: HighlightView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var iconsImage: BaseUIImageView!
//    @IBOutlet weak var headerButton: UIButton!
    @IBOutlet private weak var lineView: UIView!
    
    weak var delegate: HeaderTermsAndPoliciesDelegate?
    
    var model: TermsAndPolicies? {
        didSet {
            if let model = model {
                titleLabel.text = model.title.title
                iconsImage.isHidden = model.title != .thirdParty
                lineView.isHidden = !(model.title != .thirdParty)
            }
        }
    }
    
    override func setupUI() {
        super.setupUI()
//        let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(longTap))
//        headerButton.addGestureRecognizer(longGesture)
        actionView.applyMoreStyle()
        actionView.delegate = self
        setupRightToLeft(AppConstant.isLanguageRightToLeft)
    }
    
//    @objc func longTap(_ sender: UIGestureRecognizer){
//        if model?.title == .persional || model?.title == .notification {
//           return
//        }
//        if sender.state == .ended {
//            titleLabel.textColor = UIColor.color_282828_fafafa
//            self.backgroundColor = UIColor.color_fafafa_181818
//            delegate?.longTapHeader(model: model)
//        }
//        else if sender.state == .began {
//            titleLabel.textColor = UIColor.color_4231c8_6f6ff7
//            self.backgroundColor = UIColor.color_e6e6e6_282828
//        }
//    }
    
    func setupRightToLeft(_ isRTL: Bool) {
        [titleLabel].forEach { $0?.textAlignment = isRTL ? .right : .left }
    }
    
}

extension HeaderTermsAndPolicies: HighlightViewProtocol {
    func highlight(view: HighlightView) {
        titleLabel.textColor = UIColor.color_4231c8_6f6ff7
        self.backgroundColor = UIColor.color_e6e6e6_282828
    }
    
    func unHighlight(view: HighlightView) {
        titleLabel.textColor = UIColor.color_282828_fafafa
        self.backgroundColor = UIColor.color_fafafa_181818
//        delegate?.longTapHeader(model: model)
    }
}
