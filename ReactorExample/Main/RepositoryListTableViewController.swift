//
//  ViewController.swift
//  ReactorExample
//
//  Created by 이승준 on 02/01/2019.
//  Copyright © 2019 seungjun. All rights reserved.
//

import UIKit
import ReactorKit
import RxSwift
import RxCocoa

class RepositoryListTableViewController: UITableViewController, StoryboardView {
    
    var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initial View Controller 라서, 직접 의존성을 주입함.
        self.reactor = RepositoryListReactor()
        self.reactor?.action.on(.next(.viewDidLoad))
    }
    
    func bind(reactor: RepositoryListReactor) {
        // State
        reactor.state.map { $0.repositories }
            .bind(to: tableView.rx.items(cellIdentifier: RepositoryCell.identifier, cellType: RepositoryCell.self)) { indexPath, repository, cell in
                cell.nameLabel.text = repository.full_name
                cell.descLabel.text = repository.description
                cell.starLabel.text = String(repository.stargazers_count)
            }
            .disposed(by: disposeBag)
    }
}

