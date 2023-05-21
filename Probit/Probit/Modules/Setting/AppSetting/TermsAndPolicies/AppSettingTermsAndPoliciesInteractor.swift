//
//  AppSettingTermsAndPoliciesInteractor.swift
//  Probit
//
//  Created by Thân Văn Thanh on 31/08/2022.
//  
//

import Foundation

class AppSettingTermsAndPoliciesInteractor: PresenterToInteractorAppSettingTermsAndPoliciesProtocol {
    
    // MARK: Properties
    var presenter: InteractorToPresenterAppSettingTermsAndPoliciesProtocol?
    var entity: InteractorToEntityAppSettingTermsAndPoliciesProtocol?
    var listTermsSetting: [TermsAndPolicies] = []
    
    func getTermsSetting() {
       let marketingPrivacy = AppConstant.profileInfo?.marketingPrivacy
       let email = AppConstant.profileInfo?.subscriptions?.marketingMail
       let sms = AppConstant.profileInfo?.subscriptions?.marketingSms
       let pushNoti = AppConstant.profileInfo?.subscriptions?.marketingPush
       let nightTime = AppConstant.profileInfo?.subscriptions?.nighttimePush
        let dataLogin: [TermsAndPolicies] = [
            TermsAndPolicies(title: .persional,
                             model: [
                                TermSetting(name: .personalInfo,
                                            hintitle: .personalInfo,
                                            buttonTitle: .personalInfo,
                                            isSwitch: marketingPrivacy ?? false,
                                            isEnableSwitch: true)]),
            TermsAndPolicies(title: .notification,
                             model: [
                                TermSetting(name: .email,
                                            hintitle: .email,
                                            buttonTitle: .email,
                                            isSwitch: email ?? false,
                                            isEnableSwitch: marketingPrivacy ?? false),
                                
                                TermSetting(name: .sms,
                                            hintitle: .sms,
                                            buttonTitle: .sms,
                                            isSwitch: sms ?? false,
                                            isEnableSwitch: marketingPrivacy ?? false),
                                
                                TermSetting(name: .pushNoti,
                                            hintitle: .pushNoti,
                                            buttonTitle: .pushNoti,
                                            isSwitch: pushNoti ?? false,
                                            isEnableSwitch: marketingPrivacy ?? false),
                                
                                TermSetting(name: .nightTime,
                                            hintitle: .nightTime,
                                            buttonTitle: .nightTime,
                                            isSwitch: nightTime ?? false,
                                            isEnableSwitch: marketingPrivacy ?? false)
                             ]),
            TermsAndPolicies(title: .privacy),
            TermsAndPolicies(title: .terms),
            TermsAndPolicies(title: .thirdParty)
        ]
        
        let dataLogout: [TermsAndPolicies] = [TermsAndPolicies(title: .privacy),
                                              TermsAndPolicies(title: .terms),
                                              TermsAndPolicies(title: .thirdParty)]
        self.listTermsSetting = AppConstant.isLogin ? dataLogin : dataLogout
        presenter?.termsSettingListDidFetch()
    }
    
    func changeStateTerms(term: TermSetting) {
        if term.isEnableSwitch {
            postNotificationPreference(terms: term)
        } else {
            handleErrorMessage(term)
            presenter?.termsSettingListDidFetch()
        }
    }
    
    private func postNotificationPreference(terms: TermSetting) {
        
        entity?.notificationPreference(terms: terms,
                                       completionHandler: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let success):
                print(success)
                self.saveData(res: success)
                self.updateData(terms)
                self.handleSuccessMessage(terms)
            case .failure(let failure):
                print(failure)
            }
            self.presenter?.termsSettingListDidFetch()
        })
    }
    
    private func saveData(res: NotificationPreferenceResponse) {
        if let marketingPrivacy = res.data.marketingPrivacy {
            AppConstant.profileInfo?.marketingPrivacy = marketingPrivacy
        }
        if let marketingMail = res.data.marketingMail {
            AppConstant.profileInfo?.subscriptions?.marketingMail = marketingMail
        }
        if let marketingSms = res.data.marketingSms {
            AppConstant.profileInfo?.subscriptions?.marketingSms = marketingSms
        }
        if let marketingPush = res.data.marketingPush {
            AppConstant.profileInfo?.subscriptions?.marketingPush = marketingPush
        }
        if let nighttimePush = res.data.nighttimePush {
            AppConstant.profileInfo?.subscriptions?.nighttimePush = nighttimePush
        }
    }
    
    private func updateData(_ term: TermSetting) {
        switch term.name {
        case .personalInfo:
            listTermsSetting[0].model = [term]
            listTermsSetting[1].model = listTermsSetting[1].model.map({ termSetting -> TermSetting in
                var newTermSetting = termSetting
                newTermSetting.isSwitch = false
                newTermSetting.isEnableSwitch = term.isSwitch
                return newTermSetting
            })
        default:
            listTermsSetting[1].model = listTermsSetting[1].model.map({ termSetting -> TermSetting in
                if term.name == termSetting.name {
                    return term
                }
                return termSetting
            })
        }
    }
    
    private func handleErrorMessage(_ term: TermSetting) {
        switch term.name {
        case .personalInfo:
            break
        default:
            self.presenter?.showAlert(msg: term.name.errorMsg)
        }
    }
    
    private func handleSuccessMessage(_ term: TermSetting) {
        switch term.name {
        default:
            print(term.name.susscessMsg)
        }
    }
    
}
