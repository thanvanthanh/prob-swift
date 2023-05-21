//
//  TermsPresenter.swift
//  Probit
//
//  Created by Nguyen Quang on 22/08/2022.
//  
//

import Foundation

class TermsPresenter: ViewToPresenterTermsProtocol {
    // MARK: Properties
    var view: PresenterToViewTermsProtocol?
    var interactor: PresenterToInteractorTermsProtocol?
    var router: PresenterToRouterTermsProtocol?
    
    var listTerms: [Terms] { interactor?.listTerms ?? [] }
    var screenFrom: AuthScreenFrom { interactor?.screenFrom ?? .signUp }
    
    var agreements: Agreements {
        let marketingPrivacy = listTerms.first(where: { $0.name == .agreeMarketingPrivacy })
        let marketingMail = marketingPrivacy?.subContent.first(where: { $0.name == .agreeeMarketingEmail })
        let marketingSms = marketingPrivacy?.subContent.first(where: { $0.name == .agreeeMarketingEmail })

        return Agreements(marketing_privacy: marketingPrivacy?.isSelected ?? false,
                          marketing_mail: marketingMail?.isSelected ?? false,
                          marketing_sms: marketingSms?.isSelected ?? false)
    }

    func viewDidLoad() {
        interactor?.getTerms()
    }
    
    func notificationPreference() {
        interactor?.notificationPreference()
    }
    
    func changeStateTerms(term: Terms) {
        interactor?.changeStateTerms(term: term)
    }
    
    func changeStateSubTerms(indexPath: IndexPath) {
        interactor?.changeStateSubTerms(indexPath: indexPath)
    }
    
    func nextScreen() {
        guard screenFrom == .signUp else {
            notificationPreference()
            return
        }
        router?.nextScreen(screenFrom: screenFrom, agreements: agreements)
    }
    
    func navigateToWebView(url: String) {
        router?.navigateToWebView(url: url)
    }
    
    private func checkEnableNextButton() {
        let mandatory = listTerms.filter { $0.isMandatory }
        let isEnable = mandatory.map({ $0.isSelected }).contains(false)
        self.view?.setEnableNextButton(!isEnable)
    }
}

extension TermsPresenter: InteractorToPresenterTermsProtocol {
    func termsListDidFetch() {
        view?.reloadData()
        checkEnableNextButton()
    }
    
    func sendTermSuccessfully() {
        view?.hideLoading()
        router?.nextScreen(screenFrom: .signIn, agreements: agreements)
    }
    
    func handerApiError() {
        view?.hideLoading()
    }
}
