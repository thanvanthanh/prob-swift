//
//  TradingWebView.swift
//  Probit
//
//  Created by Dang Nguyen on 04/01/2023.
//

import UIKit
import WebKit

class TradingWebView: BaseView, WKNavigationDelegate {
    var webView: WKWebView?
    
    var candleData = [String: Any]()
    var key         = ""
    var startDate   = ""
    var endDate     = ""
    
    private var marketId = ""
    private var interval: IntervalTime = .minute30
    var count: Int = 3
    var price: String?
    var filterValue: String {
        return interval.filterValue
    }
    
    private var isInitChart: Bool = false
    private var isUpdatePrice: Bool = false
    
    var webConfig: WKWebViewConfiguration {
        get {
            let webConfiguration = WKWebViewConfiguration()
            webConfiguration.preferences.setValue(true, forKey: "allowFileAccessFromFileURLs")
            let userController: WKUserContentController = WKUserContentController()
            userController.add(self, name: "ios")
            webConfiguration.userContentController = userController;
            return webConfiguration;
        }
    }
    
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        updateTheme()
    }
    
    
    
    override func awakeFromNib() {
        setupWebView()
    }
    
    func reload() {
        guard let tradingWebView = webView else { return }
        tradingWebView.reload()
    }
    
    func reset() {
        let js = "resetChart()"
        webView?.evaluateJavaScript(js, completionHandler: { _, error in
            print(error?.localizedDescription ?? "")
        })
        let js2 = "updateInterval('30')"
        webView?.evaluateJavaScript(js2, completionHandler: { _, error in
            print(error?.localizedDescription ?? "")
        })
    }
    
    private func setupWebView() {
        let url = Bundle.main.url(forResource: "index", withExtension: "html")
        webView = WKWebView(frame: self.bounds, configuration: webConfig)
        webView?.navigationDelegate = self
        webView?.translatesAutoresizingMaskIntoConstraints = false
        webView?.isOpaque = false
        webView?.scrollView.bounces = false
        webView?.scrollView.backgroundColor = .clear
        webView?.backgroundColor = UIColor.color_ffffff_181818

        guard let indexUrl = url, let tradingWebView = webView else { return }
        tradingWebView.loadFileURL(indexUrl, allowingReadAccessTo: indexUrl)
        self.addSubview(tradingWebView)
        tradingWebView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        tradingWebView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        tradingWebView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        tradingWebView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        tradingWebView.evaluateJavaScript("navigator.userAgent", completionHandler: { (result, error) in
            debugPrint(result as Any)
            if let unwrappedUserAgent = result as? String {
                tradingWebView.customUserAgent = "\(unwrappedUserAgent) ProBitiOS/51"
            } else {
                print("failed to get the user agent")
            }
        })
        
        
    }
    
    func transferCandleDataToTradingView(key: String, data: [String: Any]) {
        guard let jsonData = try? JSONSerialization.data(withJSONObject: data, options: []) else {
            return
        }
        let dataPassToWebView = String(data: jsonData, encoding: String.Encoding.utf8) ?? ""
        let js = "onDataReceived('\(key)', '\(dataPassToWebView)')"
        webView?.evaluateJavaScript(js, completionHandler: { _, error in
            print(error?.localizedDescription ?? "")
        })
    }
    
    @discardableResult
    func setTnterval(_ interval: IntervalTime) -> TradingWebView{
        self.interval = interval
        return self
    }
    
    @discardableResult
    func setMarketId(_ marketId: String) -> TradingWebView{
        self.marketId = marketId
        return self
    }
    
    @discardableResult
    func setPrice(_ price: String?) -> TradingWebView{
        self.price = price
        self.isUpdatePrice = !(price ?? "").isEmpty
        return self
    }
    
    func update(_ price: String?) {
        guard let price = price, !price.isEmpty, !isUpdatePrice else { return }
        isUpdatePrice = true
        self.price = price
        self.updatePrice()
    }
    
    private func updatePrice() {
        guard let price = price else { return }
        let js = "updatePriceScale('\(price)')"
        webView?.evaluateJavaScript(js, completionHandler: { _, error in
            print(error?.localizedDescription ?? "")
        })
    }
    
    func update(_ interval: IntervalTime) {
        self.interval = interval
        let js = "updateInterval('\(interval.jsValue)')"
        webView?.evaluateJavaScript(js, completionHandler: { _, error in
            print(error?.localizedDescription ?? "")
        })
    }
    
    func updateTheme() {
        let theme = self.traitCollection.userInterfaceStyle == .dark ? "Dark" : "Light"
        let js = "updateTheme('\(theme)')"
        self.webView?.evaluateJavaScript(js, completionHandler: { _, error in
            if error != nil {
                self.updateTheme()
            }
        })
    }
    
    private func getJSSymbol() -> String? {
        guard !self.marketId.isEmpty else { return nil }
        let replaceString = self.marketId.replacingOccurrences(of: "-", with: "/")
        return replaceString.hasPrefix("probit:") ? replaceString : "probit:" + replaceString
    }
        
    private func onInitChart (){
            guard let symbol = self.getJSSymbol() else { return }
            let upColor = AppConstant.tickerColor.buyColor.toHexString()
            let downColor = AppConstant.tickerColor.sellColor.toHexString()
            let theme = self.traitCollection.userInterfaceStyle == .dark ? "Dark" : "Light"
            let tokenPrice = self.price ?? "0.0"
            let interval: String = self.interval.jsValue
            let js = "onInitChart('\(symbol)', '\(interval)', '\(theme)', '\(upColor)', '\(downColor)', '\(tokenPrice)')"
            self.webView?.evaluateJavaScript(js, completionHandler: { _, error in
                if error != nil {
                    self.onInitChart()
                } else {
                    self.isInitChart = true
                }
            })
    }
    
    func updateCandleFromSocket(data: [[String: Any]]) {
        guard let jsonData = try? JSONSerialization.data(withJSONObject: data, options: []) else {
            return
        }
        let dataPassToWebView = String(data: jsonData, encoding: String.Encoding.utf8) ?? ""
        let js = "onSocketData('\(dataPassToWebView)')"
        webView?.evaluateJavaScript(js, completionHandler: { _, error in
            print(error?.localizedDescription ?? "")
        })
    }    
    
    func loadCandleData() {
        ExchangeAPI.shared.getCandleData(marketIds: marketId,
                                         startTime: self.startDate,
                                         endTime: self.endDate,
                                         interval: interval.rawValue,
                                         sort: "desc", completionHandler: { [weak self] result in
            guard let self = self else { return }
            print("[TRADINGVIEW_TIME]", self.startDate, self.endDate)
            switch result {
            case .success(let candleData):
                self.candleData = candleData.dictionary ?? [:]
                self.transferCandleDataToTradingView(key: self.key, data: self.candleData)
            case .failure(let failure):
                print(failure)
            }
        })
    }
    
}

extension TradingWebView: WKScriptMessageHandler {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if !isInitChart {
            self.onInitChart()
        }
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        guard let body = message.body as? String else { return }
        let params = body.components(separatedBy: "~")
        self.key = params.first ?? ""
        if params.count > 1 {
            self.startDate = params[1]
        }
        if params.count > 2 {
            self.endDate = params[2]
        }
        loadCandleData()
    }
}
