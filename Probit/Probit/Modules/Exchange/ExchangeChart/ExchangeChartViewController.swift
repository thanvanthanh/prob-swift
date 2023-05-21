//
//  ExchangeChartViewController.swift
//  Probit
//
//  Created by Nguyen Quang on 13/10/2022.
//  
//

import UIKit
import WebKit

class ExchangeChartViewController: BaseViewController {
    @IBOutlet weak var resetButton: HighlightButon!
    @IBOutlet weak var showFullScreenButton: HighlightButon!
    @IBOutlet weak var intervalTimeView: UIView!
    @IBOutlet weak var intervalTimeContentChart: IntervalTimeChart!
    @IBOutlet weak var intervalTimeLabel: UILabel!
    @IBOutlet weak var imageDropDown: UIImageView!
    private var isShowInterval: Bool = true
    @IBOutlet weak var tradingView: TradingWebView!
    private var intervalSelectedItem: IntervalTime = .minute30

    // MARK: - Properties
    var presenter: ViewToPresenterExchangeChartProtocol?
    var onDidUpdateInterval: ((String) -> Void)?

    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func update(_ price: String?) {
        self.tradingView.update(price)
    }
    
    func reload() {
        self.tradingView.reload()
    }
    
    public func getIntervalTime() -> IntervalTime {
        return intervalSelectedItem
    }
    
    override func setupUI() {
        super.setupUI()
        let zoomIcon = UIImage(named: "ico_zoom_full_screen")?.withRenderingMode(.alwaysOriginal)
        showFullScreenButton.setImage(zoomIcon, for: .normal)
        
        checkStateIntervalView()
        intervalTimeContentChart.delegate = self
        intervalTimeLabel.text = intervalSelectedItem.rawValue
        intervalTimeView.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                                     action: #selector(displayIntervalView)))
        tradingView
            .setTnterval(intervalSelectedItem)
            .setMarketId(presenter?.interactor?.exchangId ?? "")
            .setPrice(presenter?.interactor?.exchange?.quoteRate.doubleValue()?.fractionDigits(min: 2, max: presenter?.interactor?.exchange?.quoteRate.digitNumber ?? 8))
        
        resetButton.applyResetButtonStyle()
        resetButton.titleLabel?.font = UIFont.font(style: .regular, size: 12)

        showFullScreenButton.bgColor = .clear
        showFullScreenButton.highlightType = .onlyIcon
    }
    
    override func localizedString() {
        super.localizedString()
        resetButton.setTitle("fragment_marketdetailschart_reset".Localizable(), for: .normal)
    }
    
    private func checkStateIntervalView() {
        isShowInterval = !isShowInterval
        intervalTimeContentChart.isHidden = !isShowInterval
        imageDropDown.image = isShowInterval ? UIImage(named: "ico_up") : UIImage(named: "ico_down")
    }
    
    @objc func displayIntervalView() {
        checkStateIntervalView()
    }
    
    @IBAction func resetAction(_ sender: Any) {
        self.intervalSelectedItem = .minute30
        intervalTimeLabel.text = intervalSelectedItem.rawValue
        intervalTimeContentChart.setupStackView()
        self.onDidUpdateInterval?(intervalSelectedItem.filterValue)
        self.tradingView.update(intervalSelectedItem)
        self.tradingView.reset()
    }
    
    @IBAction func showFullScreenAction(_ sender: Any) {
        guard let exchange = presenter?.interactor?.exchange else { return }
        TradingZoomViewRouter(exchange: exchange).showScreen()
    }
}

extension ExchangeChartViewController: PresenterToViewExchangeChartProtocol{
    // TODO: Implement View Output Methods
}

extension ExchangeChartViewController: IntervalTimeChartDelegate {
    func getData() -> [[IntervalTimeModel]] {
        let data: [[IntervalTimeModel]] = [
            [IntervalTimeModel(model: .minute1),
             IntervalTimeModel(model: .minute3),
             IntervalTimeModel(model: .minute5),
             IntervalTimeModel(model: .minute10),
             IntervalTimeModel(model: .minute15),
             IntervalTimeModel(model: .minute30)],
            
            [IntervalTimeModel(model: .hours1),
             IntervalTimeModel(model: .hours4),
             IntervalTimeModel(model: .hours6),
             IntervalTimeModel(model: .hours12)],
            
            [IntervalTimeModel(model: .day1),
             IntervalTimeModel(model: .week1),
             IntervalTimeModel(model: .month1)]
        ]
        return data
    }
    
    var itemSelected: IntervalTime {
        return intervalSelectedItem
    }
    
    func selectedItem(item: IntervalTimeModel) {
        intervalTimeLabel.text = item.model.rawValue
        checkStateIntervalView()
        intervalSelectedItem = item.model
        self.onDidUpdateInterval?(item.model.filterValue)
        self.tradingView.update(intervalSelectedItem)
    }
}

extension HighlightButon {
    func applyResetButtonStyle() {
        self.strokeColor = .clear
        self.bgColor = .color_ececec_2a2a2a
        self.textColor = .color_424242_7b7b7b
        self.borderWidth = 1
        self.cornerRadius = 2
        self.highlightType = .outlineButton2
    }
}
