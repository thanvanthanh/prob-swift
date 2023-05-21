//
//  AppSettingLanguageInteractor.swift
//  Probit
//
//  Created by Thân Văn Thanh on 31/08/2022.
//  
//

import Foundation
import UIKit

class AppSettingLanguageInteractor: PresenterToInteractorAppSettingLanguageProtocol {
        
    // MARK: Properties
    var presenter: InteractorToPresenterAppSettingLanguageProtocol?
    
    var languageAppSetting: [Language] = []
    
    func getData() {
        let langIds = Bundle.main.localizations.filter({$0 != "fil-PH" && $0 != "vi" && $0 != "en" && $0 != "Base"})
        var languages = [Language]()
        for langId in langIds {
            let loc = Locale(identifier: langId)
            if let fullName = loc.localizedString(forIdentifier: langId),
               let normalName = fullName.components(separatedBy: " (").first,
               let name = normalName.components(separatedBy: "（").first {
                let object = Language(id: langId,
                                      name: name,
                                      isSelected: langId == AppConstant.localeId)
                languages.append(object)
            }
        }
        languageAppSetting = languages.sorted(by: {$0.name.lowercased() < $1.name.lowercased()})
        if let enIndex = languageAppSetting.firstIndex(where: {$0.id == "en-US"}) {
            languageAppSetting.rearrange(fromIndex: enIndex, toIndex: 0)
        }
    }
    
    func changeLanguage(indexPath: IndexPath) {
        let item = languageAppSetting[indexPath.item]
        AppConstant.localeId = item.id
        DispatchQueue.main.async(execute: {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            UIView.appearance().semanticContentAttribute = AppConstant.isLanguageRightToLeft ? .forceRightToLeft : .forceLeftToRight
            appDelegate.setRootScreen()
        })
    }
}
