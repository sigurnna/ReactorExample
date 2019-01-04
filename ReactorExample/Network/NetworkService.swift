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
    
    // Cannot use init.
    private init() { }
    
    func request(method: HTTPMethod, url: String) -> Observable<Data?> {
        guard let url = URL(string: url) else {
            fatalError("URL is not valid")
        }
        
        return RxAlamofire.request(method, url)
            .validate(statusCode: 200 ..< 300)
            .responseJSON()
            .map { $0.data }
    }
}
