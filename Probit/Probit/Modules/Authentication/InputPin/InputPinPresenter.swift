//
//  InputPinPresenter.swift
//  Probit
//
//  Created by Thân Văn Thanh on 22/08/2022.
//  
//

import Foundation

class InputPinPresenter: ViewToPresenterInputPinProtocol {

    // MARK: Properties
    var view: PresenterToViewInputPinProtocol?
    var interactor: PresenterToInteractorInputPinProtocol?
    var router: PresenterToRouterInputPinProtocol?
    var type: InputPinType? { interactor?.type }
    var inputPinTitle: String? { interactor?.inputPinTitle }
    var title: String? { interactor?.title }
    var confirmTitle: String? { interactor?.confirmTitle }
    var leftTitle: String? {
        return interactor?.leftTitle
    }
    
    func getData() {
        interactor?.getData()
    }
    
    func validateInputLogin(input: InputPinTextField,
                            confirm: InputPinTextField) {
        interactor?.validateInputLogin(input: input, confirm: confirm)
    }
    
    func navigateToTerms() {
        router?.navigateToTerms()
    }
    
    func navigateToLogout(viewController: BaseViewController) {
        router?.navigateToLogout(viewController: viewController)
    }
    
}

extension InputPinPresenter: InteractorToPresenterInputPinProtocol {
    func fetchData() {
        view?.fetchData()
    }
    
    func confirmPin() {
        view?.confirmPin()
    }
    
    func validateInput(_ status: Bool, countFail coutFail: String, isEnabled: Bool) {
        view?.validateInput(status, countFail: coutFail, isEnabled: isEnabled)
    }
    
    func setupViewStep(_ hide: Bool) {
        view?.setupViewStep(hide)
    }
    
    func validateButton(_ validate: Bool) {
        view?.validateButton(validate)
    }
    
    func showCounterMessage(_ show: Bool) {
        view?.showCounterMessage(show)
    }
    
    func navigateToComplete() {
        router?.navigateToComplete()
    }
    
    func validateConfirmPassword(_ validate: Bool) {
        view?.validateConfirmPassword(validate)
    }
    
    func logoutWrongPinThirtyTimes(viewController: BaseViewController) {
        router?.logoutWrongPinThirtyTimes(viewController: viewController)
    }
}
