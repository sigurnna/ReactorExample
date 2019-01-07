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
        case viewDidLoad
        // case changeLangauge(SupportedLanguage)
    }
    
    // 상태 변경.
    enum Mutation {
        case appendRepositories(RepositoryResponse)
    }
    
    // 뷰의 상태.
    struct State {
        var language = SupportedLanguage.swift
        var repositories = [RepositoryResponse]()
    }
    
    func mutate(action: RepositoryListReactor.Action) -> Observable<RepositoryListReactor.Mutation> {
        switch action {
        case .viewDidLoad:
            return SearchRepositoryService.requestSearch(language: SupportedLanguage.swift.rawValue)
                .map { (repository) -> Mutation in
                    return Mutation.appendRepositories(repository)
                }
        }
    }
    
    func reduce(state: RepositoryListReactor.State, mutation: RepositoryListReactor.Mutation) -> RepositoryListReactor.State {
        var state = state
        
        switch mutation {
        case let .appendRepositories(repository):
            state.repositories.append(repository)
            return state
        }
    }
}
