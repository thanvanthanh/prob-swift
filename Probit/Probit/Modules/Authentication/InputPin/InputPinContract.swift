//
//  InputPinContract.swift
//  Probit
//
//  Created by Thân Văn Thanh on 22/08/2022.
//  
//

import Foundation


// MARK: View Output (Presenter -> View)
protocol PresenterToViewInputPinProtocol {
    func fetchData()
    func confirmPin()
    func showCounterMessage(_ show: Bool)
    func validateInput(_ status: Bool, countFail: String, isEnabled: Bool)
    func setupViewStep(_ hide: Bool)
    func validateButton(_ validate: Bool)
    func validateConfirmPassword(_ validate: Bool)
}


// MARK: View Input (View -> Presenter)
protocol ViewToPresenterInputPinProtocol {
    
    var view: PresenterToViewInputPinProtocol? { get set }
    var interactor: PresenterToInteractorInputPinProtocol? { get set }
    var router: PresenterToRouterInputPinProtocol? { get set }
    var type: InputPinType? { get }
    var title: String? { get }
    var confirmTitle: String? { get }
    var inputPinTitle: String? { get }
    var leftTitle: String? { get }
    func getData()
    func navigateToTerms()
    func navigateToLogout(viewController: BaseViewController)
    func validateInputLogin(input: InputPinTextField, confirm: InputPinTextField)
}


// MARK: Interactor Input (Presenter -> Interactor)
protocol PresenterToInteractorInputPinProtocol {
    
    var presenter: InteractorToPresenterInputPinProtocol? { get set }
    var type: InputPinType? { get set }
    var title: String? { get set }
    var confirmTitle: String? { get set }
    var inputPinTitle: String? { get }
    var leftTitle: String? { get set }
    func getData()
    func validateInputLogin(input: InputPinTextField, confirm: InputPinTextField)
}


// MARK: Interactor Output (Interactor -> Presenter)
protocol InteractorToPresenterInputPinProtocol {
    func fetchData()
    func confirmPin()
    func showCounterMessage(_ show: Bool)
    func validateInput(_ status: Bool, countFail: String, isEnabled: Bool)
    func setupViewStep(_ hide: Bool)
    func navigateToComplete()
    func validateConfirmPassword(_ validate: Bool)
    func validateButton(_ validate: Bool)
    func navigateToLogout(viewController: BaseViewController)
    func logoutWrongPinThirtyTimes(viewController: BaseViewController)
}


// MARK: Router Input (Presenter -> Router)
protocol PresenterToRouterInputPinProtocol {
    func navigateToTerms()
    func navigateToComplete()
    func navigateToLogout(viewController: BaseViewController)
    func logoutWrongPinThirtyTimes(viewController: BaseViewController)
}
