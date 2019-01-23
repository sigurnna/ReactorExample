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
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewBottomConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupBinds()
        setupKeyboardNotifications()
    }
}

// MARK: - Internal
fileprivate extension RepositorySearchViewController {
    
    func setupBinds() {
        
        searchBar.rx.text
            .flatMap { Observable.from(optional: $0) }
            .filter { !$0.isEmpty }
            .subscribe(onNext: { [weak self] text in
                guard let weakSelf = self else { return }
                
                weakSelf.tableView.delegate = nil
                weakSelf.tableView.dataSource = nil
                
                SearchRepositoryService.shared.requestSearch(repositoryName: text)
                    .debug("RepositorySearchViewController:SearchResult")
                    .bind(to: weakSelf.tableView.rx.items(cellIdentifier: "SearchResultCell", cellType: UITableViewCell.self)) { indexPath, repository, cell in
                        cell.textLabel?.text = repository.full_name
                        cell.detailTextLabel?.text = repository.description
                    }
                    .disposed(by: weakSelf.disposeBag)
            })
            .disposed(by: disposeBag)
    }
    
    func setupKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(sender: NSNotification) {
        let info = sender.userInfo!
        let keyboardHeight = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.height
        let animationDuration: TimeInterval = (info[UIResponder.keyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        
        var safeAreaBottom: CGFloat
        
        if #available(iOS 11.0, *) {
            safeAreaBottom = view.safeAreaInsets.bottom
        } else {
            safeAreaBottom = topLayoutGuide.length
        }
        
        tableViewBottomConstraint.constant = keyboardHeight - safeAreaBottom
        
        UIView.animate(withDuration: animationDuration) { self.view.layoutIfNeeded() }
    }
    
    @objc func keyboardWillHide(sender: NSNotification) {
        let info = sender.userInfo!
        let animationDuration: TimeInterval = (info[UIResponder.keyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        
        // 이 코드는 변경되어야 함.
        tableViewBottomConstraint.constant = 0
        
        UIView.animate(withDuration: animationDuration) {
            self.view.layoutIfNeeded()
        }
    }
}

// MARK: - ViewControllerInterface
extension RepositorySearchViewController: ViewControllerProtocol {
    static func instance() -> Self {
        return instance(storyboardName: "RepositorySearch", identifier: "\(RepositorySearchViewController.self)")
    }
}
