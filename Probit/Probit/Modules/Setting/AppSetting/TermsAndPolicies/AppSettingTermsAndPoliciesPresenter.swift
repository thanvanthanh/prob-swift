//
//  AppSettingTermsAndPoliciesPresenter.swift
//  Probit
//
//  Created by Thân Văn Thanh on 31/08/2022.
//  
//

import Foundation

class AppSettingTermsAndPoliciesPresenter: ViewToPresenterAppSettingTermsAndPoliciesProtocol {
    var listTermsSetting: [TermsAndPolicies] { interactor?.listTermsSetting ?? [] }
    
    func viewDidLoad() {
        interactor?.getTermsSetting()
    }
    
    // MARK: Properties
    var view: PresenterToViewAppSettingTermsAndPoliciesProtocol?
    var interactor: PresenterToInteractorAppSettingTermsAndPoliciesProtocol?
    var router: PresenterToRouterAppSettingTermsAndPoliciesProtocol?
    
    func changeStateTerms(term: TermSetting) {
        interactor?.changeStateTerms(term: term)
    }
    
    func navigateToWebView(url: String) {
        router?.navigateToWebView(url: url)
    }
    
    func headerAction(terms: TermsAndPolicies) {
        router?.headerAction(terms: terms)
    }
}

extension AppSettingTermsAndPoliciesPresenter: InteractorToPresenterAppSettingTermsAndPoliciesProtocol {
    func showAlert(msg: String) {
        router?.showAlert(msg: msg)
    }
    
    func termsSettingListDidFetch() {
        view?.reloadData()
    }

}
