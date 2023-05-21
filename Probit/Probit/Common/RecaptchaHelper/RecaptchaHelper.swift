//
//  RecaptchaHelper.swift
//  Probit
//
//  Created by Nguyen Quang on 14/09/2022.
//

import Foundation
import RecaptchaEnterprise


class RecaptchaHelper {
    
    static var shared: RecaptchaHelper { return _shared }
    
    private static let _shared = RecaptchaHelper()
    
    private init() {}
    
    func recaptchaClient(completion: @escaping (String?) -> Void) {
        Recaptcha.getClient(siteKey: "6LekzookAAAAAN_UhKcevcQRLc3mSC5w9U19e7IF") { client, error in
            guard let clientRecapt = client else {
                completion(nil)
                print("RecaptchaHelperError: ", error?.errorMessage ?? "")
                return
            }
            
            clientRecapt.execute(RecaptchaAction(action: .login)) { recaptchaToken, errorToken in
                
                if let _error = errorToken {
                    print("RecaptchaHelperError: ", _error.errorMessage ?? "")
                }
                
                guard let _token = recaptchaToken?.recaptchaToken else {
                    completion(nil)
                    return
                }
                completion(_token)
            }
        }
    }
        
}
