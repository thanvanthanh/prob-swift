//
//  AppConstant.swift
//  Earable
//
//  Created by Nguyen Quoc Tung on 5/25/20.
//  Copyright © 2020 Earable. All rights reserved.
//

import UIKit
//import FirebaseMessaging

struct AppConstant {
    
    static var timeRequest: Double { return 10 }
    
    static var locale: String {
        get { UserDefaults.standard.value(forKey: "locale-setting") as? String ?? "en-us" }
        set { UserDefaults.standard.setValue(newValue, forKey: "locale-setting") }
    }
    
    static var localeId: String {
        get {
            let langIds = Bundle.main.localizations.filter({$0 != "en" && $0 != "vi"})
            let currentShortId = Locale.current.languageCode ?? "en-us"
            let currentId = langIds.first(where: {$0.hasPrefix(currentShortId)}) ?? "en-us"
            return UserDefaults.standard.value(forKey: "selected_language") as? String ?? currentId
        }
        set { UserDefaults.standard.setValue(newValue, forKey: "selected_language") }
    }
    
    static var accessToken: String? {
        get { UserDefaults.standard.value(forKey: "access-token") as? String }
        set {
            if newValue == nil {
                UserDefaults.standard.removeObject(forKey: "access-token")
                UserDefaults.standard.synchronize()
            } else {
                UserDefaults.standard.setValue(newValue, forKey: "access-token")
            }
        }
    }
    
    static var pushToken: String? {
        get { return UserDefaults.standard.value(forKey: "pushToken") as? String }
        set {
            UserDefaults.standard.setValue(newValue, forKey: "pushToken")
            UserDefaults.standard.synchronize()
        }
    }
    
    static var profileInfo: ProfileInfo? {
        get {
            guard let data = UserDefaults.standard.value(forKey: "profile-info") as? Data,
                  let profileInfo = try? PropertyListDecoder().decode(ProfileInfo.self, from: data) else { return nil }
            return profileInfo
        }
        set {
            guard let data = try? PropertyListEncoder().encode(newValue) else { return }
            UserDefaults.standard.setValue(data, forKey: "profile-info")
        }
    }
    
    static var phoneNumber: PrimaryphoneModel? {
        get { UserDefaults.standard.object(PrimaryphoneModel.self, with: "phone-number") }
        set { UserDefaults.standard.set(object: newValue, forKey: "phone-number") }
    }
    
    static var lastEmail: String? {
        get {
            guard let lastEmail = UserDefaults.standard.string(forKey: "last_email") else { return nil }
            return lastEmail
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: "last_email")
        }
    }
    
    static var countFailPin: Int {
        get { UserDefaults.standard.value(forKey: "countFailPin") as? Int ?? 0 }
        set { UserDefaults.standard.setValue(newValue, forKey: "countFailPin") }
    }
    

    static var tokenType: String? {
        get { UserDefaults.standard.value(forKey: "token-type") as? String }
        set { UserDefaults.standard.setValue(newValue, forKey: "token-type") }
    }
    
    static var refreshToken: String? {
        get { UserDefaults.standard.value(forKey: "refresh-token") as? String }
        set {
            if newValue == nil {
                UserDefaults.standard.removeObject(forKey: "refresh-token")
                UserDefaults.standard.synchronize()
            } else {
                UserDefaults.standard.setValue(newValue, forKey: "refresh-token")
            }
        }
    }
    
    static var isClearWaletData: Bool {
        get { UserDefaults.standard.bool(forKey: "is-clear-walet-data") }
        set { UserDefaults.standard.set(newValue, forKey: "is-clear-walet-data") }
    }
    
    static var currencies: [WalletCurrency] = [WalletCurrency]()
    
    static var deviceUUID: String {
        get {
            return KeychainService.shared.loadString(key: "deviceUUID")
        }
        
        set {
            _ = KeychainService.shared.saveString(key: "deviceUUID", string: newValue)
        }
    }
    static var isBiometrics: BiometricType {
        get {
            return BiometricType.initValue(rawValue: UserDefaults.standard.string(forKey: "is-biometrics") ?? "")
        }
        set { UserDefaults.standard.set(newValue.rawValue, forKey: "is-biometrics") }
    }
    
    static var isDisableInputPin: Bool {
        get { UserDefaults.standard.bool(forKey: "isDisableInputPin") }
        set { UserDefaults.standard.set(newValue, forKey: "isDisableInputPin") }
    }
    
    static var isAppLock: Bool { !pinLock.isNilOrEmpty }
    
    static var pinLock: String? {
        get { UserDefaults.standard.value(forKey: "pinLock") as? String }
        set { UserDefaults.standard.setValue(newValue, forKey: "pinLock") }
    }
    
    static var isAuthorization: Bool {
        accessToken != nil
    }

    static var showBalance: Bool {
        get { UserDefaults.standard.bool(forKey: "show-balance")}
        set { UserDefaults.standard.set(newValue, forKey: "show-balance") }
    }

    static var showIntroDevice: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "showIntroDevice")
        }
        
        set {
            UserDefaults.standard.setValue(newValue, forKey: "showIntroDevice")
        }
    }
    
    static var exchangeSortType: ExchangeSortType {
        get { UserDefaults.standard.object(ExchangeSortType.self, with: "exchangeSortType") ?? .vol }
        set { UserDefaults.standard.set(object: newValue, forKey: "exchangeSortType") }
    }
    
    static var listCoinFavorites: [String] {
        get { UserDefaults.standard.object([String].self, with: "listCoinFavorites") ?? [] }
        set { UserDefaults.standard.set(object: newValue, forKey: "listCoinFavorites") }
    }

    static var tickerColor: TickerColor {
        get { UserDefaults.standard.object(TickerColor.self, with: "tickerColor") ?? .option1 }
        set { UserDefaults.standard.set(object: newValue, forKey: "tickerColor") }
    }
    
    struct Link {
        static let homePage = "\(Constant.Server.baseAPIURL)\(AppConstant.localeId.lowercased())"
        static let ieo = "\(Constant.Server.baseAPIURL)\(AppConstant.localeId.lowercased())/webview/ieo"
        static let exclusive = "\(Constant.Server.baseAPIURL)\(AppConstant.localeId.lowercased())/webview/exclusive"
        static let helpEmail = "https://www.probit.com/\((AppConstant.localeId.lowercased()))/webview/hc/360032597191"

        static let announcements = "\(Constant.Server.baseAPIURL)\(AppConstant.localeId.lowercased())/webview/hc/announcements"
        static let autoHold = "\(Constant.Server.baseAPIURL)\(AppConstant.localeId.lowercased())/webview/auto-hold"
        static let faq = "\(Constant.Server.baseAPIURL)\(AppConstant.localeId.lowercased())/webview/hc/faq"
        static let contactUs = "https://cs.probit.com/hc/\(AppConstant.localeId.lowercased())/webview/requests/new"
        static let airdrops = "\(Constant.Server.baseAPIURL)\(AppConstant.localeId.lowercased())/webview/events"
        
        static let articleLink = "\(Constant.Server.baseAPIURL)\(AppConstant.localeId.lowercased())/webview/hc/%@"
        static let articleExclusiveLink = "\(Constant.Server.baseAPIURL)\(AppConstant.localeId.lowercased())/webview/exclusive/%@"
        static let articleIEOLink = "\(Constant.Server.baseAPIURL)\(AppConstant.localeId.lowercased())/webview/ieo/%@/%@"
        static let tradingFee = "\(Constant.Server.baseAPIURL)\(AppConstant.localeId.lowercased())/webview/trading-fee"
        
        static let privacy = "\(Constant.Server.baseAPIURL)\(AppConstant.localeId.lowercased())/webview/privacy"
        static let termsOfService = "\(Constant.Server.baseAPIURL)\(AppConstant.localeId.lowercased())/webview/tos"
        static let appStoreLink = "itms-apps://itunes.apple.com/app/probit-global/id1621264266"
        static let memberShip =  "\(Constant.Server.baseAPIURL)\(AppConstant.localeId.lowercased())/webview/hc/360040593411"
        static let seeDetailsCompetition = "\(Constant.Server.baseAPIURL)/webview/%@/hc/360039482652-New-changes-regarding-trading-competition-ranking-calculation"
    }

    static var isLogin: Bool {
        return (accessToken != nil)
    }
    
    static var latestRuntimeConfig: RuntimeConfig? {
        get {
            UserDefaults.standard.object(RuntimeConfig.self, with: "latest_runtime_config")
        }
        set {
            UserDefaults.standard.set(object: newValue, forKey: "latest_runtime_config")
        }
    }
    
    static var isLanguageRightToLeft: Bool {
        return ["he-IL", "ur-Arab-IN", "ar-EG", "fa-IR"].contains(where: {localeId.contains($0)})
    }
    
    static var appVersion: String {
        guard let releaseVersion = Bundle.main.releaseVersionNumber else { return ""}
        let buildVersion = Bundle.main.buildVersionNumber
        return "\(releaseVersion)(\(buildVersion ?? "1"))"
    }
    
    static var osVersion: String {
        let version = UIDevice.current.systemVersion
        return version
    }
    
    static var screenScale: String {
        return "1.0"
    }
    
    static var userAgent: String {
        return "Probit/\(AppConstant.appVersion)(iPhone; iOS \(AppConstant.osVersion); Scale/\(AppConstant.screenScale); AppVersion/Full)"
    }
    
    // authorizationHeader
    static var authorizationHeader: [String:String]? {
        guard let accessToken = AppConstant.accessToken else { return nil }
        return ["Authorization":"Bearer \(accessToken)"]
    }
}

extension AppConstant {
    
    static func logout() {
        UserDefaults.standard.removeObject(forKey: "access-token")
        UserDefaults.standard.removeObject(forKey: "pinLock")
        UserDefaults.standard.removeObject(forKey: "is-biometrics")
        UserDefaults.standard.removeObject(forKey: "profile-info")
        refreshToken = nil
        accessToken = nil
        pinLock = nil
        isBiometrics = .none
        profileInfo = nil
        phoneNumber = nil
        countFailPin = 0
        isDisableInputPin = false
        AppDelegate.shared.deleteToken()
        isClearWaletData = true
    }
    
    static func disablePinLock(){
        isBiometrics = .none
        pinLock = nil
    }
}

extension UserDefaults {
    func object<T: Codable>(_ type: T.Type, with key: String, usingDecoder decoder: JSONDecoder = JSONDecoder()) -> T? {
        guard let data = self.value(forKey: key) as? Data else { return nil }
        return try? decoder.decode(type.self, from: data)
    }

    func set<T: Codable>(object: T, forKey key: String, usingEncoder encoder: JSONEncoder = JSONEncoder()) {
        let data = try? encoder.encode(object)
        self.set(data, forKey: key)
    }
}


extension AppConstant {
    static var formatDate: String {
        get {
            return "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        }
    }
    
    static var formatDate1: String {
        get {
            return "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        }
    }
}
