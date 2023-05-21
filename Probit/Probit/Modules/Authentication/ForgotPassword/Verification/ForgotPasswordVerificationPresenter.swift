//
//  ForgotPasswordVerificationPresenter.swift
//  Probit
//
//  Created by Thân Văn Thanh on 05/09/2022.
//  
//

import Foundation
import UIKit

class ForgotPasswordVerificationPresenter: ViewToPresenterForgotPasswordVerificationProtocol {
    
    struct Constant {
        static let resendTime = 60
        static let sessionExpiredTime = 60 * 10 // 10 mins
    }
    
    // MARK: - Private Variable
    private var resendTimer: Timer?
    private var resendTime = Constant.resendTime
    private var sessionExpiredTimer: Timer?
    private var sessionExpiredTime = Constant.sessionExpiredTime
    private var exitTime : Date?
    
    // MARK: Properties
    weak var view: PresenterToViewForgotPasswordVerificationProtocol?
    var interactor: PresenterToInteractorForgotPasswordVerificationProtocol?
    var router: PresenterToRouterForgotPasswordVerificationProtocol?
    
    var email: String? { interactor?.email }
    
    func startTimer() {
        resendTimer = Timer.scheduledTimer(timeInterval: 1,
                                           target: self,
                                           selector: #selector(updateResendTime),
                                           userInfo: nil,
                                           repeats: true)
        sessionExpiredTimer = Timer.scheduledTimer(timeInterval: 1,
                                                   target: self,
                                                   selector: #selector(updateSessionExpiredTime),
                                                   userInfo: nil,
                                                   repeats: true)
    }
    
    func stopTimer() {
        resendTimer?.invalidate()
        resendTimer = nil
        sessionExpiredTimer?.invalidate()
        sessionExpiredTimer = nil
    }
    
    func becomeActive() {
        guard let exitTime = exitTime else { return }
        defer { self.exitTime = nil }
        
        let resumeTime = Date()
        let timeSinceExitTime: Int = Int(resumeTime.timeIntervalSince(exitTime))
        resendTime = resendTime - timeSinceExitTime <= 0 ? 0 : resendTime - timeSinceExitTime
        view?.updateResendTime(resendTime)
        sessionExpiredTime = sessionExpiredTime - timeSinceExitTime <= 0 ? 0 : sessionExpiredTime - timeSinceExitTime
    }
    
    func resignActive() {
        exitTime = Date()
    }
    
    func checkMailCode(_ code: String) {
        view?.showLoading()
        interactor?.checkMailCode(code)
    }
    
    func popToPreviousView(from vc: UIViewController) {
        router?.popToPreviousView(from: vc)
    }
}

// MARK: - Private
private extension ForgotPasswordVerificationPresenter {
    @objc func updateResendTime() {
        if resendTime <= 0 {
            resendTimer?.invalidate()
            resendTimer = nil
        } else {
            resendTime -= 1
            view?.updateResendTime(resendTime)
        }
    }
    
    @objc func updateSessionExpiredTime() {
        if sessionExpiredTime <= 0 {
            sessionExpiredTimer?.invalidate()
            sessionExpiredTimer = nil
            view?.showSessionExpiredPopup()
        } else {
            sessionExpiredTime -= 1
        }
    }
}

// MARK: - InteractorToPresenter
extension ForgotPasswordVerificationPresenter: InteractorToPresenterForgotPasswordVerificationProtocol {
    func checkMailCodeSuccess(with email: String) {
        view?.hideLoading()
        router?.navigateToValidateForgotPassword(with: email)
    }
    
    func checkMailCodeFailed(_ error: ServiceError) {
        view?.hideLoading()
        view?.showInvalidCodeError()
    }
}
