//
//  TermsInteractor.swift
//  Probit
//
//  Created by Nguyen Quang on 22/08/2022.
//  
//

import Foundation

class TermsInteractor: PresenterToInteractorTermsProtocol {
    var listTerms: [Terms] = []
    var screenFrom: AuthScreenFrom = .signUp
    // MARK: Properties
    var presenter: InteractorToPresenterTermsProtocol?
    var entity: InteractorToEntityTermsProtocol?
    
    func getTerms() {
        guard screenFrom == .signUp else {
            self.listTerms =    [Terms(name: .all, subContent: [Terms(name: .all)]),
                                Terms(name: .agreeMarketingPrivacy, subContent: [Terms(name: .agreeeMarketingEmail),
                                Terms(name: .agreeeMarketingSMS),
                                Terms(name: .agreeeMarketingPush)])
            ]
            presenter?.termsListDidFetch()
            return
        }
        
        self.listTerms = [Terms(name: .all, subContent: [Terms(name: .all)]),
                          Terms(name: .termOfService),
                          Terms(name: .privacyPolicy),
                          Terms(name: .agreeMarketingPrivacy, subContent: [Terms(name: .agreeeMarketingEmail),
                          Terms(name: .agreeeMarketingSMS)])
        ]
        presenter?.termsListDidFetch()
    }
    
    func notificationPreference() {
        let marketingPrivacy = listTerms.first(where: { $0.name == .agreeMarketingPrivacy })
        let marketingMail = marketingPrivacy?.subContent.first(where: { $0.name == .agreeeMarketingEmail })
        let marketingPush = marketingPrivacy?.subContent.first(where: { $0.name == .agreeeMarketingPush })
        let marketingSms = marketingPrivacy?.subContent.first(where: { $0.name == .agreeeMarketingSMS })
        let nighttimePush = marketingPrivacy?.subContent.first(where: { $0.name == .agreeeNighttimePush })

        entity?.notificationPreference(marketingPrivacy: marketingPrivacy?.isSelected ?? false,
                                       marketingMail: marketingMail?.isSelected ?? false,
                                       marketingPush: marketingPush?.isSelected ?? false,
                                       marketingSms: marketingSms?.isSelected ?? false,
                                       nighttimePush: nighttimePush?.isSelected ?? false,
                                       completionHandler: { [weak self] result in
            guard let `self` = self else { return }
            switch result {
            case .success:
                self.presenter?.sendTermSuccessfully()
            case .failure:
                self.presenter?.handerApiError()
            }
        })
    }
    
    func changeStateTerms(term: Terms) {
        guard term.name != .all else {
            selectedAllTerms(isSelected: term.isSelected)
            return
        }
        guard let firstIndex = listTerms.firstIndex(where: { term.name == $0.name }) else { return }
        listTerms[firstIndex].isSelected = !listTerms[firstIndex].isSelected
        
        if !listTerms[firstIndex].isSelected {
            listTerms[firstIndex].subContent.enumerated().forEach { (index, _) in
                listTerms[firstIndex].subContent[index].isSelected = false
            }
        }
        checkSelectedAll()
        presenter?.termsListDidFetch()
    }
    
    func changeStateSubTerms(indexPath: IndexPath) {
        guard listTerms[indexPath.section].isSelected else { return }
        let isSelected = listTerms[indexPath.section].subContent[indexPath.row].isSelected
        listTerms[indexPath.section].subContent[indexPath.row].isSelected = !isSelected
        checkSelectedAll()
        presenter?.termsListDidFetch()
    }
    
    private func selectedAllTerms(isSelected: Bool) {
        listTerms.enumerated().forEach { (indexSection, _) in
            listTerms[indexSection].isSelected = !isSelected
            listTerms[indexSection].subContent.enumerated().forEach { (index, _) in
                listTerms[indexSection].subContent[index].isSelected = !isSelected
            }
        }
        presenter?.termsListDidFetch()
    }
    
    private func checkSelectedAll() {
        var isSelected: Bool = true
        let data = listTerms.filter { $0.name != .all }
        if data.map({ $0.isSelected }).contains(false) {
            isSelected = false
        }
        data.filter { $0.subContent.count > 0 }.forEach { term in
            if term.subContent.map({ $0.isSelected }).contains(false) {
                isSelected = false
            }
        }
        guard let firstIndex = listTerms.firstIndex(where: { .all == $0.name }) else { return }
        listTerms[firstIndex].isSelected = isSelected
    }
}
