//
//  TickerColorEntity.swift
//  Probit
//
//  Created by Thân Văn Thanh on 31/08/2022.
//

import Foundation
import UIKit

enum TickerColor: Codable {
    case option1
    case option2
    
    var imageBuy: String {
        switch self {
        case .option1:
            return "ico_arrow_up"
        case .option2:
            return "ico_arrow_up_red"
        }
    }
    
    var imageSell: String {
        switch self {
        case .option1:
            return "ico_arrow_down"
        case .option2:
            return "ico_arrow_down_blue"
        }
    }
}
