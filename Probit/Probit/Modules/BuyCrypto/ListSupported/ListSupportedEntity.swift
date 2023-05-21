//
//  ListSupportedEntity.swift
//  Probit
//
//  Created by Thân Văn Thanh on 24/08/2022.
//

import Foundation

struct ListSupported {
    var name: String?
    var subName: String?
    var isSeclecType: Bool?
    var type: CryptoType?
}

enum CryptoType {
    case crypto
    case fiat
}
