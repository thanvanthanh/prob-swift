//
//  SettingAPI.swift
//  Probit
//
//  Created by Thân Văn Thanh on 29/09/2022.
//

import Foundation

class SettingAPI: BaseAPI<SettingServiceConfiguration> {
    static let shared = SettingAPI()
    
    func membership(completionHandler: @escaping (Result<MembershipModel, ServiceError>) -> Void) {
        fetchData(configuration: .membership,
                  responseType: MembershipModel.self) { result in
            completionHandler(result)
        }
    }
    
    func referrerCount(completionHandler: @escaping (Result<ReferrerCountModel, ServiceError>) -> Void) {
        fetchData(configuration: .referrerCount,
                  responseType: ReferrerCountModel.self) { result in
            completionHandler(result)
        }
    }
    
    func referrerCode(completionHandler: @escaping (Result<ReferralCodeModel, ServiceError>) -> Void) {
        fetchData(configuration: .referrerCode,
                  responseType: ReferralCodeModel.self) { result in
            completionHandler(result)
        }
    }
    
    func referrerEarned(completionHandler: @escaping (Result<ReferrerEarned, ServiceError>) -> Void) {
        fetchData(configuration: .referrerEarned,
                  responseType: ReferrerEarned.self) { result in
            completionHandler(result)
        }
    }
    
    func getPayInProb(completionHandler: @escaping (Result<GetPayInProbModel, ServiceError>) -> Void) {
        fetchData(configuration: .getPayInProb,
                  responseType: GetPayInProbModel.self) { result in
            completionHandler(result)
        }
    }
    
    func postPayInProb(param: Bool,
                       completionHandler: @escaping (Result<PostPayInProbModel, ServiceError>) -> Void) {
        fetchData(configuration: .postPayInProb(params: param),
                  responseType: PostPayInProbModel.self) { result in
            completionHandler(result)
        }
    }
    
    func checkStep(completionHandler: @escaping (Result<CheckStepModel, ServiceError>) -> Void) {
        fetchData(configuration: .checkStep,
                  responseType: CheckStepModel.self) { result in
            completionHandler(result)
        }
    }
    
    func userKycStatus(completionHandler: @escaping (Result<UserKycStatusModel, ServiceError>) -> Void) {
        fetchData(configuration: .userKycStatus,
                  responseType: UserKycStatusModel.self) { result in
            completionHandler(result)
        }
    }
    
    func notificationPreference(terms: TermSetting,
                                completionHandler: @escaping (Result<NotificationPreferenceResponse, ServiceError>) -> Void) {
        fetchData(configuration: .notificationPreference(terms: terms),
                  responseType: NotificationPreferenceResponse.self) { result in
            completionHandler(result)
        }
    }
    
    func getRuntimeConfig(completionHandler: @escaping (Result<RuntimeConfig, ServiceError>) -> Void) {
        fetchData(configuration: .getRuntimeConfig,
                  responseType: RuntimeConfig.self) { result in
            completionHandler(result)
        }
    }
    
    func getCountryNames(locale: String, completionHandler: @escaping (Result<[String: String], ServiceError>) -> Void) {
        fetchData(configuration: .getCountryNames(locale: locale),
                  responseType: [String: String].self) { result in
            completionHandler(result)
        }
    }
    
    func getGlobalKycData(page: UserKycStatusDetailModel.PageType,
                          completionHandler: @escaping (Result<DataDTO<[String: String]>, ServiceError>) -> Void) {
        fetchData(configuration: .globalKycData(page: page),
                  responseType: DataDTO<[String: String]>.self) { result in
            completionHandler(result)
        }
    }
    
    func getOcrConfirmData(page: UserKycStatusDetailModel.PageType, completionHandler: @escaping (Result<DataDTO<[String: String]>, ServiceError>) -> Void) {
        fetchData(configuration: .globalKycData(page: page),
                  responseType: DataDTO<[String: String]>.self) { result in
            completionHandler(result)
        }
    }
    
    func getCheckDataData(page: UserKycStatusDetailModel.PageType,
                           completionHandler: @escaping (Result<DataDTO<CheckDataModel>, ServiceError>) -> Void) {
        fetchData(configuration: .globalKycData(page: page),
                  responseType: DataDTO<CheckDataModel>.self) { result in
            completionHandler(result)
        }
    }
    
    func getListKycCountries(completionHandler: @escaping (Result<[String], ServiceError>) -> Void) {
        fetchData(configuration: .getListKycCountries,
                  responseType: GetListKycCountriesResponseModel.self) { result in
            switch result {
            case let .success(responseModel):
                completionHandler(.success(responseModel.data))
            case let .failure(error):
                completionHandler(.failure(error))
            }
        }
    }
    
    func updateDataKyc(data: [String: String],
                       completionHandler: @escaping (Result<DataDTO<Bool>, ServiceError>) -> Void) {
        fetchData(configuration: .updateDataKyc(data: data),
                  responseType: DataDTO<Bool>.self) { result in
            completionHandler(result)
        }
    }
    
    func getListIneligibleKycCountries(completionHandler: @escaping (Result<[String], ServiceError>) -> Void) {
        fetchData(configuration: .getListIneligibleKycCountries,
                  responseType: GetListKycCountriesResponseModel.self) { result in
            switch result {
            case let .success(responseModel):
                completionHandler(.success(responseModel.data))
            case let .failure(error):
                completionHandler(.failure(error))
            }
        }
    }
    
    func validatePageKyc(page: UserKycStatusDetailModel.PageType,
                         completionHandler: @escaping (Result<DataDTO<Bool>, ServiceError>) -> Void) {
        fetchData(configuration: .validatePageKyc(page: page),
                  responseType: DataDTO<Bool>.self) { result in
            completionHandler(result)
        }
    }
    
    func uploadImage(image: UIImage,
                     stylePhoto: StylePhoto,
                     completionHandler: @escaping (Result<DataDTO<Bool>, ServiceError>) -> Void) {
        upload(configuration: .uploadImage(image: image),
               name: stylePhoto.nameSever,
               responseType: DataDTO<Bool>.self) { result in
            completionHandler(result)
        }
    }
    
    func deletePhoto(name: String,
                     completionHandler: @escaping (Result<DataDTO<Bool>, ServiceError>) -> Void) {
        fetchData(configuration: .deleteImage(name: name),
                  responseType: DataDTO<Bool>.self) { result in
            completionHandler(result)
        }
    }
    
    func nextStep(stepName: String,
                  completionHandler: @escaping (Result<DataDTO<Bool>, ServiceError>) -> Void) {
        fetchData(configuration: .nextStep(step: stepName),
                  responseType: DataDTO<Bool>.self) { result in
            completionHandler(result)
        }
    }
}
