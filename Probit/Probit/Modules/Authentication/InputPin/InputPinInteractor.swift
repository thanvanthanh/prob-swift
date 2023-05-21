//
//  InputPinInteractor.swift
//  Probit
//
//  Created by Thân Văn Thanh on 22/08/2022.
//  
//

import Foundation
import UIKit

class InputPinInteractor: PresenterToInteractorInputPinProtocol {

    // MARK: Properties
    var presenter: InteractorToPresenterInputPinProtocol?
    var type: InputPinType?
    var title: String?
    var confirmTitle: String?
    var leftTitle: String?
    var inputPinTitle: String?
    
    private var stepInput: Int = 1
    private var countFails: Int = AppConstant.countFailPin
    private var countFailMessage: String = ""
    private var afterSeconds: Int = 1
    
    private var chagePinStep: Int = 1
    
    private var password: String = ""
    private var confirmPassword: String = ""
    
    let topViewController = UIApplication.shared.getTopViewController()
    
    func getData() {
        guard let type = type else { return }
        switch type {
        case .login:
            inputPinTitle = "activity_lockscreen_v2_displayarea_title_inputpin".Localizable()
            title = "activity_lockscreen_v2_displayarea_title_inputpin".Localizable()
            leftTitle = nil
        case .enable:
            inputPinTitle = "activity_lockscreen_v2_displayarea_title_inputnewpin".Localizable()
            title = "fragment_applocksettings_enableapplock".Localizable()
            leftTitle = "activity_security_v2_titlebar".Localizable()
        case .disable:
            inputPinTitle = "activity_lockscreen_checkcurrentpassword".Localizable()
            leftTitle = "activity_security_v2_titlebar".Localizable()
            title = "fragment_applocksettings_disableapplock".Localizable()
        case .change:
            inputPinTitle = "activity_lockscreen_checkcurrentpassword".Localizable()
            leftTitle = "activity_security_v2_titlebar".Localizable()
            title = "fragment_applocksettings_changepin".Localizable()
        }
        presenter?.fetchData()
    }
    
    func validateInputLogin(input: InputPinTextField, confirm: InputPinTextField) {
        guard let type = type else { return }
        switch type {
        case .login:
            validateInput(type: .login, input: input)
        case .enable:
            confirmActionWithInput(input: input, confirm: confirm)
        case .disable:
            validateInput(type: .disable, input: input)
        case .change:
            changePin(type: .change, input: input, confirm: confirm)
        }
    }
    
    private func confirmActionWithInput(input: InputPinTextField, confirm: InputPinTextField) {
        switch stepInput {
        case 1:
            confirmTitle = "activity_lockscreen_passwordagaintitle".Localizable()
            stepInput += 1
            password = input.getInputText()
            presenter?.confirmPin()
            confirm.inputTextField.becomeFirstResponder()
            presenter?.validateButton(false)
        case 2:
            validateConfirmPassword(input: input, confirm: confirm)
        default: break
        }
        presenter?.setupViewStep(stepInput == 1)
    }
    
    private func validateConfirmPassword(input: InputPinTextField, confirm: InputPinTextField) {
        confirmPassword = confirm.getInputText()
        let validate = password == confirmPassword
        presenter?.validateConfirmPassword(validate)
        guard !validate else {
            AppConstant.pinLock = confirmPassword
            self.presenter?.navigateToComplete()
            return
        }
        presenter?.validateButton(false)
        confirmTitle = "activity_lockscreen_wrongpasswordtitle".Localizable()
        [input, confirm].forEach{ $0.borderColor = UIColor.Basic.red }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            guard let self = self else { return }
            [input, confirm].forEach{ $0.borderColor = UIColor.color_4231c8_6f6ff7 }
            self.confirmTitle = "activity_lockscreen_passwordagaintitle".Localizable()
            switch self.type {
            case .enable:
                self.stepInput = 1
                self.presenter?.setupViewStep(true)
                self.presenter?.validateButton(validate)
                self.presenter?.validateConfirmPassword(!validate)
            case .change:
                self.chagePinStep = 2
                confirm.removeText()
                self.presenter?.setupViewStep(true)
                self.presenter?.validateConfirmPassword(!validate)
                self.presenter?.validateButton(validate)
            default: break
            }
            confirm.isUserInteractionEnabled = true
            input.inputTextField.becomeFirstResponder()
        }
        confirm.isUserInteractionEnabled = false
    }
    
    private func validateInput(type: InputPinType, input: InputPinTextField, confirm: InputPinTextField? = nil) {
        countFailInputPin()
        guard input.getInputText() == AppConstant.pinLock else {
            input.removeText()
            disableInput(seconds: afterSeconds)
            return
        }
        if (type == .disable) {
            AppConstant.disablePinLock()
        }
        topViewController?.pop(isAnimated: true)
        AppConstant.countFailPin = 0
        AppConstant.isDisableInputPin = false

    }
    
    private func changePin(type: InputPinType, input: InputPinTextField, confirm: InputPinTextField) {
        guard type == .change else { return }
        switch chagePinStep {
        case 1:
            countFailInputPin()
            password = ""
            guard input.getInputText() == AppConstant.pinLock else {
                input.removeText()
                presenter?.validateInput(true, countFail: countFailMessage, isEnabled: false)
                let dispatchAfter = DispatchTimeInterval.seconds(afterSeconds)
                DispatchQueue.main.asyncAfter(deadline: .now() + dispatchAfter) { [weak self] in
                    guard let self = self else { return }
                    self.presenter?.validateInput(false,
                                                  countFail: "(\(AppConstant.countFailPin)/30)",
                                                  isEnabled: false)
                }
                return
            }
            AppConstant.countFailPin = 0
            AppConstant.isDisableInputPin = false
            chagePinStep += 1
            inputPinTitle = "activity_lockscreen_v2_displayarea_title_inputnewpin".Localizable()
            confirmTitle = "activity_lockscreen_v2_displayarea_title_inputnewpin".Localizable()
            self.presenter?.validateInput(false, countFail: "", isEnabled: false)
            self.presenter?.showCounterMessage(true)
            self.presenter?.fetchData()
            input.removeText()
            input.borderColor = UIColor.color_4231c8_6f6ff7
            input.inputTextField.becomeFirstResponder()
        case 2:
            chagePinStep += 1
            confirmTitle = "activity_lockscreen_passwordagaintitle".Localizable()
            password = input.getInputText()
            self.presenter?.setupViewStep(false)
            confirm.inputTextField.becomeFirstResponder()
            presenter?.validateButton(false)
        case 3:
            confirmPassword = confirm.getInputText()
            validateConfirmPassword(input: input, confirm: confirm)
            self.presenter?.setupViewStep(false)
        default: break
        }
    }
    
    private func countFailInputPin() {
        AppConstant.countFailPin = AppConstant.countFailPin + 1
        countFailMessage = "(\(AppConstant.countFailPin)/30)"
        switch AppConstant.countFailPin {
        case 1, 2:
            break
        case 3...5:
            presenter?.showCounterMessage(false)
        case 6...29:
            countFailMessage = "failed_attempt_retryafter".Localizable() + " (\(AppConstant.countFailPin)/30)"
            afterSeconds = 30
            AppConstant.isDisableInputPin = true
        default:
            guard let vc = topViewController as? BaseViewController else { return }
            presenter?.logoutWrongPinThirtyTimes(viewController: vc)
        }
    }
    
    private func disableInput(seconds: Int) {
        presenter?.validateInput(true, countFail: countFailMessage, isEnabled: false)
        let dispatchAfter = DispatchTimeInterval.seconds(seconds)
        DispatchQueue.main.asyncAfter(deadline: .now() + dispatchAfter) { [weak self] in
            guard let self = self else { return }
            self.presenter?.validateInput(false, countFail: "(\(AppConstant.countFailPin)/30)", isEnabled: false)
        }
    }
}
