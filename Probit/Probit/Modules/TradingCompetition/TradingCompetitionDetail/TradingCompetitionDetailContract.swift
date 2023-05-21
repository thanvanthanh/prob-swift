//
//  TradingCompetitionDetailContract.swift
//  Probit
//
//  Created by Nguyen Quang on 22/09/2022.
//  
//

import Foundation

// MARK: View Output (Presenter -> View)
protocol PresenterToViewTradingCompetitionDetailProtocol: BaseViewProtocol {
    func reloadData()
}

// MARK: View Input (View -> Presenter)
protocol ViewToPresenterTradingCompetitionDetailProtocol {
    var view: PresenterToViewTradingCompetitionDetailProtocol? { get set }
    var interactor: PresenterToInteractorTradingCompetitionDetailProtocol? { get set }
    var router: PresenterToRouterTradingCompetitionDetailProtocol? { get set }
    var stakeInteracter: StakeDetailsInteractorProtocol? { get set }
    var trading: Trading? { get set }
    var title: String? { get set }
    var tradingDetail: TradingDetail? { get }
    var tradingLeaderboard: TradingLeaderboard? { get }
    var isIneligible: Bool { get }
    var myStatusStake: String? { get }
    var myStatusKyc: Int? { get }
    var isDisplayStartTrading: Bool? { get set }
    
    func viewDidLoad()
    func navigateToTradingPrizes()
    func navigateToLeaderBoard()
    func navigateToLogin()
    func goToKyc()
    func startTrading()
}

// MARK: Interactor Input (Presenter -> Interactor)
protocol PresenterToInteractorTradingCompetitionDetailProtocol {
    var presenter: InteractorToPresenterTradingCompetitionDetailProtocol? { get set }
    var entity: InteractorToEntityTradingCompetitionDetailProtocol? { get set }
    var isIneligible: Bool { get set }
    var myStatusKyc: Int? { get set }
    var myStatusStake: String? { get set }
    var tradingDetail: TradingDetail? { get set }
    var tradingLeaderboard: TradingLeaderboard? { get set }
    func getKycStatusModel()
    func getData(id: String)
}

// MARK: Interactor Output (Interactor -> Presenter)
protocol InteractorToPresenterTradingCompetitionDetailProtocol {
    func getDataSuccess()
    func handerApiError(error: ServiceError)
    func getKycStatusModelSuccesed(kycStatusModel: UserKycStatusDetailModel)
}

// MARK: Router Input (Presenter -> Router)
protocol PresenterToRouterTradingCompetitionDetailProtocol {
    func navigateToLogin()
    func startTrading(maketIds: [String])
    func navigateToTradingPrizes(tradingDetail: TradingDetail?)
    func navigateToLeaderBoard(title: String?, eventType: StakeEventType?, leaderBoard: TradingLeaderboard?)}

protocol InteractorToEntityTradingCompetitionDetailProtocol {
    func getListTradecompetitionDetail(id: String,
                                       completionHandler: @escaping (Result<TradingDetailResponse, ServiceError>) -> Void)
    func getLeaderboardTrading(id: String,
                               completionHandler: @escaping (Result<TradingLeaderboard, ServiceError>) -> Void)
    func checkStep(completionHandler: @escaping (Result<CheckStepModel, ServiceError>) -> Void)
    func getStakeUser(completionHandler: @escaping (Result<StakeUserData, ServiceError>) -> Void)
    func membership(completionHandler: @escaping (Result<MembershipModel, ServiceError>) -> Void)
}
