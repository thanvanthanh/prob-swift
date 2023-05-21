//
//  SignUpModel.swift
//  Probit
//
//  Created by Nguyen Quang on 05/09/2022.
//

import Foundation

struct SignUpModel: Codable {
    let data: String
}

struct ReCaptchaModel: Codable {
    let captcha: Bool
    let captchaType: String
}

struct Agreements: Codable {
    let marketing_privacy: Bool
    let marketing_mail: Bool
    let marketing_sms: Bool
}
