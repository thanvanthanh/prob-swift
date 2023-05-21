//
//  ConfirmTradeFeedViewController.swift
//  Probit
//
//  Created by Nguyen Quang on 25/10/2022.
//  
//

import UIKit

class ConfirmTradeFeedViewController: BaseViewController {
    @IBOutlet weak var backView: UIView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var marketSectionView: UIView!
    @IBOutlet weak var marketLabel: UILabel!
    @IBOutlet weak var marketTitleLabel: UILabel!
    
    @IBOutlet weak var priceSectionView: UIView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var priceTitleLabel: UILabel!
    
    @IBOutlet weak var amountSectionView: UIView!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var amountTitleLabel: UILabel!
    
    @IBOutlet weak var totalSectionView: UIView!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var totalTitleLabel: UILabel!
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var buyButton: UIButton!
    @IBOutlet weak var sellButton: UIButton!
    
    @IBOutlet weak var warningLabel: UILabel!
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupUI() {
        super.setupUI()
        backView.backgroundColor = UIColor.Basic.grayText7.withAlphaComponent(0.5)
        backView.addTapGesture { self.dismiss(animated: true) }
        hiddenAllSection()
    }
    
    override func setupRightToLeft(_ isRTL: Bool) {
        super.setupRightToLeft(isRTL)
        marketLabel.textAlignment = isRTL ? .left : .right
        priceLabel.textAlignment = isRTL ? .left : .right
        amountLabel.textAlignment = isRTL ? .left : .right
        totalLabel.textAlignment = isRTL ? .left : .right
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func buyAction(_ sender: Any) {
        presenter?.buyAction()
        dismiss(animated: true)
    }
    
    @IBAction func sellAction(_ sender: Any) {
        presenter?.sellAction()
        dismiss(animated: true)
    }
    
    override func localizedString() {
        super.localizedString()
        buyButton.setTitle("common_buy".Localizable(), for: .normal)
        sellButton.setTitle("sell_noformat".Localizable(), for: .normal)
        cancelButton.setTitle("dialog_cancel".Localizable(), for: .normal)
        warningLabel.text = "dialog_marketorder_warning_hint".Localizable()

        let tickerColor = AppConstant.tickerColor
        buyButton.backgroundColor = tickerColor.buyColor
        sellButton.backgroundColor = tickerColor.sellColor
        
        guard let side = presenter?.orderSide, side == .BUY else {
            sellButton.isHidden = false
            warningLabel.isHidden = false
            buildContent(orderSide: .SELL)
            return
        }
        buyButton.isHidden = false
        warningLabel.isHidden = true
        buildContent(orderSide: .BUY)
    }
    
    private func buildContent(orderSide: OrderSide) {
        let sideTitle = orderSide == .BUY ? "common_buy".Localizable() : "sell_noformat".Localizable()
        titleLabel.text = String(format: "dialog_order_summary_title".Localizable(), sideTitle.lowercased())
        
        let orderSummaryContent = "dialog_order_summary_content".Localizable()
        let keys: [String] = orderSummaryContent.components(separatedBy: "\n").compactMap {
            $0.components(separatedBy: ":").first == "" ? nil : $0.components(separatedBy: ":").first
        }
        if let key = keys.at(0){
            marketTitleLabel.text = "\(key):"
            marketLabel.text = presenter?.marketId
            marketSectionView.isHidden = false
        } else {
            marketSectionView.isHidden = true
        }
        
        if let orderPrice = presenter?.orderPrice?.doubleValue(),
           let key = keys.at(1) {
            priceTitleLabel.text = "\(key):"
            priceLabel.text = orderPrice.fractionDigits(min: 0, roundingMode: .ceiling)
            priceSectionView.isHidden = false
        } else {
            priceSectionView.isHidden = true
        }
        
        if let orderAmount = presenter?.orderAmount?.doubleValue(),
           let key = keys.at(2) {
            amountTitleLabel.text = "\(key):"
            amountLabel.text = orderAmount.fractionDigits(min: 0)
            amountSectionView.isHidden = false
        } else {
            amountSectionView.isHidden = true
        }
        
        if let key = keys.at(3),
           let totalOrder = presenter?.totalOrder?.doubleValue(){
            totalTitleLabel.text = "\(key):"
            totalLabel.text = totalOrder.fractionDigits(min: 0)
            totalSectionView.isHidden = false
        } else {
            totalSectionView.isHidden = true
        }
    }
    
    func hiddenAllSection() {
        [marketSectionView, priceSectionView, amountSectionView, totalSectionView, sellButton, buyButton].forEach {
            $0?.isHidden = true
        }
    }
    
    // MARK: - Properties
    var presenter: ViewToPresenterConfirmTradeFeedProtocol?
}

extension ConfirmTradeFeedViewController: PresenterToViewConfirmTradeFeedProtocol{
    // TODO: Implement View Output Methods
}
