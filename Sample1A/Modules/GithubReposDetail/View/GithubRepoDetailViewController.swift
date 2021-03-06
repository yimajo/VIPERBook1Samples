//
//  GithubReposDetailViewController.swift
//  Sample1A
//
//  Created by Yoshinori Imajo on 2019/11/04.
//  Copyright © 2019 Yoshinori Imajo. All rights reserved.
//

import UIKit
import WebKit

class GithubRepoDetailViewController: UIViewController {
    struct Dependency {
        let presenter: GithubRepoDetailPresentation
        let githubRepoEntity: GithubRepoEntity
    }

    @IBOutlet private var webView: WKWebView!
    private var dependency: Dependency!

    deinit {
        print("debug: deinit GithubRepoDetailViewController")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        dependency.presenter.createLoadRequest(with: dependency.githubRepoEntity.htmlURL)
    }
}

extension GithubRepoDetailViewController: GithubRepoDetailView {
    func requestCreated(_ request: URLRequest) {
        webView.load(request)
    }
}

extension GithubRepoDetailViewController: DependencyInjectable {
    func inject(_ dependency: Dependency) {
        self.dependency = dependency
    }
}
