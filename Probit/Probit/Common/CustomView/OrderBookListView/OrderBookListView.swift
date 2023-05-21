//
//  OrderBookListView.swift
//  Probit
//
//  Created by Nguyen Quang on 21/10/2022.
//

import Foundation
import UIKit

protocol OrderBookListViewProtocol: AnyObject {
    
    func didSelectRowAt(price: String, orderBook: OrderBook?)
}

enum OrderLevel {
    case L0, L1, L2, L3, L4
}

class OrderBookListView: BaseView {
    @IBOutlet private weak var tableView: UITableView!
    weak var delegate: OrderBookListViewProtocol?
    private let exchangeOrderBookHeader = ExchangeOrderBookHeader()
    var maxTotal: String? = nil
    var orderBooks: [[OrderBook]] = []
    var cacheOrderBooks: [OrderBook] = []
    var currentLevel: OrderLevel = .L0
    var isFirstLoading: Bool = true
    var currentPrice: String?
    var screenParent: OrderBookScreenParrent = .normal
    let pinchZoom: Double = 0.3
    
    var orderL0: [OrderBook] = []
    var orderL1: [OrderBook] = []
    var orderL2: [OrderBook] = []
    var orderL3: [OrderBook] = []
    var orderL4: [OrderBook] = []


    override func awakeFromNib() {
        super.awakeFromNib()
        setupTableView()
    }
    
    private func setupTableView() {
        tableView.separatorStyle = .none
        if #available(iOS 15.0, *) {
            self.tableView.sectionHeaderTopPadding = 0.0
        }
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.keyboardDismissMode = .onDrag
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0,
                                                         width: UIScreen.main.bounds.width,
                                                         height: CGFloat.leastNormalMagnitude))
        if #available(iOS 15.0, *) { tableView.sectionHeaderTopPadding = 0.0 }
        tableView.register(cellType: ExchangeOrderBookCell.self)
        
        exchangeOrderBookHeader.addTapGesture { [weak self] in
            guard let `self` = self, let currentPrice = self.currentPrice else { return }
            self.delegate?.didSelectRowAt(price: currentPrice, orderBook: nil)
        }
        
        let gesture = UIPinchGestureRecognizer(target: self, action: #selector(didPinchZoom(_:)))
        
        tableView.addGestureRecognizer(gesture)
    }
    
    @objc
     private func didPinchZoom(_ gesture: UIPinchGestureRecognizer) {
         if(gesture.state == .changed) {
             modifiedDataAfterZoom(gesture.scale)
         }
     }
     
     
     private func calculatorNextLevelWith(_ scale: CGFloat, onCompleted: ((OrderLevel) -> Void)?){
                 var nextLevel: OrderLevel
         switch currentLevel {
         case .L0:
             if scale >= 1 {
                 nextLevel = .L0
             }
             else if scale >= (1.0 - pinchZoom) && scale < 1.0 {
                 nextLevel = .L1
             }
             else if scale >= (1 - 2*pinchZoom) && scale < (1 - pinchZoom) {
                 nextLevel = .L2
             }
             else if scale >= (1 - 3*pinchZoom) && scale < (1 - 2*pinchZoom) {
                 nextLevel = .L3
             }
             else {
                 nextLevel = .L4
             }
         case .L1:
             if scale >= (1 + pinchZoom) {
                 nextLevel = .L0
             }
             else if scale >= 1 && scale < (1 + pinchZoom) {
                 nextLevel = .L1
             }
             else if scale >= (1 - pinchZoom) && scale < 1.0 {
                 nextLevel = .L2
             }
             else if scale >= (1 - 2*pinchZoom) && scale < (1 - pinchZoom) {
                 nextLevel = .L3
             }
             else  {
                 nextLevel = .L4
             }
         case .L2:
             if scale >= (1 + 2*pinchZoom) {
                 nextLevel = .L0
             }
             else if scale >= (1 + pinchZoom) && scale < (1 + 2*pinchZoom) {
                 nextLevel = .L1
             }
             else if scale >= 1 && scale < (1 + pinchZoom) {
                 nextLevel = .L2
             }
             else if scale >= (1 - pinchZoom) && scale < 1 {
                 nextLevel = .L3
             }
             else {
                 nextLevel = .L4
             }
             
         case .L3:
             if scale >= (1 + 3*pinchZoom) {
                 nextLevel = .L0
             }
             else if scale >= (1 + 2*pinchZoom) && scale < (1 + 3*pinchZoom) {
                 nextLevel = .L1
             }
             else if scale >= (1 + pinchZoom) && scale < (1 + 2*pinchZoom) {
                 nextLevel = .L2
             }
             else if scale >= 1.0 && scale < (1 + pinchZoom) {
                 nextLevel = .L3
             }
             else {
                 nextLevel = .L4
             }
         case .L4:
             if scale >= (1 + 4*pinchZoom) {
                 nextLevel = .L0
             }
             else if scale >= (1 + 3*pinchZoom) && scale < (1 + 4*pinchZoom) {
                 nextLevel = .L1
             }
             else if scale >= (1 + 2*pinchZoom) && scale < (1 + 3*pinchZoom) {
                 nextLevel = .L2
             }
             else if scale >= (1 + pinchZoom) && scale < (1 + 2*pinchZoom) {
                 nextLevel = .L3
             }
             else {
                 nextLevel = .L4
             }
         }
         onCompleted?(nextLevel)
     }
     
     private func modifiedDataAfterZoom(_ scale: CGFloat) {
         calculatorNextLevelWith(scale) { [weak self] level in
             guard let this = self, level != this.currentLevel else {
                 return
             }
             this.currentLevel = level
             this.cacheOrderBooks = []
             this.updateData(data: this.orders(withLevel: this.currentLevel))
         }
     }
    
    public func loadData(data: [[OrderBook]]) {
        let isEmpty = data.reduce([], +).isOrderEmpty
        // Update data
        guard !data.isEmpty || isEmpty else {
            var ordersBuy: [OrderBook] = []
            var ordersSell: [OrderBook] = []
            for _ in 0..<20 {
                ordersBuy.append(OrderBook(side: "buy"))
                ordersSell.append(OrderBook(side: "sell"))
            }
            orderBooks = screenParent == .detail ? [ordersSell, ordersBuy] : [ordersSell]
            reloadData()
            return
        }
    
        let sells = data.first ?? []
        let buys = data.last ?? []
        if (sells.count < 20 || buys.count < 20) && screenParent == .detail {
            
            var sellOrders: [OrderBook] = sells
            var buyOrders: [OrderBook] = buys
            
            let sellInsertValue = 20 - sells.count
            
            let buyInsertValue = 20 - buys.count
            
            if sellInsertValue > 0 {
                for _ in 0..<sellInsertValue {
                    sellOrders.append(OrderBook(side: "sell"))
                }
            }
            
            if buyInsertValue > 0 {
                for _ in 0..<buyInsertValue {
                    buyOrders.append(OrderBook(side: "buy"))
                }
            }
            
            let orderSections: [[OrderBook]] = [sellOrders, buyOrders]
            orderBooks = orderSections
            reloadData()
            return
        }
        
        orderBooks = data
        reloadData()
    }
    
    
    public func updateCurrentPrice(model: RecentTrade?) {
        guard let model = model else { return }
        currentPrice = model.price
        exchangeOrderBookHeader.updatePrice(price: model.price, tickDerection: model.orderTickDirection)
    }
    
    private func orders(withLevel level: OrderLevel) -> [OrderBook]{
        switch level {
        case .L0:
            return self.orderL0
        case .L1:
            return self.orderL1
        case .L2:
            return self.orderL2
        case .L3:
            return self.orderL3
        case .L4:
            return self.orderL4
        }
    }
    
    public func handleOnListenerMarket(_ data: MarketData) {
        self.orderL0.modified(with: data.orderBooks0)
        self.orderL1.modified(with: data.orderBooks1)
        self.orderL2.modified(with: data.orderBooks2)
        self.orderL3.modified(with: data.orderBooks3)
        self.orderL4.modified(with: data.orderBooks4)
        updateData(data: self.orders(withLevel: currentLevel))
    }
    
    public func updateUsdtRate(usdtRate: String) {
        exchangeOrderBookHeader.updateUsdtRate(usdtPrice: usdtRate)
    }
    
    public func updateData(data: [OrderBook]) {
        guard !data.isEmpty || data.isOrderEmpty else {
            var ordersBuy: [OrderBook] = []
            var ordersSell: [OrderBook] = []
            for _ in 0..<20 {
                ordersBuy.append(OrderBook(side: "buy"))
                ordersSell.append(OrderBook(side: "sell"))
            }
            
            orderBooks = screenParent == .detail ? [ordersSell, ordersBuy] : [ordersSell]
            reloadData()
            return
        }
                
        // Update data
        data.forEach { item in
            if let  index = cacheOrderBooks
                .firstIndex(where: { $0.price == item.price && $0.orderSide == item.orderSide }) {
                cacheOrderBooks[index].mapping(quantity: item.quantity)
            } else {
                cacheOrderBooks.append(item)
            }
        }
        var response: [[OrderBook]] = []
        // Sort data
        var currentSells = cacheOrderBooks.filter { $0.orderSide == .SELL && $0.quantity.asDouble() != 0.0 }
            .sorted().suffix(20).map { $0 }
        var currentBuys = cacheOrderBooks.filter { $0.orderSide == .BUY && $0.quantity.asDouble() != 0.0 }
            .sorted().prefix(20).map { $0 }
        
        
        // math total
        currentSells.enumerated().forEach { index, elemnet in
            elemnet.mapping(total: getTotalOrderSells(index: index, listData: currentSells))
            elemnet.mapping(totalMarket: getTotalMarketOrderSells(index: index, listData: currentSells))
        }
        currentBuys.enumerated().forEach { index, elemnet in
            elemnet.mapping(total: getTotalOrderBuys(index: index, listData: currentBuys))
            elemnet.mapping(totalMarket: getTotalMarketOrderBuys(index: index, listData: currentBuys))
        }
        
        let sellInsertValue = 20 - currentSells.count
        let buyInsertValue = 20 - currentBuys.count

        if(sellInsertValue > 0 ){
            for _ in 0..<sellInsertValue {
                currentSells.insert(OrderBook(side: "sell"), at: 0)
            }
        }
            
        if(buyInsertValue > 0){
            for _ in 0..<buyInsertValue {
                currentBuys.append(OrderBook(side: "buy"))
            }
        }
        response.append(currentSells)
        response.append(currentBuys)
        orderBooks = response
        
        setMaxTotal()
        reloadData()
    }
    
    private func reloadData() {
        tableView.reloadData {
            guard self.isFirstLoading, self.orderBooks.count > 0 else { return }
            self.isFirstLoading = false
            self.scrollToCenter()
        }
    }
    
    private func scrollToCenter() {
        guard orderBooks.count > 1,
              let lastSection = orderBooks.last,
              lastSection.count > 0 else { return }
        let centerCell = IndexPath(row: 0, section: 1)
        tableView.scrollToRow(at: centerCell, at: .middle, animated: false)
    }
    
    private func getTotalOrderSells(index: Int, listData: [OrderBook]) -> String {
        return listData.suffix(listData.count - index).map { $0.quantity.asDouble() }.reduce(0, +).string
    }
    
    private func getTotalOrderBuys(index: Int, listData: [OrderBook]) -> String {
        return listData.prefix(index + 1).map { $0.quantity.asDouble() }.reduce(0, +).string
    }
    
    private func getTotalMarketOrderSells(index: Int, listData: [OrderBook]) -> String {
        return listData.suffix(listData.count - index)
            .map { $0.quantity.asDouble() * $0.price.asDouble() }
            .reduce(0, +).string
    }
    
    private func getTotalMarketOrderBuys(index: Int, listData: [OrderBook]) -> String {
        return listData.prefix(index + 1)
            .map { $0.quantity.asDouble() * $0.price.asDouble() }
            .reduce(0, +).string
    }
    
    private func setMaxTotal() {
        maxTotal = orderBooks.flatMap { $0 }.compactMap { $0.total?.asDouble() }.max()?.string
    }
    
}
extension OrderBookListView: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        orderBooks.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderBooks[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(ExchangeOrderBookCell.self)
        let dataItem = orderBooks[indexPath.section][indexPath.row]
        cell.configCellWith(dataItem, maxTotal: maxTotal, screenParent: screenParent)
        return cell
    }
}

extension OrderBookListView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = orderBooks[indexPath.section][indexPath.row]
        delegate?.didSelectRowAt(price: item.price,
                                 orderBook: item)
//        delegate?.didSelectRowAt(price: item.price, amount: item.total?.asDouble().forTrailingZero())
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let orderBook = orderBooks[section].first,
              orderBook.orderSide == .BUY else {
            return nil
        }
        return exchangeOrderBookHeader
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let orderBook = orderBooks[section].first,
              orderBook.orderSide == .BUY else {
            return .leastNormalMagnitude
        }
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        .leastNormalMagnitude
    }
    
}
