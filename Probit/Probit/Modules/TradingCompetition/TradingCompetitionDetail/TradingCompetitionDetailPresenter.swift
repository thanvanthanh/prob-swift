//
//  TradingCompetitionDetailPresenter.swift
//  Probit
//
//  Created by Nguyen Quang on 22/09/2022.
//  
//

import Foundation

class TradingCompetitionDetailPresenter: ViewToPresenterTradingCompetitionDetailProtocol {
    // MARK: Properties
    var view: PresenterToViewTradingCompetitionDetailProtocol?
    var interactor: PresenterToInteractorTradingCompetitionDetailProtocol?
    var router: PresenterToRouterTradingCompetitionDetailProtocol?
    var stakeInteracter: StakeDetailsInteractorProtocol?
    var title: String?
    var trading: Trading?
    var myStatusKyc: Int? { interactor?.myStatusKyc }
    var myStatusStake: String? { interactor?.myStatusStake }
    var tradingDetail: TradingDetail? { interactor?.tradingDetail }
    var isIneligible: Bool { interactor?.isIneligible ?? false }
    var tradingLeaderboard: TradingLeaderboard? { interactor?.tradingLeaderboard }
    var isDisplayStartTrading: Bool?
    
    func viewDidLoad() {
        getData()
    }
    
    func getData() {
        guard let id = trading?.id else { return }
        view?.showLoading()
        interactor?.getData(id: id)
    }
    
    func navigateToTradingPrizes() {
        router?.navigateToTradingPrizes(tradingDetail: tradingDetail)
    }
    
    func navigateToLeaderBoard() {
        router?.navigateToLeaderBoard(title: tradingDetail?.name ?? "",
                                      eventType: trading?.stakeEventType,
                                      leaderBoard: tradingLeaderboard)
    }
    
    func navigateToLogin() {
        router?.navigateToLogin()
    }
    
    func startTrading() {
        let marketIds = tradingDetail?.uiDescription.data.targetMarket ?? []
        router?.startTrading(maketIds: marketIds)
    }
    func goToKyc() {
        view?.showLoading()
        interactor?.getKycStatusModel()
    }
}

extension TradingCompetitionDetailPresenter: InteractorToPresenterTradingCompetitionDetailProtocol {
    func getDataSuccess() {
        view?.hideLoading()
        view?.reloadData()
    }
    
    func handerApiError(error: ServiceError) {
        view?.hideLoading()
    }
    
    func getKycStatusModelSuccesed(kycStatusModel: UserKycStatusDetailModel) {
        view?.hideLoading()
        KycIntroduceRouter(kycStatusModel: kycStatusModel).showScreen()
    }
}
