//
//  SearchRepositoryService.swift
//  ReactorExample
//
//  Created by 이승준 on 04/01/2019.
//  Copyright © 2019 seungjun. All rights reserved.
//

import Alamofire
import RxSwift
import RxCocoa

/// Repository 검색 요청.
class SearchRepositoryService {
    static let shared = SearchRepositoryService()
    
    private init() { }
    
    /// Language로 Repository 검색.
    func requestSearch(language: String) -> Observable<[RepositoryResponse]> {
        return requestSearch(path: "search/repositories?q=language:\(language)&sort=stars")
    }
    
    /// Repository Name으로 Repository 검색.
    func requestSearch(repositoryName: String) -> Observable<[RepositoryResponse]> {
        return requestSearch(path: "search/repositories?q=\(repositoryName)")
    }
}

// MARK: - Internal
fileprivate extension SearchRepositoryService {
    
    func requestSearch(path: String) -> Observable<[RepositoryResponse]> {
        return NetworkBaseService.shared.request(method: .get, path: path)
            .debug("SearchRepositoryService:requestSearch")
            .map { data -> SearchRepositoryResponse? in
                do {
                    return try JSONDecoder().decode(SearchRepositoryResponse.self, from: data)
                } catch let error {
                    print(error)
                    print(String(data: data, encoding: .utf8) ?? "")
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
