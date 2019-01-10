//
//  AppService.swift
//  GreenChallenge
//
//  Created by Matheus Alano on 09/01/19.
//  Copyright © 2019 Matheus Alano. All rights reserved.
//

import Foundation
import RxSwift

enum HTTPMethod: String {
    case GET, POST
}

enum ServiceError: Error {
    case cannotParse
    case cannotParseParameters
    case invalidURL
}

class AppService {
    
    private let baseUrl = "http://5b840ba5db24a100142dcd8c.mockapi.io/api/"
    private let session: URLSession
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    func request<T: Decodable>(path: String, method: HTTPMethod, parameters: [String: Any]? = nil) -> Observable<T> {
        guard let url = URL(string: baseUrl + path) else { return Observable.error(ServiceError.invalidURL) }
        var urlRequest = URLRequest(url: url)
        
        if let parameters = parameters {
            do {
                urlRequest.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            } catch _ {
                return Observable.error(ServiceError.cannotParseParameters)
            }
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        urlRequest.httpMethod = method.rawValue
        
        return session.rx
            .json(request: urlRequest)
            .flatMap({ json throws -> Observable<T> in
                do {
                    let jsonData = try JSONDecoder().decode(T.self, from: JSONSerialization.data(withJSONObject: json, options: .prettyPrinted))
                    
                    return Observable.just(jsonData)
                } catch _ {
                    return Observable.error(ServiceError.cannotParse)
                }
            })
    }
    
    func requestNoReturn(path: String, method: HTTPMethod, parameters: [String: Any]? = nil) -> Observable<Bool> {
        guard let url = URL(string: baseUrl + path) else { return Observable.error(ServiceError.invalidURL) }
        var urlRequest = URLRequest(url: url)
        
        if let parameters = parameters {
            do {
                urlRequest.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            } catch _ {
                return Observable.error(ServiceError.cannotParseParameters)
            }
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        urlRequest.httpMethod = method.rawValue
        
        return session.rx
            .json(request: urlRequest)
            .flatMap({ json throws -> Observable<Bool> in
                guard let json = json as? [String: Any], let code = json["code"] as? String else {
                    return Observable.error(ServiceError.cannotParse)
                }
                
                return Observable.just(code.hasPrefix("2"))
            })
    }
}
