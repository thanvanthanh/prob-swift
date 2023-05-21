//
//  WithdrawVerificationPresenter.swift
//  Probit
//
//  Created by Đào Mỹ Đông on 01/12/2565 BE.
//  
//

import UIKit
import YubiKit
import ExternalAccessory


class WithdrawVerificationPresenter: NSObject, ViewToPresenterWithdrawVerificationProtocol {
    
    enum ConnectionType {
        case nfc
        case accessory
    }
    
    // MARK: Properties
    var nfcConnection: YKFNFCConnection?
    var accessoryConnection: YKFAccessoryConnection?
    var session: YKFFIDO2Session?
    var connectionCallback: ((_ connection: YKFConnectionProtocol) -> Void)?
    
    var connectionType: ConnectionType? {
        get {
            if nfcConnection != nil {
                return .nfc
            } else if accessoryConnection != nil {
                return .accessory
            } else {
                return nil
            }
        }
    }
    
    var view: PresenterToViewWithdrawVerificationProtocol?
    var interactor: PresenterToInteractorWithdrawVerificationProtocol?
    var router: PresenterToRouterWithdrawVerificationProtocol?
    var argument: WithdrawVerificationArgument
    
    init(with argument: WithdrawVerificationArgument) {
        self.argument = argument
    }
    
    var withdrawResponse: WithdrawVerificationResponse? {
        return interactor?.withdrawResponse
    }
    
    func viewDidLoad() {
        YubiKitExternalLocalization.nfcScanAlertMessage = "hardkey_alert_message".Localizable()
        YubiKitExternalLocalization.nfcScanSuccessAlertMessage = "scan_hardkey_alert_complete".Localizable()
    }
    
    func viewWillDisappear() {
        stopConnectionYubikey()
    }
    
    func startConnectYubi() {
        YubiKitManager.shared.delegate = self
        if YubiKitDeviceCapabilities.supportsMFIAccessoryKey {
            YubiKitManager.shared.startAccessoryConnection()
        }
    }
    
    private func stopConnectionYubikey() {
        if YubiKitDeviceCapabilities.supportsMFIAccessoryKey {
            YubiKitManager.shared.stopAccessoryConnection()
        }
    }
    
    func connection(completion: @escaping (_ connection: YKFConnectionProtocol) -> Void) {
        guard let accessoryConnection = self.accessoryConnection else {
            connectionCallback = completion
            YubiKitManager.shared.startNFCConnection()
            return
        }
        completion(accessoryConnection)
    }
    
    func session(completion:  @escaping (_ session: YKFFIDO2Session?, _ error: Error?) -> Void) {
        guard let _session = session else {
            self.connection { [weak self] ykConnection in
                guard let self = self else { return }
                ykConnection.fido2Session { fd2Session, error in
                    self.session = fd2Session
                    completion(fd2Session, error)
                }
                
            }
            return
        }
        completion(_session, nil)
    }
    
}

extension WithdrawVerificationPresenter: InteractorToPresenterWithdrawVerificationProtocol {
    
    func loginComplete(username: String, password: String) {
        DispatchQueue.main.async {
            self.view?.hideLoading()
            guard let model = self.interactor?.loginResponse else { return }
            
            if let isSendCode = model.totp, isSendCode {
                self.router?.navigateToGoogleAuthentication(email: username, password: password)
                return
            }
            
            if let isSendCode = model.email, isSendCode {
                self.router?.navigateToVerification(email: username, password: password, tfaState: self.withdrawResponse?.state)
                return
            }
            
            guard let accessToken = model.accessToken,
                  let refreshToken = model.refreshToken else { return }
            AppConstant.accessToken = accessToken
            AppConstant.tokenType = model.tokenType
            AppConstant.refreshToken = refreshToken
        }
        
        self.interactor?.getProfileInfo()
        
    }
    
    func getProfileInfoComplete(isShowTermScreen: Bool) {
        DispatchQueue.main.async {
            self.view?.hideLoading()
            guard isShowTermScreen else {
                self.view?.navigateToHome()
                return
            }
            self.router?.navigateToTerms(screenFrom: .signIn)
        }
    }
    
    func getWithdrawResponseSuccesed() {
        DispatchQueue.main.async {
            self.view?.hideLoading()
            guard let response = self.interactor?.withdrawResponse, let state = response.state, let sessid = response.state?.sessId  else {
                self.view?.showError(error: ServiceError.somethinkWrong)
                return
            }
            
            guard let methods = response.state?.policy?.methods else {
                self.handerApiError(error: ServiceError.somethinkWrong)
                return
            }
            
            guard let methodStates = response.state?.methodStates else {
                self.handerApiError(error: ServiceError.somethinkWrong)
                return
            }
            
            let filteredMethods = methodStates.filter { $0.status == "pass"}.compactMap { $0.method }
            
            let unverifyMethods = methods.filter { !filteredMethods.contains($0) }
            let firstMethod = unverifyMethods.first
            
            guard let nextMethod = firstMethod, let request = self.argument.withDrawlRequest else {
                self.handerApiError(error: ServiceError.somethinkWrong)
                return
            }
            
            switch nextMethod {
            case AuthenticationMethod.totp.rawValue, AuthenticationMethod.sms.rawValue:
                VerifyOTPToWithdrawRouter().showScreen(tfaState: response, withdrawRequest: request.withdrawlRequest)
            case AuthenticationMethod.email.rawValue:
                
                self.interactor?.sendTFAEmail(sessid, completion: { [weak self] result in
                    guard let `self` = self else { return }
                    switch result {
                    case .success(let response):
                        guard response.success == true else {
                            self.handerApiError(error: ServiceError.somethinkWrong)
                            return
                        }
                        VerificationRouter()
                            .showScreen(email: "",
                                        type: .withdraw,
                                        tfaState: state,
                                        withdrawRequest:request.withdrawlRequest)

                    case .failure(let error):
                        self.handerApiError(error: error)
                    }
                })
                default:
                //                    router?.popToRootView()
                break
            }
            
        }
    }
    
    func handerApiError(error: ServiceError) {
        DispatchQueue.main.async {
            self.view?.showError(error: error)
            self.view?.hideLoading()
        }
    }
    
    func beginVerify() {
        switch argument {
        case .login(let data):
            self.handleLogin(withData: data)
        case .withdraw(let parameter):
            self.handleWithDraw(parameter: parameter)
        }
    }
    
    // Handle login with hardkey.
    private func handleLogin(withData data: WithdrawLoginParameter ) {
        
        self.verifyHardkeyWith(challenge: data.fido.challenge?.authCredential?.challenge,
                               origin: data.fido.challenge?.authCredential?.rpID,
                               allowCredentials: data.fido.challenge?.authCredential?.allowCredentials) { [weak self] signReponse, svError in
            guard let self = self else { return }
            guard let _response = signReponse else {
                self.handerApiError(error: svError ?? ServiceError(issueCode: .WRONG_HARDKEY))
                return
            }
            
            guard let challenge = data.fido.challenge?.authCredential?.challenge?.base64URLUnescaped(),
                  let challengeId = data.fido.challenge?.challengeID,
                  let challengeData = Data(base64Encoded: challenge),
                  let origin = data.fido.challenge?.authCredential?.rpID,
                  let clientData = YKFWebAuthnClientData(type: .get, challenge: challengeData, origin: origin),
                  let clientDataJSON = clientData.jsonData?.base64EncodedString().base64URLEscaped(),
                  let version = data.fido.keyHandles?.first?.version,
                  let keyHandle = data.fido.keyHandles?.first?.keyHandle
            else {
                self.handerApiError(error: ServiceError(issueCode: .WRONG_HARDKEY))
                return
            }
            
            let authenticatorData = _response.authData.base64EncodedString()
            let signature = _response.signature.base64EncodedString()
            
            RecaptchaHelper.shared.recaptchaClient { recaptcha in
                let loginParameter = TFALoginParameter(username: data.username,
                                                       password: data.password,
                                                       recaptcha: recaptcha,
                                                       keyHandle: keyHandle,
                                                       webAuthnCredential: WebAuthnCredential(keyHandle,
                                                                                              authenticatorData: authenticatorData,
                                                                                              signature: signature,
                                                                                              userHandle: "",
                                                                                              clientDataJSON: clientDataJSON),
                                                       version: version,
                                                       signatureData: signature,
                                                       challengeId: challengeId)
                
                self.interactor?.login(parameter: loginParameter)
            }
        }
    }
    
    private func handleWithDraw(parameter: WithDrawParameter) {
        self.verifyHardkeyWith(challenge: parameter.u2fRequest.authCredential?.challenge,
                               origin: parameter.u2fRequest.authCredential?.rpID,
                               allowCredentials: parameter.u2fRequest.authCredential?.allowCredentials) { [weak self] signReponse, svError in
            
            guard let self = self else { return }
            
            guard let _response = signReponse else {
                self.handerApiError(error: svError ?? ServiceError(issueCode: .WRONG_HARDKEY))
                return
            }
            
            guard let challenge = parameter.u2fRequest.authCredential?.challenge?.base64URLUnescaped(),
                  let challengeData = Data(base64Encoded: challenge),
                  let origin = parameter.u2fRequest.authCredential?.rpID,
                  let clientData = YKFWebAuthnClientData(type: .get, challenge: challengeData, origin: origin),
                  let clientDataJSON = clientData.jsonData?.base64EncodedString().base64URLEscaped(),
                  let rawId = parameter.u2fRequest.authCredential?.allowCredentials?.first?.id
            else {
                self.handerApiError(error: svError ?? ServiceError.somethinkWrong)
                return
            }
            
            let authenticatorData = _response.authData.base64EncodedString()
            let signature = _response.signature.base64EncodedString()
            
            let parameter = TFAWithdrawParameter(
                purpose: parameter.purpose,
                sessId: parameter.sessId,
                rawId: rawId,
                authenticatorData: authenticatorData,
                signature: signature,
                userHandle: parameter.userId,
                clientDataJSON: clientDataJSON)
            
            self.interactor?.verifyTFA(parameter: parameter)
            
        }
    }
    
    private func verifyHardkeyWith( challenge: String?,
                                    origin: String?,
                                    allowCredentials:[AllowCredential]?,
                                    completion: @escaping (YKFFIDO2GetAssertionResponse?, ServiceError?) -> Void) {
        
        self.session { [weak self] session, error in
            guard let self = self, let _session = session else {
                completion(nil, ServiceError.somethinkWrong)
                return
            }
            
            guard
                let _challenge = challenge?.base64URLUnescaped(),
                let challengeData = Data(base64Encoded: _challenge),
                let _origin = origin,
                let clientData = YKFWebAuthnClientData(type: .get, challenge: challengeData, origin: _origin),
                let _allowCredentials = allowCredentials,
                let clientDataHash = clientData.clientDataHash
            else {
                completion(nil, ServiceError.somethinkWrong)
                return
            }
            
            let options = [YKFFIDO2OptionUP: true]
            
            var allowList = [YKFFIDO2PublicKeyCredentialDescriptor]()
            for credentialId in (_allowCredentials.map{ $0.id?.base64URLUnescaped() ?? ""}) {
                let credentialDescriptor = YKFFIDO2PublicKeyCredentialDescriptor()
                credentialDescriptor.credentialId = Data(base64Encoded: credentialId)!
                let credType = YKFFIDO2PublicKeyCredentialType()
                credType.name = "public-key"
                credentialDescriptor.credentialType = credType
                allowList.append(credentialDescriptor)
            }
            
            _session.getAssertionWithClientDataHash(clientDataHash, rpId: _origin, allowList: allowList, options: options) { response, error in
                if self.connectionType == .nfc {
                    YubiKitManager.shared.stopNFCConnection()
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.6) {
                    guard let _response = response else {
                        completion(nil, ServiceError(issueCode: .WRONG_HARDKEY))
                        return
                    }
                    
                    completion(_response, nil)
                }
            }
        }
    }
}

extension WithdrawVerificationPresenter:  YKFManagerDelegate {
    
    func didConnectNFC(_ connection: YKFNFCConnection) {
        self.nfcConnection = connection
        if let callback = connectionCallback {
            callback(connection)
        }
    }
    
    func didDisconnectNFC(_ connection: YKFNFCConnection, error: Error?) {
        print("Disconnected")
        self.nfcConnection = nil
        self.session = nil
    }
    
    func didConnectAccessory(_ connection: YKFAccessoryConnection) {
        print("didConnectAccessory")
        self.accessoryConnection = connection
    }
    
    func didDisconnectAccessory(_ connection: YKFAccessoryConnection, error: Error?) {
        print("didDisconnectAccessory")
        self.accessoryConnection = nil
        self.session = nil
    }
}

