//
//  HighlightView.swift
//  Probit
//
//  Created by Nguyen Quang on 10/01/2023.
//

import UIKit

protocol HighlightViewProtocol: AnyObject {
    func highlight(view: HighlightView)
    func unHighlight(view: HighlightView)
}

class HighlightView: UIView {
    var bgColor: UIColor = .color_eceaf9_150e4f
    var strokeColor: UIColor = .color_eceaf9_150e4f
    weak var delegate: HighlightViewProtocol?
    private var isApplyHover: Bool = true
    
    var highlightType: HighlightType = .homeLauncher {
        didSet {
            configView()
        }
    }
    
    func setStateApplyHover(_ state: Bool) {
        self.isApplyHover = state
    }
    
    private func configView() {
        unHighlight()
    }
    
    func highlight() {
        self.backgroundColor = self.highlightType.backgroundColor
        self.borderColor = self.highlightType.borderColor
        self.delegate?.highlight(view: self)
    }
    
    func unHighlight() {
        self.backgroundColor = self.bgColor
        self.borderColor = self.strokeColor
        self.delegate?.unHighlight(view: self)
    }
    
    func disabled() {

    }
    
    override func touchesBegan(_ touches: Set<UITouch>,
                               with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        guard isApplyHover else { return }
        DispatchQueue.main.async { [weak self] in
            guard let `self` = self else { return }
            self.highlight()
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>,
                               with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        guard isApplyHover else { return }
        DispatchQueue.main.async { [weak self] in
            guard let `self` = self else { return }
            self.unHighlight()
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>,
                                   with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        guard isApplyHover else { return }
        DispatchQueue.main.async { [weak self] in
            guard let `self` = self else { return }
            self.unHighlight()
        }
    }
}

extension HighlightView {
    func applyNornalStyle() {
        self.bgColor = .color_f5f5f5_2a2a2a
        self.highlightType = .normal
    }
    
    func applyOutlineButtonStyle1() {
        self.bgColor = .color_fafafa_181818
        self.strokeColor = .color_4231c8_6f6ff7
        self.highlightType = .outlineButton1
    }
    
    func applyOutlineButtonStyle2() {
        self.bgColor = .color_fafafa_181818
        self.strokeColor = .color_b6b6b6_7b7b7b
        self.highlightType = .outlineButton2
    }
}


// MARK: TODO @IBInspectable Không nhận giá trị enum? nên phải khai báo type = int
enum HighlightType: Int {
    case homeLauncher = 1 // fafafa → e6e6e6
    case homeTicker = 2 // "fafafa → e6e6e6"
    case homeNewCoin = 3 // "fafafa → e6e6e6"
    case behaviorExchange
    case onlyIcon
    
    case normal
    case outlineButton1
    case outlineButton2
    case buy
    case sell
    case ghostButton
    case solidButton
    case lightButton

    var backgroundColor: UIColor {
        switch self {
        case .normal: return .color_e6e6e6_282828
        case .homeLauncher: return .color_e6e6e6_282828
        case .homeTicker: return .color_e6e6e6_646464
        case .homeNewCoin: return .color_e6e6e6_282828
            
        case .outlineButton1: return .color_eceaf9_150e4f
        case .onlyIcon: return .clear
        case .outlineButton2: return .color_eaeaea_282828
        case .behaviorExchange: return .color_eaeaea_282828
        case .buy: return AppConstant.tickerColor.highlightBuyColor
        case .sell: return AppConstant.tickerColor.highlightSellColor
        case .ghostButton: return .color_f2f2f2_424242
        case .solidButton: return .color_30258b_3a31ba
        case .lightButton: return .color_4231c8_6f6ff7
        }
    }
    
    var textColor: UIColor {
        switch self {
        case .normal: return .color_e6e6e6_282828
        case .homeLauncher: return .color_e6e6e6_282828
        case .homeTicker: return .color_e6e6e6_646464
        case .homeNewCoin: return .color_e6e6e6_282828
            
        case .onlyIcon: return .clear
        case .outlineButton1: return .color_4231c8_6f6ff7
        case .outlineButton2: return .color_7b7b7b
        case .behaviorExchange: return .color_7b7b7b
        case .buy: return .white
        case .sell: return .white
        case .ghostButton: return .color_b6b6b6_646464
        case .solidButton: return .color_d9d6f4_6f6ff7
        case .lightButton: return .color_fafafa
        }
    }
    
    var colorImage: UIColor {
        switch self {
        case .normal: return .color_e6e6e6_282828
        case .homeLauncher: return .color_e6e6e6_282828
        case .homeTicker: return .color_e6e6e6_646464
        case .homeNewCoin: return .color_e6e6e6_282828
        case .ghostButton: return .color_f2f2f2_424242
            
        case .onlyIcon: return .color_30258b_8e83de
        case .outlineButton1: return .color_30258b_8e83de
        case .outlineButton2: return .color_282828_b6b6b6
        case .lightButton: return .color_fafafa
        case .buy, .sell, .solidButton, .behaviorExchange: return .clear
        }
    }
    
    var borderColor: UIColor {
        switch self {
        case .normal: return .color_e6e6e6_282828
        case .homeLauncher: return .color_e6e6e6_282828
        case .homeTicker: return .color_e6e6e6_646464
        case .homeNewCoin: return .color_e6e6e6_282828
//
        case .outlineButton1: return .color_4231c8_6f6ff7
        case .outlineButton2: return .color_7b7b7b_424242
        case .ghostButton: return .color_f2f2f2_424242
        case .buy, .sell, .solidButton,
                .lightButton, .onlyIcon, .behaviorExchange: return .clear
        }
    }
}
