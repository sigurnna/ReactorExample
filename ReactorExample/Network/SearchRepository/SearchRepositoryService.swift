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
    
    let disposeBag = DisposeBag()
    let response = BehaviorSubject<[RepositoryResponse]>(value: [])
    
    /// Language로 Repository 검색.
    func requestSearch(language: String) {
        self.requestSearch(path: "search/repositories?q=language:\(language)&sort=stars")
    }
    
    func requestSearch(repositoryName: String) {
        self.requestSearch(path: "search/repositories?q=\(repositoryName)")
    }
}

// MARK: - Internal
fileprivate extension SearchRepositoryService {
    
    func requestSearch(path: String) {
        NetworkBaseService.shared.request(method: .get, path: path)
            .debug("SearchRepositoryService:requestSearch")
            .map { data -> SearchRepositoryResponse? in
                guard let data = data else {
                    return nil
                }
                
                guard let searchRepository = try? JSONDecoder().decode(SearchRepositoryResponse.self, from: data) else {
                    return nil
                }
                
                return searchRepository
            }
            .flatMapLatest { searchRepository -> Observable<[RepositoryResponse]> in
                guard let searchRepository = searchRepository else {
                    return Observable.just([])
                }
                
                return Observable.just(searchRepository.items)
            }
            .bind(to: self.response)
            .disposed(by: self.disposeBag)
    }
}
