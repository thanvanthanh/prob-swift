//
//  ConfirmPaymentEntity.swift
//  Probit
//
//  Created by Thân Văn Thanh on 26/08/2022.
//

import Foundation

struct PaymentInfo {
    var title: String
    var amount: String
    var image: String
    var type: ConfirmPaymentType
}

enum ConfirmPaymentType {
    case provider
    case spend
    case price
}
