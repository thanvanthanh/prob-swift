//
//  BaseService.swift
//  Probit
//
//  Created by Beacon on 31/08/2022.
//

import Foundation
import Alamofire

class BaseAPI<T:Configuration> {
    var needToRefreshTokenPaths = [String]()
    var exceptionPaths: [String] = ["api/exchange/v1/withdrawal", "api/security/v1/tfa_start_new"]
    func upload<M: Decodable>(configuration: T,
                              name: String,
                              responseType: M.Type,
                              completionHandler:@escaping (Result<M, ServiceError>)-> Void) {
        guard let imageData = configuration.data else {
            completionHandler(.failure(ServiceError(issueCode: IssueCode.INTERNAL_SERVER_ERROR)))
            return
        }
        
        let url = configuration.baseURL + configuration.path.escape()
        let method = Alamofire.HTTPMethod(rawValue: configuration.method.rawValue)
        let headers = HTTPHeaders(configuration.headers ?? [:])
        guard let host = URLComponents(string: url) else {
            completionHandler(.failure(.urlError))
            return
        }
        AF.upload(multipartFormData: { multipart in
            multipart.append(imageData,
                             withName: name,
                             fileName: "\(name).jpg",
                             mimeType: "image/jpeg")
        },to: host,
                  usingThreshold: UInt64(),
                  method: method,
                  headers: headers).uploadProgress(queue: .main, closure: { progress in
            //Current upload progress of file
            print("Upload Progress: \(progress.fractionCompleted)")
        }).responseDecodable(of: M.self) { response in
            guard let existData = response.data else {
                completionHandler(.failure(ServiceError.notFoundData))
                return
            }
            
            guard let httpResponse = response.response else {
                completionHandler(.failure(ServiceError.notFoundData))
                return
            }
            
            guard self.isSuccess(httpResponse.statusCode) else {
                if httpResponse.statusCode == 401,
                   AppConstant.refreshToken != nil,
                   self.exceptionPaths.first(where: {$0 == configuration.path.escape()}) == nil,
                   !self.needToRefreshTokenPaths.contains(configuration.baseURL + configuration.path.escape()) {
                    self.needToRefreshTokenPaths.append((configuration.baseURL + configuration.path.escape()))
                    
                    // Refresh token
                    self.autoRefreshToken(completionHandler: { iSuccess in
                        if iSuccess {
                            self.fetchData(configuration: configuration, responseType: responseType, completionHandler: { response in
                                self.needToRefreshTokenPaths.removeAll(where: {$0 == configuration.baseURL + configuration.path.escape()})
                                completionHandler(response)
                            })
                        } else {
                            completionHandler(.failure(ServiceError.notFoundData))
                        }
                    })
                    return
                }
                guard let error = self.getFailedServiceError(existData) else {
                    completionHandler(.failure(.parseError))
                    return
                }
                
                completionHandler(.failure(error))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let responseObj = try decoder.decode(M.self, from: existData)
                completionHandler(.success(responseObj))
            } catch {
                print("\n----- Parse Model Error: \n", error)
                print("\n----- End:")
                completionHandler(.failure(.parseError))
            }
        }
    }
    
    func fetchData<M: Decodable>(configuration: T,
                                 responseType: M.Type,
                                 completionHandler:@escaping (Result<M, ServiceError>)-> Void) {
        let parameters = generateParams(task: configuration.task)
        let url = configuration.baseURL + configuration.path.escape()
        guard var components = URLComponents(string: url) else {
            completionHandler(.failure(.urlError))
            return
        }
        
        if configuration.method == HTTPMethod.get {
            components.queryItems = parameters.0.map { (key, value) in
                URLQueryItem(name: key, value: "\(value)")
            }
            components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
        }
        
        guard let url = components.url else {
            completionHandler(.failure(.urlError))
            return
        }
        
        // Create request
        let request = self.generateRequest(url: url, method: configuration.method.rawValue)
        
        if configuration.method == HTTPMethod.post {
            let jsonData = try? JSONSerialization.data(withJSONObject: parameters.0, options: [])
            request.httpBody = jsonData
        }
        
        ProbLogger.log(request: request)
        
        
        let dataTask = URLSession.shared.dataTask(with: request as URLRequest,
                                                  completionHandler: { data, response, error in
            ProbLogger.log(data: data, response: response as? HTTPURLResponse, error: error)
            DispatchQueue.main.async {
                guard error == nil else {
                    let errorMessage = error?.localizedDescription ?? "Server Error"
                    completionHandler(.failure(ServiceError.init(issueCode: .initValue(value: errorMessage))))
                    return
                }
                guard let existData = data, let httpResponse = response as? HTTPURLResponse else {
                    completionHandler(.failure(ServiceError.notFoundData))
                    return
                }
                if httpResponse.statusCode == 204 {
                    let dataDTO = DataDTO<Bool>(data: true)
                    if let res = dataDTO as? M {
                        completionHandler(.success(res))
                    } else {
                        completionHandler(.failure(ServiceError.notFoundData))
                    }
                    return
                }
                
                guard (try? JSONSerialization.jsonObject(with: existData, options: [])) != nil else {
                    completionHandler(.failure(.jsonError))
                    return
                }
                
                guard self.isSuccess(httpResponse.statusCode) else {
                    
                    if httpResponse.statusCode == 401, AppConstant.refreshToken != nil,
                       self.exceptionPaths.first(where: {$0 == configuration.path.escape()}) == nil,
                       !self.needToRefreshTokenPaths.contains(configuration.baseURL + configuration.path.escape()) {
                        self.needToRefreshTokenPaths.append((configuration.baseURL + configuration.path.escape()))
                        
                        // Refresh token
                        self.autoRefreshToken(completionHandler: { iSuccess in
                            if iSuccess {
                                self.fetchData(configuration: configuration, responseType: responseType, completionHandler: { response in
                                    self.needToRefreshTokenPaths.removeAll(where: {$0 == configuration.baseURL + configuration.path.escape()})
                                    completionHandler(response)
                                })
                            } else {
                                completionHandler(.failure(ServiceError.notFoundData))
                                AppDelegate.shared.forceLogOut()
                            }
                        })
                        return
                    }
                    
                    guard let error = self.getFailedServiceError(existData) else {
                        completionHandler(.failure(.parseError))
                        return
                    }
                    
                    completionHandler(.failure(error))
                    return
                }
                do {
                    let decoder = JSONDecoder()
                    let responseObj = try decoder.decode(M.self, from: existData)
                    completionHandler(.success(responseObj))
                } catch {
                    print("\n----- Parse Model Error: \n", error)
                    print("\n ----- JSOM", existData.asString)
                    print("\n----- End:")
                    completionHandler(.failure(.parseError))
                }
            }
        })
        
        dataTask.resume()
    }
    
    private func generateRequest(url: URL, method: String) -> NSMutableURLRequest {
        let request = NSMutableURLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 30.0)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "accept")
        request.setValue(AppConstant.userAgent, forHTTPHeaderField: "User-Agent")
        request.httpBody = nil
        
        if let token = AppConstant.accessToken {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        return request
    }
    
    private func generateParams(task: Task) -> ([String: Any], ParameterEncoding) {
        switch task {
        case .requestPlain:
            return ([:], URLEncoding.default)
        case .requestParameters(parameters: let parameters, encoding: let encoding):
            return (parameters, encoding)
        }
    }
    
    private func handleRefreshTokenFlow() {
        
    }
    
    func getFailedServiceError(_ data: Data?) -> ServiceError? {
        guard let data = data, let responseObj = try? JSONDecoder().decode(Issue.self, from: data) else {
            return nil
        }
        var messError: String = responseObj.error.value
        if let errorFields = responseObj.errorFields {
            messError = errorFields
        }
        if let errorDescription = responseObj.errorDescription {
            messError = errorDescription
        }
        
        if let message = responseObj.details?["message"] {
            messError = message
        }
        
        if let errorCode = responseObj.errorCode, !errorCode.isEmpty {
            messError = errorCode
        }
        
        return ServiceError(issueCode: IssueCode.initValue(value: messError))
    }
    
    func isSuccess(_ code: Int) -> Bool {
        switch code {
        case 200...304:
            return true
        default:
            return false
        }
    }
    
    func autoRefreshToken(completionHandler: @escaping (Bool) -> ()) {
        LoginAPI().refreshToken(completionHandler: { results in
            print("refresh token response")
            switch results {
            case .success(let model):
                if let accessToken = model.accessToken, let refreshToken = model.refreshToken {
                    print("REFRESH TOKEN")
                    AppConstant.accessToken = accessToken
                    AppConstant.tokenType = model.tokenType
                    AppConstant.refreshToken = refreshToken
                }
                completionHandler(true)
            default:
                completionHandler(false)
            }
        })
    }
}

