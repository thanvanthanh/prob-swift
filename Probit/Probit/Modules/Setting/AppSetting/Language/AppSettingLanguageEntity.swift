//
//  AppSettingLanguage.swift
//  Probit
//
//  Created by Thân Văn Thanh on 31/08/2022.
//

import Foundation

struct Language {
    var id: String
    var name: String
    var isSelected: Bool? = false
    
    static func == (lhs: Language, rhs: Language) -> Bool {
        return lhs.id == rhs.id
    }
}
