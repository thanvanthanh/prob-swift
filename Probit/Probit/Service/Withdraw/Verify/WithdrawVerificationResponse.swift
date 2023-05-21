//
//  WithdrawVerificationResponse.swift
//  Probit
//
//  Created by Dang Nguyen on 03/11/2022.
//

import Foundation

enum WithdrawVerificationArgument {
    case login(WithdrawLoginParameter)
    
    case withdraw(WithDrawParameter)
    
    
    var withDrawlRequest: WithDrawParameter? {
        switch self {
        case .login:
            return nil
        case .withdraw(let data):
            return data
        }
    }
}

struct WithdrawLoginParameter {
    let username: String
    let password: String
    let fido: FidoModel
}

struct WithDrawParameter {
    let withdrawlRequest: WithdrawRequest?
    let u2fRequest: TFAU2FRequest
    let purpose: String
    let sessId: String
    let userId: String
}

struct WithdrawVerificationResponse: Codable {
    var success: Bool?
    var state: TFAState?
    var u2fRequest: TFAU2FRequest?
    enum CodingKeys: String, CodingKey {
        case success
        case state
        case u2fRequest
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        success = try container.decode(Bool.self, forKey: .success)
        if let state = try container.decodeIfPresent(TFAState.self, forKey: .state) {
            self.state = state
        }
        
        if let u2fRequest = try container.decodeIfPresent(TFAU2FRequest.self, forKey: .u2fRequest) {
            self.u2fRequest = u2fRequest
        }
    }
}

struct TFAU2FRequest: Codable {
    var authCredential: AuthCredential?
}

struct TFAState: Codable {
    var userId: String
    var policy: TFAStatePolicy?
    var sessId: String?
    var status: String?
    var startTs: Double?
    var expireTs: Double?
    var endTs: Int?
    var methodStates: [methodState]?
    var metadata: TFAMetaData?
    
    enum CodingKeys: String, CodingKey {
        case userId, policy, sessId, status, startTs, expireTs, endTs, methodStates, metadata
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        userId = try container.decode(String.self, forKey: .userId)
        policy = try container.decode(TFAStatePolicy.self, forKey: .policy)
        metadata = try container.decode(TFAMetaData.self, forKey: .metadata)
        sessId = try container.decode(String.self, forKey: .sessId)
        status = try container.decode(String.self, forKey: .status)
        startTs = try container.decode(Double.self, forKey: .startTs)
        expireTs = try container.decode(Double.self, forKey: .expireTs)
        methodStates = try container.decode([methodState].self, forKey: .methodStates)
        if let endTs =  try container.decodeIfPresent(Int.self, forKey: .endTs) {
            self.endTs = endTs
        } else {
            self.endTs = 0
        }
    }
}

struct TFAMetaData: Codable {
    var purpose: String?
    
    enum CodingKeys: String, CodingKey {
        case purpose
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        purpose = try container.decode(String.self, forKey: .purpose)
    }
    
}

struct TFAStatePolicy: Codable {
    var ver: Int?
    var op: String?
    var methods: [String]?
    
    enum CodingKeys: String, CodingKey {
        case ver, op, methods
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        ver = try container.decode(Int.self, forKey: .ver)
        op = try container.decode(String.self, forKey: .op)
        methods = try container.decode([String].self, forKey: .methods)
    }
}

struct methodState: Codable {
    var keyId: String?
    var method: String?
    var status: String?
    
    enum CodingKeys: String, CodingKey {
        case keyId, method, status
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        method = try container.decode(String.self, forKey: .method)
        status = try container.decode(String.self, forKey: .status)
        if let keyId =  try container.decodeIfPresent(String.self, forKey: .keyId) {
            self.keyId = keyId
        }
    }
}
