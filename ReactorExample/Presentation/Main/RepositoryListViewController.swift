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
    
    fileprivate var refresh: RefreshableTableHeaderView!
    fileprivate let triggerRefreshAt: CGFloat = -50
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func didSearchTapped(_ sender: UIBarButtonItem) {
        let vc = RepositorySearchViewController.instance()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func didShowLanguageTapped(_ sender: UIBarButtonItem) {
        let vc = SelectLanguageViewController.instance()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refresh = RefreshableTableHeaderView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50))
        
        tableView.tableHeaderView = refresh
        tableView.contentInset = UIEdgeInsets(top: -50, left: 0, bottom: 0, right: 0)
        
        // Initial View Controller 라서 직접 의존성을 주입함.
        reactor = RepositoryListReactor()
    }
    
    func bind(reactor: RepositoryListReactor) {
        
        // Repository 로딩.
        reactor.state.map { $0.repositories }
            .debug()
            .bind(to: tableView.rx.items(cellIdentifier: RepositoryCell.identifier, cellType: RepositoryCell.self)) { indexPath, repository, cell in
                cell.nameLabel.text = repository.full_name
                cell.descLabel.text = repository.description
                cell.starLabel.text = String(repository.stargazers_count)
            }
            .disposed(by: disposeBag)
        
        // Title 변경.
        reactor.state
            .debug("Language Observable", trimOutput: true)
            .subscribeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] state in
                self?.title = state.language.rawValue
                
                if !(state.repositories.isEmpty) {
                    self?.indicator.stopAnimating()
                }
            })
            .disposed(by: disposeBag)
        
        let languageChangedObservable = self.languageChangedObservable()
        
        // Action: 언어가 변경되면 Change Language Action 전송.
        languageChangedObservable
            .map { Reactor.Action.changeLangauge($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // Action: 언어가 변경되면 Repository Action 전송.
        languageChangedObservable
            .map { Reactor.Action.loadRepositories($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        languageChangedObservable
            .subscribe(onNext: { [weak self] _ in
                self?.indicator.startAnimating()
            })
            .disposed(by: disposeBag)
        
        // Trigger Refresh.
        tableView.rx.contentOffset
            .subscribe(onNext: { [weak self] point in
                guard let weakSelf = self else {
                    return
                }
                
                if point.y <= weakSelf.triggerRefreshAt {
                    // 이 상황에서 유저가 터치를 그만둔 경우 refresh occur.
                }
                
                if point.y <= 0 {
                    print(String(format: "y: %f", point.y))
                    print(String(format: "progress: %f", point.y / weakSelf.triggerRefreshAt))
                    
                    weakSelf.refresh.update(progress: point.y / weakSelf.triggerRefreshAt)
                }
            })
            .disposed(by: disposeBag)
        
        // Send Action
        reactor.action.on(.next(.loadRepositories(SupportedLanguage.swift)))
    }
}

// MARK: - Internal
fileprivate extension RepositoryListViewController {
    
    /// 언어 변경 notification을 받을 경우 변경된 언어를 방출하는 Observable.
    func languageChangedObservable() -> Observable<SupportedLanguage> {
        return NotificationCenter.default.rx.notification(languageSelected)
            .debug("Language Changed Notification Observable", trimOutput: true)
            .flatMap { notification -> Observable<SupportedLanguage> in
                if let userInfo = notification.userInfo as? [String: Any] {
                    if let language = userInfo["language"] as? String, let supportedLanguage = SupportedLanguage(rawValue: language) {
                        return Observable.just(supportedLanguage)
                    }
                }
                
                return Observable.empty()
            }
    }
}
