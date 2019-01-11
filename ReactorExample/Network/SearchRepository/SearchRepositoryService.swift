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
    
    /// Language로 Repository 검색.
    static func requestSearch(language: String) -> Observable<[RepositoryResponse]> {
        let path = "search/repositories?q=language:\(language)&sort=stars"
        
        return requestSearch(path: path)
    }
    
    static func requestSearch(repositoryName: String) -> Observable<[RepositoryResponse]> {
        let path = "search/repositories?q=\(repositoryName)"
        
        return requestSearch(path: path)
    }
}

// MARK: - Internal
fileprivate extension SearchRepositoryService {
    
    static func requestSearch(path: String) -> Observable<[RepositoryResponse]> {
        NetworkService.shared.request(method: .get, path: path)
        
        return NetworkService.shared.response
            .map { data -> SearchRepositoryResponse? in
                guard let data = data else {
                    return nil
                }
                
                guard let searchRepository = try? JSONDecoder().decode(SearchRepositoryResponse.self, from: data) else {
                    return nil
                }
                
                return searchRepository
            }
            .flatMap { searchRepository -> Observable<[RepositoryResponse]> in
                guard let searchRepository = searchRepository else {
                    return Observable.just([])
                }
                
                return Observable.just(searchRepository.items)
            }
    }
}
