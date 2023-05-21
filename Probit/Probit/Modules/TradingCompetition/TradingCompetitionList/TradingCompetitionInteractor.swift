//
//  TradingCompetitionInteractor.swift
//  Probit
//
//  Created by Nguyen Quang on 22/09/2022.
//  
//

import Foundation
import UIKit

class TradingCompetitionInteractor: PresenterToInteractorTradingCompetitionProtocol {
    // MARK: Properties
    var tradings: [Trading] = []
    var menus: [MenuBar] = [
        MenuBar(name: "tradecompetition_list_tab_tabbar_upcoming".Localizable(),
                icon: nil,
                controller: UIViewController()),
        MenuBar(name: "tradecompetition_list_tab_tabbar_running".Localizable(),
                icon: nil,
                controller: UIViewController()),
        MenuBar(name: "tradecompetition_list_tab_tabbar_all".Localizable(),
                icon: nil,
                controller: UIViewController(),
                isSelected: true)
    ]
    
    var presenter: InteractorToPresenterTradingCompetitionProtocol?
    var entity: InteractorToEntityTradingCompetitionProtocol?
    
    func getData() {
        entity?.getListTradecompetition(completionHandler: { [weak self] result in
            guard let `self` = self else { return }
            switch result {
            case let .success(response):
                var newData: [Trading] = []
                let runnings = response.data.filter { $0.stakeEventType == .RUNNING }.sorted()
                newData.append(contentsOf: runnings)
                let upComings = response.data.filter { $0.stakeEventType == .UP_COMING }.sorted()
                newData.append(contentsOf: upComings)
                let ends = response.data.filter { $0.stakeEventType == .END }.sorted()
                newData.append(contentsOf: ends)
                self.tradings = newData
                self.updateMenu(tradings: newData)
            case let .failure(error):
                self.presenter?.handerApiError(error: error)
            }
        })
    }
    
    func updateMenu(tradings: [Trading]) {
       
        let upcomingList = tradings.filter { $0.stakeEventType == .UP_COMING }.sorted { trade1, trade2 in
            guard let endDate1 = trade1.endDate, let endDate2 = trade2.endDate else {
                return true
            }
            return endDate1 < endDate2
        }
        
        let runningList = tradings.filter { $0.stakeEventType == .RUNNING }.sorted { trade1, trade2 in
            guard let endDate1 = trade1.endDate, let endDate2 = trade2.endDate else {
                return true
            }
            return endDate1 < endDate2
        }
        
        let endList = tradings.filter { $0.stakeEventType == .END }.sorted { trade1, trade2 in
            guard let date1 = trade1.endDate, let date2 = trade2.endDate else {
                return true
            }
            return date1 > date2
        }

        let sortAllTradings = [runningList, upcomingList, endList].reduce([], +)

        menus = [
            MenuBar(name: "tradecompetition_list_tab_tabbar_upcoming".Localizable(),
                    icon: nil,
                    controller: TradingCompetitionContentRouter().createModule(tradings: upcomingList)),
            MenuBar(name: "tradecompetition_list_tab_tabbar_running".Localizable(),
                    icon: nil,
                    controller: TradingCompetitionContentRouter().createModule(tradings: runningList)),
            MenuBar(name: "tradecompetition_list_tab_tabbar_all".Localizable(),
                    icon: nil,
                    controller: TradingCompetitionContentRouter().createModule(tradings: sortAllTradings),
                    isSelected: true)
        ]
        self.presenter?.getListTradingSuccess()
    }
    
    func didSelectMenuItem(index: IndexPath) {
        menus.enumerated().forEach { (i, _) in
            menus[i].isSelected = false
        }
        menus[index.row].isSelected = true
        presenter?.changeStateMenuSuccess()
    }
}

extension Trading: CustomStringConvertible, Comparable {
    var description: String { id }
    
    static func < (lhs: Trading, rhs: Trading) -> Bool {
        switch lhs.stakeEventType {
        case .RUNNING:
            guard let lhsEndDate = lhs.endDate, let rhsEndDate = rhs.endDate else { return false }
            return lhsEndDate.timeIntervalSince1970 < rhsEndDate.timeIntervalSince1970
        case .UP_COMING:
            guard let lhsStartDate = lhs.startDate, let rhsStartDate = rhs.startDate else { return false }
            return lhsStartDate.timeIntervalSince1970 > rhsStartDate.timeIntervalSince1970
        case .END:
            guard let lhsEndDate = lhs.endDate, let rhsEndDate = rhs.endDate else { return false }
            return lhsEndDate.timeIntervalSince1970 > rhsEndDate.timeIntervalSince1970
        default:
            return false
        }
    }
    
    static func == (lhs: Trading, rhs: Trading) -> Bool {
        true
    }
}
