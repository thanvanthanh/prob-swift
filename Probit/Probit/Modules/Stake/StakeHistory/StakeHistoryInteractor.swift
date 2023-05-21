//
//  StakeHistoryInteractor.swift
//  Probit
//
//  Created by Đào Mỹ Đông on 06/10/2565 BE.
//  
//

import Foundation

class StakeHistoryInteractor: PresenterToInteractorStakeHistoryProtocol {
    
    lazy var allPage: StakeHistoryPageViewController = {
        let vc = StakeHistoryPageRouter(stakeType: nil).createModule() as! StakeHistoryPageViewController
        return vc
    }()
    
    lazy var stakePage: StakeHistoryPageViewController = {
        let vc = StakeHistoryPageRouter(stakeType: .USER).createModule() as! StakeHistoryPageViewController
        return vc
    }()
    
    lazy var reWardsPage: StakeHistoryPageViewController = {
        let vc = StakeHistoryPageRouter(stakeType: .STAKE_MINING).createModule() as! StakeHistoryPageViewController
        return vc
    }()

    lazy var menus: [MenuBar] = {
        return [MenuBar(name: "activity_currencystakehistory_tab_all".Localizable(),
                        icon: nil,
                        controller: allPage,
                        isSelected: true),
                MenuBar(name: "activity_currencystakehistory_tab_stake".Localizable(),
                        icon: nil,
                        controller: stakePage),
                MenuBar(name: "activity_currencystakehistory_tab_reward".Localizable(),
                        icon: nil,
                        controller: reWardsPage)]
    }()
    
    // MARK: Properties
    var presenter: InteractorToPresenterStakeHistoryProtocol?
    var stakeDetail: StakeDetailDataModel? {
        didSet {
            self.allPage.fillData(data: stakeDetail?.data ?? [])
            self.stakePage.fillData(data: stakeDetail?.data ?? [])
            self.reWardsPage.fillData(data: [])
        }
    }
    var interactorDetail: StakeDetailsInteractorProtocol
    
    init(interactorDetail: StakeDetailsInteractorProtocol) {
        self.interactorDetail = interactorDetail
    }

    private func getStakeDetail(completed: @escaping() -> Void) {
        guard let currencyId = interactorDetail.stakeEvent?.currencyId else { return }
        StakeAPI.shared.getStakeDetail(currencyId) { [weak self] result in
            guard let `self` = self else { return }
            switch result {
            case .success(let stakeDetail):
                self.stakeDetail = stakeDetail
            case let .failure(error):
                self.presenter?.handerApiError(error: error)
            }
            completed()
        }
    }
    
    func getData() {
        getStakeDetail {
            self.presenter?.changeStateResponseSucces()
        }
    }
    
    func didSelectMenuItem(index: IndexPath) {
        menus.enumerated().forEach { (i, _) in
            menus[i].isSelected = false
        }
        menus[index.row].isSelected = true
        presenter?.changeStateMenuSuccess()
    }

}
