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

class RepositoryListTableViewController: UITableViewController, StoryboardView {
    
    var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initial View Controller 라서, 직접 의존성을 주입함.
        self.reactor = RepositoryListReactor()
    }
    
    func bind(reactor: RepositoryListReactor) {
        
    }
}

