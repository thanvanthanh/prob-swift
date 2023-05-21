//
//  TradingZoomViewViewController.swift
//  Probit
//
//  Created by Đào Mỹ Đông on 10/01/2566 BE.
//  
//

import UIKit
import WebKit

enum TimeChartType: String {
    case hour
    case minute
    case none
}

class TradingZoomViewViewController: BaseViewController, CanRotate {
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var percentLabel: UILabel!
    @IBOutlet private weak var valueLabel: UILabel!
    
    @IBOutlet private weak var reset: HighlightButon!
    @IBOutlet private weak var zoomOutButton: HighlightButon!
    @IBOutlet private weak var timeLabel: UILabel!
    @IBOutlet private weak var webView: TradingWebView!
    
    @IBOutlet weak var heightOfContentTIme: NSLayoutConstraint!
    @IBOutlet weak var leftContentTime: NSLayoutConstraint!
    @IBOutlet weak var intervalTimeContentChart: IntervalTimeChart!
    private var timeChartType : TimeChartType = .none {
        didSet {
            doShowContentChart()
        }
    }

    
    @IBOutlet private weak var intevalMinuteArrow: UIImageView!
    @IBOutlet private weak var intevalMinuteLable: UILabel!
    @IBOutlet private weak var intevalMinuteView: HighlightView!
    
    @IBOutlet private weak var intevalHourArrow: UIImageView!
    @IBOutlet private weak var intevalHourLable: UILabel!
    @IBOutlet private weak var intevalHourView: HighlightView!
    
    @IBOutlet private weak var intevelOneDayTitle: UILabel!
    @IBOutlet private weak var intevelOneDayView: HighlightView!
    
    @IBOutlet private weak var intevelOneWeekTitle: UILabel!
    @IBOutlet private weak var intevelOneWeekView: HighlightView!
    
    @IBOutlet private weak var intevelOneMonthTitle: UILabel!
    @IBOutlet private weak var intevelOneMonthView: HighlightView!
    
    private var intervalSelectedItem: IntervalTime = .minute30 {
        didSet {
            resetColor()
            timeChartType = .none
            switch intervalSelectedItem {
            case .minute1, .minute3, .minute5, .minute10, .minute15, .minute30:
                intevalMinuteLable.textColor = .color_4231c8_6f6ff7
                intevalMinuteLable.text = intervalSelectedItem.rawValue
                intevalHourLable.text = IntervalTime.hours1.rawValue
            case .hours1, .hours4, .hours6, .hours12:
                intevalHourLable.text = intervalSelectedItem.rawValue
                intevalHourLable.textColor = .color_4231c8_6f6ff7
                intevalMinuteLable.text = IntervalTime.minute30.rawValue
            case .day1:
                intevelOneDayTitle.textColor = .color_4231c8_6f6ff7
                intevalHourLable.text = IntervalTime.hours1.rawValue
                intevalMinuteLable.text = IntervalTime.minute30.rawValue
            case .week1:
                intevelOneWeekTitle.textColor = .color_4231c8_6f6ff7
                intevalHourLable.text = IntervalTime.hours1.rawValue
                intevalMinuteLable.text = IntervalTime.minute30.rawValue
            case .month1:
                intevelOneMonthTitle.textColor = .color_4231c8_6f6ff7
                intevalHourLable.text = IntervalTime.hours1.rawValue
                intevalMinuteLable.text = IntervalTime.minute30.rawValue
            }
        }
    }
    
    var timer: Timer?
    var count = PurchaseConstants.countdownTime


    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIDevice.current.setValue(UIInterfaceOrientation.landscapeRight.rawValue, forKey: "orientation")
        startTimer()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
        stopTimer()
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscape
    }
    
    // MARK: - Setup UI
    override func setupUI() {
        super.setupUI()
        hideNavigationBar(isHide: true)
        guard let exchange = presenter?.interactor?.exchange,
                let marketId = exchange.id else { return }
        let title = marketId.replacingOccurrences(of: "-", with: "/")
        titleLabel.text = title
        valueLabel.text = exchange.quoteRate.doubleValue()?.fractionDigits(min: 2, roundingMode: .floor)
        build24ChangeLabel(change: exchange.change24Hr())
        
        webView
            .setTnterval(intervalSelectedItem)
            .setMarketId(presenter?.interactor?.exchange.id ?? "")
            .setPrice(presenter?.interactor?.exchange.quoteRate.doubleValue()?.fractionDigits(min: 2, roundingMode: .floor))
        
        intervalTimeContentChart.delegate = self

        reset.applyResetButtonStyle()
        reset.titleLabel?.font = UIFont.font(style: .regular, size: 12)

        zoomOutButton.bgColor = .clear
        zoomOutButton.highlightType = .onlyIcon
        
        [intevalMinuteView, intevalHourView,
         intevelOneDayView, intevelOneWeekView, intevelOneMonthView].forEach {
            $0?.bgColor = .color_ececec_2a2a2a
            $0?.borderWidth = 1
            $0?.cornerRadius = 2
            $0?.strokeColor = .clear
            $0?.highlightType = .outlineButton2
        }
        
        intevalMinuteView.addTapGesture { [weak self] in
            guard let self = self else { return }
            self.timeChartType = .minute
        }
        
        intevalHourView.addTapGesture { [weak self] in
            guard let self = self else { return }
            self.timeChartType = .hour
        }
        
        intevelOneDayView.addTapGesture { [weak self] in
            guard let self = self else { return }
            self.intervalSelectedItem = .day1
        }
        
        intevelOneWeekView.addTapGesture { [weak self] in
            guard let self = self else { return }
            self.intervalSelectedItem = .week1
        }
        
        intevelOneMonthView.addTapGesture { [weak self] in
            guard let self = self else { return }
            self.intervalSelectedItem = .month1
        }
    }
    
    override func localizedString() {
        reset.setTitle("fragment_marketdetailschart_reset".Localizable(), for: .normal)
        intevalHourLable.text = IntervalTime.hours1.rawValue
        intevalMinuteLable.text = IntervalTime.minute30.rawValue
        intevelOneDayTitle.text = IntervalTime.day1.rawValue
        intevelOneWeekTitle.text = IntervalTime.week1.rawValue
        intevelOneMonthTitle.text = IntervalTime.month1.rawValue
    }
    
    func startTimer() {
        stopTimer()
        timer = Timer.scheduledTimer(timeInterval: 1,
                                     target: self,
                                     selector: #selector(updateCountDownTime),
                                     userInfo: nil,
                                     repeats: true)
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    @objc func updateCountDownTime() {
        timeLabel.text = Date().stringFromDateWithSemantic()
    }
    
    // MARK: - Properties
    var presenter: ViewToPresenterTradingZoomViewProtocol?
    
    @IBAction func doZoomOut(_ sender: Any) {
        hideNavigationBar(isHide: false)
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func doReset(_ sender: Any) {
        self.intervalSelectedItem = .minute30
        webView.reset()        
    }
    
    func resetColor() {
        [intevelOneDayTitle, intevelOneWeekTitle,
         intevelOneMonthTitle, intevalHourLable,
         intevalMinuteLable].forEach { label in
            label?.textColor = .color_282828_fafafa
        }
    }
    
    func doShowContentChart() {
        intervalTimeContentChart.setupStackView()
        switch timeChartType {
        case .minute:
            leftContentTime.constant = 8.0
            heightOfContentTIme.constant = 60.0
            intervalTimeContentChart.isHidden = false
        case .hour:
            leftContentTime.constant = 106.0
            heightOfContentTIme.constant = 30.0
            intervalTimeContentChart.isHidden = false
        case .none:
            intervalTimeContentChart.isHidden = true
        }
    }
    
    private func build24ChangeLabel(change: Double?) {
        var changeValue: String = "-"
        var color: UIColor = .color_282828_fafafa
        
        if let change = change {
            let fractionDigitsValue = change.fractionDigits(min: 2, max: 2, roundingMode: .ceiling)
            let changeValueLtr = change <= 0.0 ? "\(fractionDigitsValue)%" : "+\(fractionDigitsValue)%"
            let changeValueRtl = change <= 0.0 ? "%\(fractionDigitsValue)%" : "+%\(fractionDigitsValue)"
            changeValue = AppConstant.isLanguageRightToLeft ? changeValueRtl : changeValueLtr
            color = change == 0.0 ? .color_282828_fafafa : (change < 0.0 ? UIColor.Basic.red : UIColor.Basic.green)
        }
        percentLabel.textColor = color
        percentLabel.text = changeValue
    }
}

extension TradingZoomViewViewController: PresenterToViewTradingZoomViewProtocol{
    // TODO: Implement View Output Methods
}

extension TradingZoomViewViewController: IntervalTimeChartDelegate {
    func getData() -> [[IntervalTimeModel]] {
        if timeChartType == .minute {
            return [
                [IntervalTimeModel(model: .minute1),
                 IntervalTimeModel(model: .minute3),
                 IntervalTimeModel(model: .minute5),
                 IntervalTimeModel(model: .minute10),
                 IntervalTimeModel(model: .minute15),
                 IntervalTimeModel(model: .minute30)]]
        }
        
        return [
            [IntervalTimeModel(model: .hours1),
             IntervalTimeModel(model: .hours4),
             IntervalTimeModel(model: .hours6),
             IntervalTimeModel(model: .hours12)]
        ]
    }
    
    var itemSelected: IntervalTime {
        return intervalSelectedItem
    }
    
    func selectedItem(item: IntervalTimeModel) {
        intervalSelectedItem = item.model
        self.webView.update(intervalSelectedItem)
    }
}
