//
//  KycPersonalInfoInputEntity.swift
//  Probit
//
//  Created by Bradley Hoang on 08/11/2022.
//

import Foundation

enum GenderType: String {
    case male = "male"
    case female = "female"
    static func initValue(_ value: String) -> GenderType{
        if value == male.rawValue {
            return .male
        }
        return .female
    }
}
