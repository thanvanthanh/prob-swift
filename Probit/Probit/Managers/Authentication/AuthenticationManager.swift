//
//  AuthenticationManager.swift
//  Probit
//
//  Created by Thân Văn Thanh on 12/10/2022.
//

import Foundation
import LocalAuthentication

enum BiometricType: String {    
    case none = "none"
    case touch = "touch"
    case face = "face"

    static func initValue(rawValue: String) -> BiometricType {
        switch rawValue {
        case "touch":
            return .touch
        case "face":
            return .face
        default:
            return .none
        }
    }
}

class AuthenticationManager: NSObject {
    var myContext = LAContext()
    var biometryType: LABiometryType {
        return self.myContext.biometryType
    }
    static let shared = AuthenticationManager()
    
    func authenticationWithTouchID(completion: @escaping (BiometricType) -> ()) {
        myContext = LAContext()
        myContext.localizedFallbackTitle = "Use Passcode"

        var authError: NSError?
        let reasonString = "To access the secure data"

        if myContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &authError) {
            
            myContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics,
                                     localizedReason: reasonString) { success, evaluateError in
                DispatchQueue.main.async {
                    if success {
                        if #available(iOS 11, *) {
                            let _ = self.myContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
                            switch(self.myContext.biometryType) {
                            case .none:
                                completion(.none)
                                return
                            case .touchID:
                                completion(.touch)
                                return
                            case .faceID:
                                completion(.face)
                                return
                            @unknown default:
                                completion(.none)
                                return
                            }
                        } else {
                            self.myContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) ? completion(.touch) : completion(.none)
                            return
                        }
                    } else {
                        guard let error = evaluateError else { return }
                        print(self.evaluateAuthenticationPolicyMessageForLA(errorCode: error._code))
                        completion(.none)
                    }
                }
            }
        } else {
            guard let error = authError else { return }
            completion(.none)
            //TODO: Show appropriate alert if biometry/TouchID/FaceID is lockout or not enrolled
            print(self.evaluateAuthenticationPolicyMessageForLA(errorCode: error.code))
        }
    }
    
    func canAuthenticateByFaceID () -> Bool {
        //if iOS 11 doesn't exist then FaceID doesn't either
        if #available(iOS 11.0, *) {
            var error: NSError?
            if self.myContext.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                //As of 11.2 typeFaceID is now just faceID
                print("-----\(self.myContext.biometryType)-----")
                if (self.myContext.biometryType == .faceID) {
                    return true
                }
            } else {
                return self.myContext.biometryType == .faceID
            }
        }
        return false
    }

    func evaluatePolicyFailErrorMessageForLA(errorCode: Int) -> String {
        var message = ""
        if #available(iOS 11.0, macOS 10.13, *) {
            switch errorCode {
                case LAError.biometryNotAvailable.rawValue:
                    message = "Authentication could not start because the device does not support biometric authentication."

                case LAError.biometryLockout.rawValue:
                    message = "Authentication could not continue because the user has been locked out of biometric authentication, due to failing authentication too many times."

                case LAError.biometryNotEnrolled.rawValue:
                    message = "Authentication could not start because the user has not enrolled in biometric authentication."

                default:
                    message = "Did not find error code on LAError object"
            }
        } else {
            switch errorCode {
                case LAError.touchIDLockout.rawValue:
                    message = "Too many failed attempts."

                case LAError.touchIDNotAvailable.rawValue:
                    message = "TouchID is not available on the device"

                case LAError.touchIDNotEnrolled.rawValue:
                    message = "TouchID is not enrolled on the device"

                default:
                    message = "Did not find error code on LAError object"
            }
        }
        return message;
    }

    func evaluateAuthenticationPolicyMessageForLA(errorCode: Int) -> String {
        var message = ""
        switch errorCode {

        case LAError.authenticationFailed.rawValue:
            message = "The user failed to provide valid credentials"

        case LAError.appCancel.rawValue:
            message = "Authentication was cancelled by application"

        case LAError.invalidContext.rawValue:
            message = "The context is invalid"

        case LAError.notInteractive.rawValue:
            message = "Not interactive"

        case LAError.passcodeNotSet.rawValue:
            message = "Passcode is not set on the device"

        case LAError.systemCancel.rawValue:
            message = "Authentication was cancelled by the system"

        case LAError.userCancel.rawValue:
            message = "The user did cancel"

        case LAError.userFallback.rawValue:
            message = "The user chose to use the fallback"

        default:
            message = evaluatePolicyFailErrorMessageForLA(errorCode: errorCode)
        }
        return message
    }
}
