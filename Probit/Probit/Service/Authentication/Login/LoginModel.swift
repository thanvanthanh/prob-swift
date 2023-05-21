//
//  LoginModel.swift
//  Probit
//
//  Created by Beacon on 05/09/2022.
//

import Foundation

struct LoginModel: Codable {
    let email: Bool?
    let totp: Bool?
    let accessToken: String?
    let tokenType: String?
    let expiresIn: Int?
    let refreshToken: String?
    var fido: FidoModel?

    enum CodingKeys: String, CodingKey {
        case email
        case totp
        case accessToken = "access_token"
        case tokenType = "token_type"
        case expiresIn = "expires_in"
        case refreshToken = "refresh_token"
        case fido = "fido"
    }
}

// MARK: - Fido
struct FidoModel: Codable {
    var challenge: FidoChallenge?
    var keyHandles: [KeyHandle]?

    enum CodingKeys: String, CodingKey {
        case challenge
        case keyHandles = "key_handles"
    }
}

// MARK: - FidoChallenge
struct FidoChallenge: Codable {
    var challengeID, userID: String?
    var challenge: ChallengeChallenge?
    var appID: String?
    var challengeExpire: Int?
    var authCredential: AuthCredential?

    enum CodingKeys: String, CodingKey {
        case challengeID = "challenge_id"
        case userID = "user_id"
        case challenge
        case appID = "app_id"
        case challengeExpire, authCredential
    }
}

// MARK: - AllowCredential
struct AllowCredential: Codable {
    var type, id: String?
    var transports: [String]?
}

// MARK: - ChallengeChallenge
struct ChallengeChallenge: Codable {
    var version: String?
    var appID: String?
    var challenge: String?

    enum CodingKeys: String, CodingKey {
        case version
        case appID = "appId"
        case challenge
    }
}

// MARK: - KeyHandle
struct KeyHandle: Codable {
    var version, keyHandle: String?
    var publicKey: String?
//    var publicKey: FidoPublicKey?
}

struct FidoPublicKey: Codable {
    var fmt: String?
    var publicKey: String?
    var counter: Int?
    var credID: String?
}

struct AuthCredential: Codable {
    
    var challenge, rpID, userVerification: String?
    
    var timeout: Int?
    
    var allowCredentials: [AllowCredential]?
    
    var extensions: Extensions?

    enum CodingKeys: String, CodingKey {
        case challenge
        case rpID = "rpId"
        case userVerification, timeout, allowCredentials, extensions
    }
    
    var origin: String? {
        guard let rpID = rpID else {
            return nil
        }
        return rpID.hasPrefix("http") ? rpID : ("https://" + rpID)
    }
}

struct Extensions: Codable {
    var appid: String?
}
