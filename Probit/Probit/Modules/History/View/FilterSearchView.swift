//
//  FilterSearchView.swift
//  Probit
//
//  Created by Đào Mỹ Đông on 12/10/2565 BE.
//

import Foundation
import UIKit

protocol FilterSearchViewDelegate {
    var filterModel: SearchFilterModel { get set }
    func doSearch()
    func updateFilterTime(startTime: Date, endTime: Date)
}
class FilterSearchView: BaseView {
    @IBOutlet weak var tradingLabel: UILabel!
    
    @IBOutlet weak var baseCoinLabel: UILabel!
    @IBOutlet weak var quoteCoinLabel: UILabel!
    @IBOutlet weak var baseCoinImage: UIImageView!
    @IBOutlet weak var quoteCoinImage: UIImageView!
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var dateValue: UILabel!
    var delegate: FilterSearchViewDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setupUI() {
        dateLabel.text = "filter_date".Localizable()
        tradingLabel.text = "filter_tradingpair".Localizable()
    }
    
    func updateView() {
        guard let filterModel = delegate?.filterModel else { return }
        let startDate = filterModel.startTime.stringFromDate(format: "yyyy/MM/dd")
        let endDate = filterModel.endTime.stringFromDate(format: "yyyy/MM/dd")
        dateValue.text = AppConstant.isLanguageRightToLeft ? "\(endDate)~\(startDate)" : "\(startDate)~\(endDate)"
        let fromCoinsLabel = filterModel.baseCurrency?.id ?? "filter_allcoins".Localizable()
        let toCoinsLabel = filterModel.quoteCurrency?.id ?? "filter_allcoins".Localizable()
        baseCoinLabel.text = fromCoinsLabel
        quoteCoinLabel.text = toCoinsLabel
        if let baseCurrency = filterModel.baseCurrency {
            LoadImageUrl.shared.cryptoCurrencyImage(with: baseCurrency.id, in: baseCoinImage)
            baseCoinImage.isHidden = false
        } else {
            baseCoinImage.isHidden = true
        }
        
        if let quoteCurrency = filterModel.quoteCurrency {
            LoadImageUrl.shared.cryptoCurrencyImage(with: quoteCurrency.id, in: quoteCoinImage)
            quoteCoinImage.isHidden = false
        } else {
            quoteCoinImage.isHidden = true
        }
    }
    
    @IBAction func navigateToFillterVC(_ sender: Any) {
        guard let delegate = self.delegate else { return }
        FillterHistoryRouter(delegate: delegate).showScreen()
    }
    
}
