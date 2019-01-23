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
    
    func request(method: HTTPMethod, path: String) -> Observable<Data> {
        guard let url = URL(string: baseURL + path) else {
            fatalError("URL is not valid")
        }
        
        return RxAlamofire.request(method, url)
            .debug("NetworkBaseService:request")
            .do(onNext: { request in
                print("onNext")
            }, onError: { error in
                print("onError")
            }, onCompleted: {
                print("onCompleted")
            }, onSubscribe: {
                print("onSubscribe")
            }, onSubscribed: {
                print("onSubscribed")
            }, onDispose: {
                print("onDispose")
            })
            .responseJSON()
            .flatMapLatest { Observable.from(optional: $0.data) }
    }
}
