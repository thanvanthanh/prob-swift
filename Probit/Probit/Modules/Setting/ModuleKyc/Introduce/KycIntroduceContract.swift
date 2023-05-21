//
//  KycIntroduceContract.swift
//  Probit
//
//  Created by Bradley Hoang on 01/11/2022.
//  
//

import Foundation

// MARK: View Output (Presenter -> View)
protocol PresenterToViewKycIntroduceProtocol : BaseViewProtocol{
   func reloadView()
}

// MARK: View Input (View -> Presenter)
protocol ViewToPresenterKycIntroduceProtocol {
    var view: PresenterToViewKycIntroduceProtocol? { get set }
    var interactor: PresenterToInteractorKycIntroduceProtocol? { get set }
    var router: PresenterToRouterKycIntroduceProtocol? { get set }
    func viewDidLoad()
    func navigateByStatus()
}

// MARK: Interactor Input (Presenter -> Interactor)
protocol PresenterToInteractorKycIntroduceProtocol {
    var presenter: InteractorToPresenterKycIntroduceProtocol? { get set }
    var kycStatusModel: UserKycStatusDetailModel { get }
    func getData()
    func reloadKycData(completion: @escaping () -> Void)
}

// MARK: Interactor Output (Interactor -> Presenter)
protocol InteractorToPresenterKycIntroduceProtocol {
    func getDataFailed(_ error: ServiceError)
    func getDataCompleted()
}

// MARK: Router Input (Presenter -> Router)
protocol PresenterToRouterKycIntroduceProtocol {
    func navigateToKycSelectCountry()
    func navigateInputType()
    func navigateSelfImageClear()
}
