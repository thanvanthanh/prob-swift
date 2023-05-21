//
//  ValidateCardContract.swift
//  Probit
//
//  Created by Đào Mỹ Đông on 16/11/2565 BE.
//  
//

import Foundation

// MARK: View Output (Presenter -> View)
protocol PresenterToViewValidateCardProtocol: BaseViewProtocol {
   func reloadView()
}

// MARK: View Input (View -> Presenter)
protocol ViewToPresenterValidateCardProtocol {
    var view: PresenterToViewValidateCardProtocol? { get set }
    var interactor: PresenterToInteractorValidateCardProtocol? { get set }
    var router: PresenterToRouterValidateCardProtocol? { get set }
    func viewDidLoad()
    func doProceedAnyway()

}

// MARK: Interactor Input (Presenter -> Interactor)
protocol PresenterToInteractorValidateCardProtocol {
    var presenter: InteractorToPresenterValidateCardProtocol? { get set }
    func getData()
    var dataOcr: ValidOCRModel? { get }
    var loadingData: LoadingKycModel? { get }
    var pageType: UserKycStatusDetailModel.PageType { get }
    func nextProcessAnyWay()
}

// MARK: Interactor Output (Interactor -> Presenter)
protocol InteractorToPresenterValidateCardProtocol {
    func getDataFailed(_ error: ServiceError)
    func getDataCompleted()
    func nextStepSuccess()
}

// MARK: Router Input (Presenter -> Router)
protocol PresenterToRouterValidateCardProtocol {
    func navigateComplateVC()
}
