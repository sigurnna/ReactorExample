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

    var response = Observable<Data>.from(optional: nil)
    
    fileprivate let baseURL = "https://api.github.com/"
    fileprivate let disposeBag = DisposeBag()
    
    // Cannot use init.
    private init() { }
    
    func request(method: HTTPMethod, path: String) {
        guard let url = URL(string: baseURL + path) else {
            fatalError("URL is not valid")
        }
        
        self.response = RxAlamofire.request(method, url)
            .debug("NetworkBaseService:request")
            .validate(statusCode: 200 ..< 300)
            .responseJSON()
            .flatMapLatest { Observable.from(optional: $0.data) }
    }
}
