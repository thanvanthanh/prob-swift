//
//  StakeCollectionPresenter.swift
//  Probit
//
//  Created by Đào Mỹ Đông on 22/09/2565 BE.
//  
//

import Foundation

class StakeCollectionPresenter: ViewToPresenterStakeCollectionProtocol {
    var stakeFilted: [StakeEventModel] {
        get { interactor?.stakeFilted ?? [] }
        set { interactor?.stakeFilted = newValue}
    }
    
    var type: StakeCollectionType {
        interactor?.type ?? .ALL
    }
    
    // MARK: Properties
    var view: PresenterToViewStakeCollectionProtocol?
    var interactor: PresenterToInteractorStakeCollectionProtocol?
    var router: PresenterToRouterStakeCollectionProtocol?
}

extension StakeCollectionPresenter: InteractorToPresenterStakeCollectionProtocol {
    func filterByTypeStakeList() {
        let listFilted = interactor?.stakeList.filter({ [weak self] stakeEvent in
            guard let self = self else { return false}
            switch self.interactor?.type {
            case .ALL:
                return true
            case .RUNNING:
                return stakeEvent.stakeEventType == .RUNNING
            case .UP_COMING:
                return stakeEvent.stakeEventType == .UP_COMING
            default:
                return false
            }
        }) ?? []
        self.stakeFilted = listFilted
        self.view?.reloadData()
    }
}
