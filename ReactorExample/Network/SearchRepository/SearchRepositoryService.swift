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
    static let shared = SearchRepositoryService()
    
    private init() { }
    
    var response = Observable<[RepositoryResponse]>.just([])
    
    /// Language로 Repository 검색.
    func requestSearch(language: String) {
        self.requestSearch(path: "search/repositories?q=language:\(language)&sort=stars")
    }
    
    /// Repository Name으로 Repository 검색.
    func requestSearch(repositoryName: String) {
        self.requestSearch(path: "search/repositories?q=\(repositoryName)")
    }
}

// MARK: - Internal
fileprivate extension SearchRepositoryService {
    
    func requestSearch(path: String) {
        NetworkBaseService.shared.request(method: .get, path: path)
        
        self.response = NetworkBaseService.shared.response
            .debug("SearchRepositoryService:requestSearch")
            .map { data -> SearchRepositoryResponse? in
                do {
                    return try JSONDecoder().decode(SearchRepositoryResponse.self, from: data)
                } catch let error {
                    print(error)
                    return nil
                }
            }
            .flatMapLatest { searchRepository -> Observable<[RepositoryResponse]> in // 이전 Observable을 unsubscribe 처리함.
                guard let searchRepository = searchRepository else {
                    return Observable.just([])
                }
                
                return Observable.just(searchRepository.items)
            }
    }
}
