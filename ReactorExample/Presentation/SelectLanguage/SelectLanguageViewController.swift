//
//  SelectLanguageViewController.swift
//  ReactorExample
//
//  Created by 이승준 on 07/01/2019.
//  Copyright © 2019 seungjun. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SelectLanguageViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupBinds()
    }
    
    func setupBinds() {
        // Languages
        Observable.from(SupportedLanguage.list)
            .debug()
            .bind(to: tableView.rx.items(cellIdentifier: "LanguageCell")) { indexPath, language, cell in
                cell.textLabel?.text = language
            }
            .disposed(by: disposeBag)
        
        // Language Selected
        tableView.rx.itemSelected
            .debug()
            .subscribe(onNext: { [weak self] indexPath in
                if let selectedLanguage = self?.tableView.cellForRow(at: indexPath)?.textLabel?.text {
                    NotificationCenter.default.post(name: languageSelected, object: nil, userInfo: ["language": selectedLanguage])
                    
                    self?.navigationController?.popViewController(animated: true)
                }
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - ViewControllerProtocol
extension SelectLanguageViewController: ViewControllerProtocol {
    static func instance() -> Self {
        return instance(storyboardName: "SelectLanguage", identifier: "\(SelectLanguageViewController.self)")
    }
}
