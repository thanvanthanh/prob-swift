//
//  TFAModel.swift
//  Probit
//
//  Created by Sotatek on 28/12/2022.
//

import Foundation

struct TFAWithdrawParameter: Codable {
    let purpose: String
    let u2f: U2FCredential
    let sessId: String
    
    init(purpose: String,
         sessId: String,
         rawId: String,
         authenticatorData: String,
         signature: String,
         userHandle: String,
         clientDataJSON: String) {
        self.purpose = purpose
        self.sessId = sessId
        self.u2f = U2FCredential(rawId: rawId,
                                 authenticatorData: authenticatorData,
                                 signature: signature,
                                 userHandle: userHandle,
                                 clientDataJSON: clientDataJSON)
    }
    
    var toDictionary: [String: Any] {
        return self.asDictionary ?? [:]
    }
}

struct U2FCredential: Codable {
    
    let rawId: String
    let response: WebAuthnCredentialResponse
    let type: String
    let id: String
    
    init(rawId: String,
         authenticatorData: String,
         signature: String,
         userHandle: String,
         clientDataJSON: String) {
        self.rawId = rawId
        self.id = rawId
        self.type = "public-key"
        self.response = WebAuthnCredentialResponse(
            authenticatorData: authenticatorData,
            signature: signature,
            userHandle: userHandle,
            clientDataJSON: clientDataJSON)
    }
    
}

struct TFALoginParameter: Codable {
    let clientId: String = "probit-login"
    var deviceId: String = AppConstant.deviceUUID
    var grantType: String = "password"
    let username: String
    let password: String
    let recaptcha: String?
    let keyHandle: String?
    let webAuthnCredential: WebAuthnCredential?
    let version: String?
    let signatureData: String?
    let challengeId: String?
    
    enum CodingKeys: String, CodingKey {
        case clientId = "client_id"
        case deviceId = "device_id"
        case grantType = "grant_type"
        case recaptcha = "g-recaptcha-entv1-response"
        case password, username, webAuthnCredential
        case keyHandle = "key_handle"
        case challengeId = "challenge_id"
        case signatureData = "signature_data"
        case version
    }
    
    var toDictionary: [String: Any] {
        return self.asDictionary ?? [:]
    }
    
}

struct WebAuthnCredential: Codable {
    let id: String
    let response: WebAuthnCredentialResponse
    let type: String
    
    init(_ id: String,
         authenticatorData: String,
         signature: String,
         userHandle: String,
         clientDataJSON: String) {
        self.id = id
        self.type = "public-key"
        self.response = WebAuthnCredentialResponse(authenticatorData: authenticatorData,
                                                   signature: signature,
                                                   userHandle: userHandle,
                                                   clientDataJSON: clientDataJSON)
    }
}

struct WebAuthnCredentialResponse: Codable {
    let authenticatorData: String
    let signature: String
    let userHandle: String
    let clientDataJSON: String
}

