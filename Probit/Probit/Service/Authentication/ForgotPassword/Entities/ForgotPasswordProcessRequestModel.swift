//
//  ForgotPasswordProcessRequestModel.swift
//  Probit
//
//  Created by Bradley Hoang on 26/10/2022.
//

import Foundation

struct ForgotPasswordProcessRequestModel: Encodable {
    let email: String
    let password: String
    let confirmPassword: String
    let tfaSessionId: String?
    let service: String
    
    enum CodingKeys: String, CodingKey {
        case email
        case password
        case confirmPassword = "password_confirm"
        case tfaSessionId = "tfa_session_id"
        case service
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(email, forKey: .email)
        try container.encode(password, forKey: .password)
        try container.encode(confirmPassword, forKey: .confirmPassword)
        try container.encode(tfaSessionId, forKey: .tfaSessionId)
        try container.encode(service, forKey: .service)
    }
}
