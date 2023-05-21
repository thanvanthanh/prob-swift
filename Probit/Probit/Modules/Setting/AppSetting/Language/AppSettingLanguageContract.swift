//
//  AppSettingLanguageContract.swift
//  Probit
//
//  Created by Thân Văn Thanh on 31/08/2022.
//  
//

import Foundation


// MARK: View Output (Presenter -> View)
protocol PresenterToViewAppSettingLanguageProtocol {
   func reloadData()
}


// MARK: View Input (View -> Presenter)
protocol ViewToPresenterAppSettingLanguageProtocol {
    
    var view: PresenterToViewAppSettingLanguageProtocol? { get set }
    var interactor: PresenterToInteractorAppSettingLanguageProtocol? { get set }
    var router: PresenterToRouterAppSettingLanguageProtocol? { get set }
    var languageAppSetting: [Language] { get }
    func getListLanguage()
    func changeLanguage(indexPath: IndexPath)
}


// MARK: Interactor Input (Presenter -> Interactor)
protocol PresenterToInteractorAppSettingLanguageProtocol {
    
    var presenter: InteractorToPresenterAppSettingLanguageProtocol? { get set }
    var languageAppSetting: [Language] { get set }
    func getData()
    func changeLanguage(indexPath: IndexPath)
}


// MARK: Interactor Output (Interactor -> Presenter)
protocol InteractorToPresenterAppSettingLanguageProtocol {
    func dataListDidFetch()
}


// MARK: Router Input (Presenter -> Router)
protocol PresenterToRouterAppSettingLanguageProtocol {
    
}
