//
//  DependencyInjectable.swift
//  VIPERSample1
//
//  Created by Yoshinori Imajo on 2019/11/16.
//  Copyright © 2019 Yoshinori Imajo. All rights reserved.
//

import Foundation

protocol DependencyInjectable {
    associatedtype Dependency
    func inject(_ dependency: Dependency)
}
