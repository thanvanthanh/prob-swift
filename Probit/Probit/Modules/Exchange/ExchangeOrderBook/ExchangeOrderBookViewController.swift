//
//  ExchangeOrderBookViewController.swift
//  Probit
//
//  Created by Nguyen Quang on 17/10/2022.
//  
//

import UIKit

class ExchangeOrderBookViewController: BaseViewController {
    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var orderBookListView: OrderBookListView!
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
    }
    
    override func localizedString() {
        super.localizedString()
        priceLabel.text = "orderform_price".Localizable()
        amountLabel.text = "orderform_amount".Localizable()
        timeLabel.text = "orderform_total".Localizable()
    }
    
    public func onListenerSocket(_ data: MarketData ) {
        orderBookListView.handleOnListenerMarket(data)
    }
    
    public func loadData(data: [OrderBook]) {
        orderBookListView.updateData(data: data)
    }
    
    public func updateCurrentPrice(model: RecentTrade?) {
        orderBookListView.updateCurrentPrice(model: model)
    }
    
    public func updateUsdtRate(usdtRate: String) {
        orderBookListView.updateUsdtRate(usdtRate: usdtRate)
    }
    
    // MARK: - Properties
    var presenter: ViewToPresenterExchangeOrderBookProtocol?
}

extension ExchangeOrderBookViewController: PresenterToViewExchangeOrderBookProtocol{
    // TODO: Implement View Output Methods
}
