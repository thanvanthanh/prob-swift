//
//  Configs.swift
//  Probit
//
//  Created by Thân Văn Thanh on 21/11/2022.
//

import Foundation

final class Configs {
    
    static let share = Configs()
    
    private init() {}
    
    var env: Enviroment {
        #if ENDPOINT_DEBUG
        return .production
        #elseif ENDPOINT_RELEASE
        return .production
        #endif
    }
}
