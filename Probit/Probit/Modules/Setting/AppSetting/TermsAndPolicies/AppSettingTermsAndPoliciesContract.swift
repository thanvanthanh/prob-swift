//
//  AppSettingTermsAndPoliciesContract.swift
//  Probit
//
//  Created by Thân Văn Thanh on 31/08/2022.
//  
//

import Foundation


// MARK: View Output (Presenter -> View)
protocol PresenterToViewAppSettingTermsAndPoliciesProtocol {
   func reloadData()
}


// MARK: View Input (View -> Presenter)
protocol ViewToPresenterAppSettingTermsAndPoliciesProtocol {
    
    var view: PresenterToViewAppSettingTermsAndPoliciesProtocol? { get set }
    var interactor: PresenterToInteractorAppSettingTermsAndPoliciesProtocol? { get set }
    var router: PresenterToRouterAppSettingTermsAndPoliciesProtocol? { get set }
    
    var listTermsSetting: [TermsAndPolicies] { get }
    func changeStateTerms(term: TermSetting)
    func navigateToWebView(url: String)
    func headerAction(terms: TermsAndPolicies)
    func viewDidLoad()
    
}


// MARK: Interactor Input (Presenter -> Interactor)
protocol PresenterToInteractorAppSettingTermsAndPoliciesProtocol {
    
    var presenter: InteractorToPresenterAppSettingTermsAndPoliciesProtocol? { get set }
    var listTermsSetting: [TermsAndPolicies] { get set }
    var entity: InteractorToEntityAppSettingTermsAndPoliciesProtocol? { get set }
    func changeStateTerms(term: TermSetting)
    func getTermsSetting()
}


// MARK: Interactor Output (Interactor -> Presenter)
protocol InteractorToPresenterAppSettingTermsAndPoliciesProtocol {
    func termsSettingListDidFetch()
    func showAlert(msg: String)
}


// MARK: Router Input (Presenter -> Router)
protocol PresenterToRouterAppSettingTermsAndPoliciesProtocol {
    func showAlert(msg: String)
    func navigateToWebView(url: String)
    func headerAction(terms: TermsAndPolicies)
}


protocol InteractorToEntityAppSettingTermsAndPoliciesProtocol {
    func notificationPreference(terms: TermSetting,
                                completionHandler: @escaping (Result<NotificationPreferenceResponse, ServiceError>) -> Void)
}
