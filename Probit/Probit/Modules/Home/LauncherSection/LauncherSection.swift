//
//  CarouselSection.swift
//  Probit
//
//  Created by Nguyen Quang on 09/09/2022.
//

import UIKit

protocol HomeSectionProtocol: AnyObject {
    func navigateToBuyCrypto()
    func navigateToMore()
    func navigateToEvent(link: String, title: String)
    func navigateToExchange()
    func navigateToExchangeDetail(with market: Market?)
    func navigateToExchangeDetail(exchangeId: String?)
}

class LauncherSection: BaseView {
    @IBOutlet weak var ieoView: HighlightView!
    @IBOutlet weak var ieoLabel: UILabel!
    @IBOutlet weak var moreView: HighlightView!
    @IBOutlet weak var moreLabel: UILabel!
    @IBOutlet weak var buyCryptoView: HighlightView!
    @IBOutlet weak var buycryptoLabel: UILabel!
    @IBOutlet weak var exclusiveView: HighlightView!
    @IBOutlet weak var exclusiveLabel: UILabel!
    weak var delegate: HomeSectionProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init() {
        super.init()
        setupView()
        [ieoView, moreView, buyCryptoView, exclusiveView].forEach {
            $0?.bgColor = .clear
            $0?.highlightType = .homeLauncher
        }
    }
    
    override func localizedString() {
        buycryptoLabel.text = "v2icon_home_buycrypto".Localizable()
        ieoLabel.text = "v2icon_home_ieo".Localizable()
        exclusiveLabel.text = "v2icon_home_exclusive".Localizable()
        moreLabel.text = "v2icon_home_more".Localizable()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        unSelectedItems()
        let tapBuyCrypto = UITapGestureRecognizer(target: self,
                                                  action: #selector(didSelectedBuyCrypto(gesture:)))
        buyCryptoView.addGestureRecognizer(tapBuyCrypto)
        
        let tapExclusive = UITapGestureRecognizer(target: self,
                                                  action: #selector(didSelectedExclusive(gesture:)))
        exclusiveView.addGestureRecognizer(tapExclusive)
        
        let tapIEO = UITapGestureRecognizer(target: self,
                                                  action: #selector(didSelectedIEO(gesture:)))
        ieoView.addGestureRecognizer(tapIEO)
        
        let tapMore = UITapGestureRecognizer(target: self,
                                             action: #selector(didSelectedMore(gesture:)))
        moreView.addGestureRecognizer(tapMore)
    }
    
    @objc func didSelectedBuyCrypto(gesture: UITapGestureRecognizer) {
        delegate?.navigateToBuyCrypto()
    }
    
    @objc func didSelectedExclusive(gesture: UITapGestureRecognizer) {
        delegate?.navigateToEvent(link: AppConstant.Link.exclusive, title: "Exclusive - ProBit Global")
    }
    
    @objc func didSelectedIEO(gesture: UITapGestureRecognizer) {
        delegate?.navigateToEvent(link: AppConstant.Link.ieo, title: "IEO - ProBit Global")
    }
    
    @objc func didSelectedMore(gesture: UITapGestureRecognizer) {
        delegate?.navigateToMore()
    }
    
    private func unSelectedItems() {
        [buyCryptoView, exclusiveView, ieoView, moreView].forEach { view in
            view?.backgroundColor = .clear
        }
    }
}
