//
//  AppSettingLanguagePresenter.swift
//  Probit
//
//  Created by Thân Văn Thanh on 31/08/2022.
//  
//

import Foundation

class AppSettingLanguagePresenter: ViewToPresenterAppSettingLanguageProtocol {
    
    
    // MARK: Properties
    var view: PresenterToViewAppSettingLanguageProtocol?
    var interactor: PresenterToInteractorAppSettingLanguageProtocol?
    var router: PresenterToRouterAppSettingLanguageProtocol?
    var languageAppSetting: [Language] {
        interactor?.languageAppSetting ?? []
    }
    
    func getListLanguage() {
        interactor?.getData()
    }
    
    func changeLanguage(indexPath: IndexPath) {
        interactor?.changeLanguage(indexPath: indexPath)
    }
}

extension AppSettingLanguagePresenter: InteractorToPresenterAppSettingLanguageProtocol {
    
    func dataListDidFetch() {
        view?.reloadData()
    }
    
}
