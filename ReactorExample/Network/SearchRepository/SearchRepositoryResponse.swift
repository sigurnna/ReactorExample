//
//  SearchRepositoryResponse.swift
//  ReactorExample
//
//  Created by 이승준 on 04/01/2019.
//  Copyright © 2019 seungjun. All rights reserved.
//

struct SearchRepositoryResponse: NetworkBaseResponse {
    var total_count: Int
    var incomplete_results: Bool
    var items: [RepositoryResponse]
}

struct RepositoryResponse: NetworkBaseResponse {
    var full_name: String
    var description: String?
    var stargazers_count: Int
}
