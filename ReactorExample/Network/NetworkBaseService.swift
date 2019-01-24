//
//  NetworkService.swift
//  ReactorExample
//
//  Created by 이승준 on 04/01/2019.
//  Copyright © 2019 seungjun. All rights reserved.
//

import RxSwift
import RxAlamofire
import Alamofire

class NetworkBaseService {
    static let shared = NetworkBaseService()
    
    fileprivate let baseURL = "https://api.github.com/"
    
    // Cannot use init.
    private init() { }
    
    /// Network Error를 무시하는 request.
    func request(method: HTTPMethod, path: String) -> Observable<Data> {
        guard let url = URL(string: baseURL + path) else {
            fatalError("URL is not valid")
        }
        
        return RxAlamofire.request(method, url)
            .debug("NetworkBaseService:request")
            .responseJSON()
            .flatMapLatest { Observable.from(optional: $0.data) }
    }
    
    /// Network Error를 emit 하는 request.
    func requestWithEmitError(method: HTTPMethod, path: String) -> Observable<Data> {
        guard let url = URL(string: baseURL + path) else {
            fatalError("URL is not valid")
        }
        
        return RxAlamofire.request(method, url)
            .debug("NetworkBaseService:requestWithEmitError")
            .responseData()
            .flatMapLatest { response -> Observable<Data> in
                if 200 ..< 300 ~= response.0.statusCode {
                    return Observable.just(response.1)
                } else {
                    var userInfo = [String: Any]()
                    userInfo["url_response"] = response.0   // HTTPURLResponse
                    userInfo["raw_response"] = String(data: response.1, encoding: .utf8) // Raw Response
                    
                    let error = NSError(domain: url.absoluteString, code: response.0.statusCode, userInfo: userInfo)
                    
                    return Observable.error(error as Error)
                }
            }
    }
}
