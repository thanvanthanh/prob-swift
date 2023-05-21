//
//  RuntimeConfigService.swift
//  Probit
//
//  Created by Bradley Hoang on 27/10/2022.
//

import Foundation

enum AppState {
    case normal
    case forceUpdate
    case maintenance
}

final class RuntimeConfigService {
    struct Constant {
        static let countdownTime: TimeInterval = 60
    }
    
    // MARK: - Private Variable
    private var timer: Timer?
    
    // MARK: - Public Variable
    private(set) var currentState: AppState = .normal
    private(set) var needGetConfigData: Bool = true
    
    // MARK: - Lifecycle
    static let shared = RuntimeConfigService()
    
    deinit {
        destroyTimer()
    }
}

// MARK: - Public
extension RuntimeConfigService {
    func startTimer() {
        destroyTimer()
        
        timer = Timer.scheduledTimer(timeInterval: Constant.countdownTime, target: self, selector: #selector(getRuntimeConfig), userInfo: nil, repeats: true)
        getRuntimeConfig()
    }
    
    func destroyTimer() {
        timer?.invalidate()
        timer = nil
    }
}

// MARK: - Private
private extension RuntimeConfigService {
    @objc func getRuntimeConfig() {
        guard needGetConfigData else { return }
        
        SettingAPI.shared.getRuntimeConfig { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let runtimeConfig):
                AppConstant.latestRuntimeConfig = runtimeConfig
                if runtimeConfig.appUnderMaintenance {
                    if self.currentState == .maintenance { return }
                    self.currentState = .maintenance
                    self.needGetConfigData = true
                    MaintenanceRouter().setupRootView(with: runtimeConfig)
                    return
                }
                if self.isNeedForceUpdate() {
                    if self.currentState == .forceUpdate { return }
                    self.currentState = .forceUpdate
                    self.needGetConfigData = false
                    UpdateVersionRouter().setupRootView()
                    return
                }
                if self.currentState == .normal { return }
                self.currentState = .normal
                self.needGetConfigData = true
                AppDelegate.shared.setRootScreen()
                
            case .failure:
                break
            }
        }
    }
    
    func isNeedForceUpdate() -> Bool {
        let minimumBuild = AppConstant.latestRuntimeConfig?.appForceUpdateVersion
        let currentBuild = Bundle.main.buildVersionNumber ?? "1"
                
        return (Int(currentBuild) ?? 0) < (minimumBuild ?? 0)
    }
}
