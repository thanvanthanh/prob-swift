
import Foundation

enum SocketChannel: String {
    case marketdata     = "marketdata"
    case openOrder      = "open_order"
    case tradeHistory   = "trade_history"
    case orderHistory   = "order_history"
    case balance        = "balance"
    case exchangeRate   = "exchange_rate"
    case realtimeCandle = "realtime_candle"
}

enum SocketType: String {
    case subscribe = "subscribe"
    case unsubscribe = "unsubscribe"
    case authorization = "authorization"
}

struct SocketRequestMessage {
    private var type: String?
    private var token: String?
    private var channel: String?
    private var interval: Int?
    private var market_id: String?
    private var filter: [String]?
    
    private init(type: String? = nil, token: String? = nil, channel: String? = nil, interval: Int = 500, marketID: String? = nil, filter: [String]? = nil) {
        self.type = type
        self.token = token
        self.channel = channel
        self.interval = interval
        self.market_id = marketID
        self.filter = filter
    }
    
    final class Builder {
        private var type: String?
        private var token: String?
        private var channel: String?
        private var interval: Int = 100
        private var marketID: String?
        private var filter: [String]?
        
        public func setType(_ value: String) -> Builder {
            self.type = value
            return self
        }
        
        public func setToken(_ value: String) -> Builder {
            self.token = value
            return self
        }
        
        public func setChannel(_ value: String) -> Builder {
            self.channel = value
            return self
        }
        public func setInterval(_ value: Int) -> Builder {
            self.interval = value
            return self
        }
        public func setMarketID(_ value: String) -> Builder {
            self.marketID = value
            return self
        }
        public func setFilter(_ value: [String]) -> Builder {
            self.filter = value
            return self
        }
        public func build() -> SocketRequestMessage {
            return SocketRequestMessage(type: type, token: token, channel: channel, interval: interval, marketID: marketID, filter: filter)
        }
    }
}
