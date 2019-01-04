//
//  ReactorExampleTests.swift
//  ReactorExampleTests
//
//  Created by 이승준 on 02/01/2019.
//  Copyright © 2019 seungjun. All rights reserved.
//

import XCTest
import RxSwift
import RxAlamofire
@testable import ReactorExample

class ReactorExampleTests: XCTestCase {
    
    let disposeBag = DisposeBag()

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSearchRepositories() {
        let expt = expectation(description: "Test Network Service")
        
        SearchRepositoryService
            .requestSearch(language: "Swift")
            .subscribe(onNext: { response in
                print(response)
            }, onCompleted: {
                expt.fulfill()
            })
            .disposed(by: disposeBag)
        
        wait(for: [expt], timeout: 10.0)
    }
}
