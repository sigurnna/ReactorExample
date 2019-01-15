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
    
    // Observables
    
    
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

        // Search Bind.
        searchBar.rx.text
            .flatMap { Observable.from(optional: $0) }
            .filter { !$0.isEmpty }
            .subscribe(onNext: { [weak self] text in
                guard let weakSelf = self else { return }
                
                weakSelf.tableView.dataSource = nil
                weakSelf.tableView.delegate = nil
                
                // Repository Search
                weakSelf.service.requestSearch(repositoryName: text)
                
                // Search Results Bind To TableView
                weakSelf.service.response
                    .debug()
                    .bind(to: weakSelf.tableView.rx.items(cellIdentifier: "SearchResultCell", cellType: UITableViewCell.self)) { indexPath, repository, cell in
                        cell.textLabel?.text = repository.full_name
                        cell.detailTextLabel?.text = repository.description
                    }
                    .disposed(by: weakSelf.disposeBag)
            })
            .disposed(by: disposeBag)
        
        // Test
        service.response
            .subscribe(onNext: { response in
                print("onNext\n")
                print(response)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - ViewControllerInterface
extension RepositorySearchViewController: ViewControllerProtocol {
    static func instance() -> Self {
        return instance(storyboardName: "RepositorySearch", identifier: "\(RepositorySearchViewController.self)")
    }
}
