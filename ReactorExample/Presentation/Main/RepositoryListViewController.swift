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

class RepositoryListViewController: UIViewController, StoryboardView {
    
    var disposeBag = DisposeBag()
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func didSearchTapped(_ sender: UIBarButtonItem) {
        
    }
    
    @IBAction func didShowLanguageTapped(_ sender: UIBarButtonItem) {
        let vc = SelectLanguageViewController.instance()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initial View Controller 라서 직접 의존성을 주입함.
        reactor = RepositoryListReactor()
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
        
        
        
        // Send Action
        reactor.action.on(.next(.viewDidLoad))
    }
}
