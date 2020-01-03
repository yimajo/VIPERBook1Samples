//
//  GithubRepoSearchRouter.swift
//  Sample1A
//
//  Created by Yoshinori Imajo on 2019/11/04.
//  Copyright © 2019 Yoshinori Imajo. All rights reserved.
//

import UIKit

// MARK: - Contract

protocol GithubReposSearchWireframe {
    var searchViewController: UIViewController { get set }

    func presentDetail(_ githubRepoEntity: GithubRepoEntity)
    func presentAlert(_ error: Error)
}

// MARK: - Router

struct GithubRepoSearchRouter: GithubReposSearchWireframe {

    let appDependencies: AppDependencies
    // presentしたい際に使う
    var searchViewController: UIViewController

    func presentDetail(_ githubRepoEntity: GithubRepoEntity) {
        let viewController = appDependencies.assembleGithubRepoDetailModule(
            githubRepoEntity: githubRepoEntity
        )

        searchViewController.navigationController?.pushViewController(
            viewController,
            animated: true
        )
    }

    func presentAlert(_ error: Error) {
        let alert = UIAlertController(title: "通信エラー",
                                      message: error.localizedDescription,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        searchViewController.present(alert, animated: true)
    }
}
