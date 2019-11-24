//
//  GithubRepoDetailPresentation.swift
//  Sample1A
//
//  Created by Yoshinori Imajo on 2019/11/04.
//  Copyright © 2019 Yoshinori Imajo. All rights reserved.
//

import Foundation

protocol GithubRepoDetailPresentation {
    func createLoadRequest(with urlString: String)
}

protocol GithubRepoDetailView: class {
    func requestCreated(_ request: URLRequest)
}
