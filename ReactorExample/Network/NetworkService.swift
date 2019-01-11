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

class NetworkService {
    static let shared = NetworkService()
    
    fileprivate let baseURL = "https://api.github.com/"
    fileprivate let disposeBag = DisposeBag()
    
    let response = PublishSubject<Data?>()
    
    // Cannot use init.
    private init() { }
    
    func request(method: HTTPMethod, path: String) {
        guard let url = URL(string: baseURL + path) else {
            fatalError("URL is not valid")
        }
        
        RxAlamofire.request(method, url)
            .debug()
            .validate(statusCode: 200 ..< 300)
            .responseJSON()
            .flatMapLatest { Observable.just($0.data) }
            .bind(to: response)
            .disposed(by: disposeBag)
    }
}
