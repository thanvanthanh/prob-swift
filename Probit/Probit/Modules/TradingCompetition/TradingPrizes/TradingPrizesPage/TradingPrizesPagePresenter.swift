//
//  TradingPrizesPagePresenter.swift
//  Probit
//
//  Created by Nguyen Quang on 04/10/2022.
//  
//

import Foundation

class TradingPrizesPagePresenter: ViewToPresenterTradingPrizesPageProtocol {
    // MARK: Properties
    var tradingDetail: TradingDetail?
    var view: PresenterToViewTradingPrizesPageProtocol?
    var interactor: PresenterToInteractorTradingPrizesPageProtocol?
    var router: PresenterToRouterTradingPrizesPageProtocol?
    var menus: [MenuBar] = []
    
    var title: String? {
        guard let boostedPrizeList = tradingDetail?.boostedPrizeList, boostedPrizeList.count > 0 else {
            return "tradecompetition_main_prizes".Localizable()
        }
        return "tradecompetition_prize_title_boost".Localizable()
    }
    
    func viewDidLoad() {
        settingMenu()
    }
    
    func settingMenu() {
        let prizeList = tradingDetail?.prizeList ?? []
        guard let boostedPrizeList = tradingDetail?.boostedPrizeList, boostedPrizeList.count > 0  else {
            menus = [MenuBar(name: "tradecompetition_prizes_boosttab_achieved".Localizable(),
                             icon: nil,
                             controller: TradingPrizesRouter().createModule(tradings: prizeList))]
            view?.getDataSuccess()
            return
        }
        menus = [MenuBar(name: "tradecompetition_prizes_boosttab_achieved".Localizable(),
                         icon: nil,
                         controller: TradingPrizesRouter().createModule(tradings: boostedPrizeList)),
                 MenuBar(name: "tradecompetition_prizes_boosttab_notachieved".Localizable(),
                         icon: nil,
                         controller: TradingPrizesRouter().createModule(tradings: prizeList),
                         isSelected: true)]
        view?.getDataSuccess()
    }
    
    func didSelectMenuItem(index: IndexPath) {
        menus.enumerated().forEach { (i, _) in
            menus[i].isSelected = false
        }
        menus[index.row].isSelected = true
        view?.reloadData()
    }
}

extension TradingPrizesPagePresenter: InteractorToPresenterTradingPrizesPageProtocol {
    
}
