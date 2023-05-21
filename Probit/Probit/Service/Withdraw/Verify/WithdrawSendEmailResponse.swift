//
//  WithdrawSendEmail.swift
//  Probit
//
//  Created by Dang Nguyen on 03/11/2022.
//

import Foundation

struct WithdrawSendEmailResponse: Codable {
    var success: Bool?

    enum CodingKeys: String, CodingKey {
        case success
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        success = try container.decode(Bool.self, forKey: .success)
    }
}
