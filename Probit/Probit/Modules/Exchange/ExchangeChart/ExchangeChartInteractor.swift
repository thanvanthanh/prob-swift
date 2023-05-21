//
//  ExchangeChartInteractor.swift
//  Probit
//
//  Created by Nguyen Quang on 13/10/2022.
//  
//

import Foundation

class ExchangeChartInteractor: PresenterToInteractorExchangeChartProtocol {
    // MARK: Properties
    var presenter: InteractorToPresenterExchangeChartProtocol?
    var exchange: ExchangeTicker?
    var marketId: String?
    
    var exchangId: String {
        if let exchangeId = exchange?.id {
            return exchangeId
        } else if let marketId = marketId {
            return marketId
        } else {
            return ""
        }
    }
}

class Chart {
    let htmlString: String
    
    init(interval: String) {
        htmlString = """
        <!-- TradingView Widget BEGIN -->
        <div class="tradingview-widget-container">
            <div id="tradingview_6880e"></div>
            <script type="text/javascript" src="https://s3.tradingview.com/tv.js"></script>
            <script type="text/javascript">
            new TradingView.widget({
                "autosize": true,
                "symbol": "BINANCE:BTCUSDT",
                "interval": "\(interval)",
                "showChart": "true",
                "timezone": "Etc/UTC",
                "theme": "light",
                "locale": "en",
                "isTransparent": true,
                "enable_publishing": false,
                "hide_top_toolbar": true,
                "hide_legend": true,
                "save_image": false,
                "container_id": "tradingview_6880e"});
          </script>
        </div>
        <!-- TradingView Widget END -->
        """
    }
}
