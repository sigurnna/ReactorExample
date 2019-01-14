//
//  RepositorySearchViewController.swift
//  ReactorExample
//
//  Created by 이승준 on 10/01/2019.
//  Copyright © 2019 seungjun. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class RepositorySearchViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    let service = SearchRepositoryService()
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupBinds()
    }
}

// MARK: - Internal
fileprivate extension RepositorySearchViewController {
    
    func setupBinds() {
        
        tableView.delegate = nil
        tableView.dataSource = nil
        
        // Search Bind.
        searchBar.rx.text
            .flatMap { Observable.from(optional: $0) }
            .filter { !$0.isEmpty }
            .subscribe(onNext: { [weak self] text in
                // Repository Search
                self?.service.requestSearch(repositoryName: text)
            })
            .disposed(by: disposeBag)
        
        // Search Results Bind.
        service.response
            .do(onNext: { _ in
                print("onNext")
            }, onSubscribe: { [weak self] in
//                self?.tableView.dataSource = nil
//                self?.tableView.delegate = nil
                print("onSubscribe")
            })
            .bind(to: tableView.rx.items(cellIdentifier: "SearchResultCell", cellType: UITableViewCell.self)) { indexPath, repository, cell in
                cell.textLabel?.text = repository.full_name
                cell.detailTextLabel?.text = repository.description
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - ViewControllerInterface
extension RepositorySearchViewController: ViewControllerProtocol {
    static func instance() -> Self {
        return instance(storyboardName: "RepositorySearch", identifier: "\(RepositorySearchViewController.self)")
    }
}
