//
//  TermsContract.swift
//  Probit
//
//  Created by Nguyen Quang on 22/08/2022.
//  
//

import Foundation

// MARK: View Output (Presenter -> View)
protocol PresenterToViewTermsProtocol: BaseViewProtocol {
    func reloadData()
    func setEnableNextButton(_ enable: Bool)
}


// MARK: View Input (View -> Presenter)
protocol ViewToPresenterTermsProtocol {
    var view: PresenterToViewTermsProtocol? { get set }
    var interactor: PresenterToInteractorTermsProtocol? { get set }
    var router: PresenterToRouterTermsProtocol? { get set }

    var screenFrom: AuthScreenFrom { get }
    var listTerms: [Terms] { get }
    func viewDidLoad()
    func changeStateTerms(term: Terms)
    func changeStateSubTerms(indexPath: IndexPath)
    func nextScreen()
    func navigateToWebView(url: String)
    func notificationPreference()
}

// MARK: Interactor Input (Presenter -> Interactor)
protocol PresenterToInteractorTermsProtocol {
    var presenter: InteractorToPresenterTermsProtocol? { get set }
    var entity: InteractorToEntityTermsProtocol? { get set }
    var listTerms: [Terms] { get set }
    var screenFrom: AuthScreenFrom { get set }
    func getTerms()
    func changeStateTerms(term: Terms)
    func changeStateSubTerms(indexPath: IndexPath)
    func notificationPreference()
}

// MARK: Interactor Output (Interactor -> Presenter)
protocol InteractorToPresenterTermsProtocol {
    func termsListDidFetch()
    func sendTermSuccessfully()
    func handerApiError()
}


// MARK: Router Input (Presenter -> Router)
protocol PresenterToRouterTermsProtocol {
    func nextScreen(screenFrom: AuthScreenFrom, agreements: Agreements?)
    func navigateToWebView(url: String)
}

protocol InteractorToEntityTermsProtocol {
    func notificationPreference(marketingPrivacy: Bool,
                                marketingMail: Bool,
                                marketingPush: Bool,
                                marketingSms: Bool,
                                nighttimePush: Bool,
                                completionHandler: @escaping (Result<NotificationPreferenceResponse, ServiceError>) -> Void)
}
