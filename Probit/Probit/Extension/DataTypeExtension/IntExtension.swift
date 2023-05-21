//
//  IntExtension.swift
//  Probit
//
//  Created by Thân Văn Thanh on 22/08/2022.
//

import UIKit

extension Int {
    var toCountdown: String {
        let minutes = String(self / 60).count > 1 ? String(self / 60) : "0" + String(self / 60)
        let seconds = String(self % 60).count > 1 ? String(self % 60) : "0" + String(self % 60)
        return minutes + ":" + seconds
    }
    
    var toCountdownSeconds: String {
        let seconds = String(self % 60).count > 1 ? String(self % 60) : String(self % 60)
        return seconds + " " + "timedelta_seconds".Localizable()
    }
    
    func asString() -> String {
        return String(self)
    }
    
    var hourToString: String {
        if self < 24 {
            if self == 1 {
                return "\(self) " + "timedelta_hour".Localizable()
            } else {
                return "\(self) " + "timedelta_hours".Localizable()
            }
        } else if self == 24 {
            return "1 " + "timedelta_day".Localizable()
        } else {
            return "\(self/24) " + "timedelta_days".Localizable()
        }
    }
}
