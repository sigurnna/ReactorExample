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
        // State: Repository
        reactor.state.map { $0.repositories }
            .debug()
            .bind(to: tableView.rx.items(cellIdentifier: RepositoryCell.identifier, cellType: RepositoryCell.self)) { indexPath, repository, cell in
                cell.nameLabel.text = repository.full_name
                cell.descLabel.text = repository.description
                cell.starLabel.text = String(repository.stargazers_count)
            }
            .disposed(by: disposeBag)
        
        // State: Language
        reactor.state.map { $0.language }
            .debug("Language Observable", trimOutput: true)
            .subscribeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] language in
                self?.title = language.rawValue
            })
            .disposed(by: disposeBag)
        
        // Action: 언어가 변경되면 Change Language Action 전송.
        languageChangedObservable()
            .map { Reactor.Action.changeLangauge($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // Action: 언어가 변경되면 Repository Action 전송.
        languageChangedObservable()
            .map { Reactor.Action.loadRepositories($0) }
            .bind(to: reactor.action)
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
            .debug("Notification Observable", trimOutput: true)
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
