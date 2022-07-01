//
//  RequestManager.swift
//  Assessment
//
//  Created by Shaiful Islam Sujohn on 7/2/22.
//

import Alamofire

enum Service: String {
    case offer = ""
}

enum RequestMethod: String {
    case GET
    case POST
    case PUT
    case DELETE
}

class RequestManager {

    static let manager = RequestManager()
    
    private let session: Session = {
        let url = AppConfig.baseUrl
        let trustManager = ServerTrustManager(allHostsMustBeEvaluated: false, evaluators: [AppConfig.domainUrl : DisabledEvaluator()])
        let configuration = URLSessionConfiguration.af.default
        configuration.waitsForConnectivity = true
        configuration.timeoutIntervalForRequest = 60
        
        return Session(configuration: configuration, serverTrustManager: trustManager)
    }()
    
    private init () {
        
    }
    
    func requestService<T: Decodable>(_ service: Service, ofType: T.Type, method: RequestMethod, params: [String: Any], isMultiPart: Bool = false, completion: @escaping (Result<T, Error>) -> Void) {
        
        let url = AppConfig.baseUrl + service.rawValue
        var headers = HTTPHeaders()
        let sessionManager = SessionManager.manager
        
        let encoding: ParameterEncoding = method == .GET ? URLEncoding.default : JSONEncoding.default
        
        if isMultiPart {
            
            self.session.upload(multipartFormData: { multipartFormData in
                
            }, to: url, method: HTTPMethod(rawValue: method.rawValue), headers: headers).responseJSON { response in
                
                self.handle(response: response, service: service, ofType: T.self, completion: completion)
            }
        }
        else {
            
            self.session.request(url, method: HTTPMethod(rawValue: method.rawValue), parameters: params, encoding: encoding, headers: headers).responseJSON { response in
                
                self.handle(response: response, service: service, ofType: T.self, completion: completion)
            }
        }
        
    }
    
    fileprivate func handle<T: Decodable>(response : AFDataResponse<Any>, service: Service, ofType: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
        
        if let code = response.response?.statusCode {
                            
            switch code {
            case 200...299:
                
                if service == Service.offer/*Service(rawValue: "ABC")*/ {
                    self.mocResponseFor(service: service, ofType: ofType, completion: completion)
                }
                else {
                    do {
                        let decodeData = try JSONDecoder().decode(T.self, from: response.data!)
                        completion(.success(decodeData))
                    } catch let error {
                        completion(.failure(error))
                    }
                }
                return
            case 404:
                let reason = "Resource Not Found"
                let error = NSError(domain: reason, code: code, userInfo: response.response?.allHeaderFields as? [String: Any])
                completion(.failure(error))
                return
            default:
                let error = NSError(domain: "", code: code, userInfo: response.response?.allHeaderFields as? [String: Any])
                completion(.failure(error))
                return
            }
        }
        else {
            
            let result = response.result
            
            switch result {
                
            case .failure(let error):
                completion(.failure(error))
            default:
                let error = NSError(domain: "", code: response.response?.statusCode ?? 0, userInfo: response.response?.allHeaderFields as? [String: Any])
                completion(.failure(error))
            }
        }
    }
}

extension RequestManager {
    
    fileprivate func readLocalFile(name: String) -> Data? {
        
        do {
            if let bundlePath = Bundle.main.path(forResource: name, ofType: "json") {
                
                let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8)
                return jsonData
            }
        } catch {
            print(error)
        }
        
        return nil
    }
    
    fileprivate func mocResponseFor<T: Decodable>(service: Service, ofType: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
        
        if service == .offer {
            
            if let localData = self.readLocalFile(name: "offers") {
                
                do {
                    
                    let decodeData = try JSONDecoder().decode(T.self, from: localData)
                    completion(.success(decodeData))
                } catch let error {
                    completion(.failure(error))
                }
            }
        }
    }
}


