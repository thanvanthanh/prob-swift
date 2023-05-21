//
//  TickerSection.swift
//  Probit
//
//  Created by Nguyen Quang on 09/09/2022.
//

import UIKit

class TickerSection: BaseView {
    @IBOutlet weak var mainStackView: UIStackView!
    
    init(content: [String], markets: [Market], delegate: HomeSectionProtocol) {
        super.init()
        setupView(content: content, markets: markets, delegate: delegate)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(content: [String], markets: [Market], delegate: HomeSectionProtocol) {
        var tickerContents: [TickerSectionItem] = []
        tickerContents = content.map { item in
            .init(model: markets.first(where: { item == $0.id }))
        }
        mainStackView.removeFullyAllArrangedSubviews()
        tickerContents.forEach { ticket in
            ticket.delegate = delegate
            mainStackView.addArrangedSubview(ticket)
        }
    }
    
    public func reloadView() {
        guard let ticketView = mainStackView.arrangedSubviews as? [TickerSectionItem] else { return }
        ticketView.forEach { ticket in
            ticket.reload()
        }
    }
    
    func setupDarkMode() {
        guard let ticketView = mainStackView.arrangedSubviews as? [TickerSectionItem] else { return }
        ticketView.forEach { ticket in
            ticket.setupDarkMode()
        }
    }
    
    func reloadSection(exchangeRate: ExchangeRate?,
                       marketData: MarketData?,
                       content: [String],
                       markets: [Market],
                       delegate: HomeSectionProtocol) {
        if mainStackView.arrangedSubviews.isEmpty {
            setupView(content: content, markets: markets, delegate: delegate)
        } else {
            mainStackView.arrangedSubviews.forEach {
                if let item = $0 as? TickerSectionItem {
                    guard let exchangeRate = exchangeRate  else {
                        updateTicker(item: item, marketData: marketData)
                        return
                    }
                    updateExchangeRate(item: item, exchangeRate: exchangeRate)
                }
            }
        }

    }
    
    func updateExchangeRate(item: TickerSectionItem, exchangeRate: ExchangeRate?) {
        let exchangeRate = exchangeRate?.data.usdt ?? []
        for usdt in exchangeRate where item.baseCurrencyID == usdt.currencyID {
            item.updatePrice(usdtRate: usdt.rate)
        }
    }
    
    func updateTicker(item: TickerSectionItem, marketData: MarketData?) {
        if item.id == marketData?.marketId {
            item.updateTicker(marketData: marketData)
        }
    }
}
