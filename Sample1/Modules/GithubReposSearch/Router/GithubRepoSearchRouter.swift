//
//  GithubRepoSearchRouter.swift
//  VIPERSample1
//
//  Created by Yoshinori Imajo on 2019/11/04.
//  Copyright © 2019 Yoshinori Imajo. All rights reserved.
//

import UIKit

protocol GithubReposSearchWireframe {
    var searchViewController: UIViewController { get set }

    func presentDetail(_ githubRepoEntity: GithubRepoEntity)
}

struct GithubRepoSearchRouter: GithubReposSearchWireframe {

    let appDependencies: AppDependencies
    // presentやらしたいときに使う
    var searchViewController: UIViewController

    // テストするにはsearchViewControllerのrootをみる
    func presentDetail(_ githubRepoEntity: GithubRepoEntity) {
        let viewController = appDependencies.assembleGithubRepoDetailModule(
            githubRepoEntity: githubRepoEntity
        )

        searchViewController.navigationController?.pushViewController(
            viewController,
            animated: true
        )
    }
}
