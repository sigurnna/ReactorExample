//
//  SearchRepositoryService.swift
//  ReactorExample
//
//  Created by 이승준 on 04/01/2019.
//  Copyright © 2019 seungjun. All rights reserved.
//

import Alamofire
import RxSwift

/// Repository 검색 요청.
class SearchRepositoryService {
    private init() { }
    
    static func requestSearch(language: String) -> Observable<RepositoryResponse> {
        let url = "https://api.github.com/search/repositories?q=language:\(language)&sort=stars"
        
        return NetworkService.shared.request(method: .get, url: url)
            .map { data -> SearchRepositoryResponse? in
                guard let data = data else {
                    return nil
                }
                
                guard let searchRepository = try? JSONDecoder().decode(SearchRepositoryResponse.self, from: data) else {
                    return nil
                }
                
                return searchRepository
            }
            .flatMap { searchRepository -> Observable<RepositoryResponse> in
                guard let searchRepository = searchRepository else {
                    return Observable.from(optional: nil)
                }
                
                return Observable.from(searchRepository.items)
            }
    }
}
