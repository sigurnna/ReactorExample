//
//  RepositoryListReactor.swift
//  ReactorExample
//
//  Created by 이승준 on 03/01/2019.
//  Copyright © 2019 seungjun. All rights reserved.
//

import ReactorKit
import RxSwift

class RepositoryListReactor: Reactor {
    
    let initialState = State()
    
    // 유저 액션.
    enum Action {
        case loadRepositories(SupportedLanguage)
        case changeLangauge(SupportedLanguage)
    }
    
    // 상태 변경.
    enum Mutation {
        case setRepositories([RepositoryResponse])
        case setLanguage(SupportedLanguage)
    }
    
    // 뷰의 상태.
    struct State {
        var language = SupportedLanguage.swift
        var repositories = [RepositoryResponse]()
    }
    
    func mutate(action: RepositoryListReactor.Action) -> Observable<RepositoryListReactor.Mutation> {
        switch action {
        case let .loadRepositories(language):
            SearchRepositoryService.shared.requestSearch(language: language.rawValue)
            
            return SearchRepositoryService.shared.response
                .map { (repositories) -> Mutation in
                    return Mutation.setRepositories(repositories)
                }
            
        case let .changeLangauge(language):
            return Observable.just(Mutation.setLanguage(language))
        }
    }
    
    func reduce(state: RepositoryListReactor.State, mutation: RepositoryListReactor.Mutation) -> RepositoryListReactor.State {
        var state = state
        
        switch mutation {
        case let .setRepositories(repositories):
            state.repositories = repositories
        
        case let .setLanguage(language):
            state.repositories.removeAll()
            state.language = language
        }
        
        return state
    }
}
