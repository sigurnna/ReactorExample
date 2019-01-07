//
//  GlobalDefines.swift
//  ReactorExample
//
//  Created by 이승준 on 07/01/2019.
//  Copyright © 2019 seungjun. All rights reserved.
//

enum SupportedLanguage: String {
    case swift = "Swift"
    case objc = "Objective-C"
    case java = "Java"
    case python = "Python"
    case ruby = "Ruby"
    
    static var list: [String] {
        return [self.swift.rawValue, self.objc.rawValue, self.java.rawValue, self.python.rawValue, self.ruby.rawValue]
    }
}
