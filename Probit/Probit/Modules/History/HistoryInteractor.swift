//
//  HistoryInteractor.swift
//  Probit
//
//  Created by Nguyen Quang on 29/08/2022.
//  
//

import UIKit

class HistoryInteractor: PresenterToInteractorHistoryProtocol {
    var menus: [MenuBar] = []
    // MARK: Properties
    var presenter: InteractorToPresenterHistoryProtocol?
    var currentPage: Int = 0
    private let openOrder = OpenOrdersRouter().createModule(type: .defaults)
    private let orderHistory = OrderHistoryRouter().createModule()
    private let tradeHistory = TradeHistoryRouter().createModule()
    init() {
        menus = [
            MenuBar(name: "report_openorders".Localizable(),
                    icon: nil,
                    controller: openOrder,
                    isSelected: true),
            MenuBar(name: "report_orderhistory".Localizable(),
                    icon: nil,
                    controller: orderHistory),
            MenuBar(name: "report_tradehistory".Localizable(),
                    icon: nil,
                    controller: tradeHistory)
        ]
    }
    
    func getData() {
    }
    
    func didSelectMenuItem(index: IndexPath) {
        menus.enumerated().forEach { (i, _) in
            menus[i].isSelected = false
        }
        menus[index.row].isSelected = true
        currentPage = index.row
        presenter?.changeStateMenuSuccess()
    }
}
