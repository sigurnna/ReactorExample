//
//  ViewControllerProtocol.swift
//  ReactorExample
//
//  Created by 이승준 on 07/01/2019.
//  Copyright © 2019 seungjun. All rights reserved.
//

import UIKit

protocol ViewControllerProtocol {
    static func instance() -> Self
}

extension ViewControllerProtocol {
    
    static func instance(storyboardName: String, identifier: String) -> Self {
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: identifier)
        
        guard let viewController = vc as? Self else {
            fatalError("\(storyboardName) - \(identifier) not matched \(self)")
        }
        
        return viewController
    }
}
