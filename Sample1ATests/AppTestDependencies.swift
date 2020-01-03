//
//  AppTestDependencies.swift
//  Sample1
//
//  Created by Yoshinori Imajo on 2019/11/17.
//  Copyright © 2019 Yoshinori Imajo. All rights reserved.
//

import UIKit
@testable import Sample1A

struct AppTestDependencies: AppDependencies {

    func assembleGithubRepoSearchModule() -> UIViewController {
        let viewController = TestDouble.SearchViewController()
        return viewController
    }

    func assembleGithubRepoDetailModule(
        githubRepoEntity: GithubRepoEntity
    ) -> UIViewController {
        let viewController = TestDouble.DetailViewController()
        return viewController
    }
}

extension AppTestDependencies {
    enum TestDouble {
        class SearchViewController: UIViewController {}
        class DetailViewController: UIViewController {}
    }
}
