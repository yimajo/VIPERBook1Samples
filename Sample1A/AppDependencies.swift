//
//  AppDependencies.swift
//  Sample1A
//
//  Created by Yoshinori Imajo on 2019/11/19.
//  Copyright © 2019 Yoshinori Imajo. All rights reserved.
//

import UIKit

// クリーンアーキテクチャ本でいうところの「メインモジュール」
// テスト時に必要があれば入れ替える
public struct AppDefaultDependencies {
    let bundle = Bundle(identifier: "jp.co.curiosity.Sample1A")

    public init() {}

    public func rootViewController() -> UIViewController {
        return assembleGithubRepoSearchModule()
    }
}

protocol AppDependencies {
    // UIViewControllerを返すようにしてほしい
    // 依存性のごちゃごちゃはassembleでやって外に出すときはUIViewController
    func assembleGithubRepoSearchModule() -> UIViewController

    func assembleGithubRepoDetailModule(githubRepoEntity: GithubRepoEntity) -> UIViewController
}

extension AppDefaultDependencies: AppDependencies {
    public func assembleGithubRepoSearchModule() -> UIViewController {
        let viewController = { () -> GithubRepoSearchViewController in
            let storyboard = UIStoryboard(name: "GithubRepoSearch", bundle: bundle)
            return storyboard.instantiateInitialViewController() as! GithubRepoSearchViewController
        }()

        let router = GithubRepoSearchRouter(
            appDependencies: self,
            searchViewController: viewController
        )

        let presenter = GithubRepoSearchPresenter(
            view: viewController,
            dependency: .init(
                wireframe: router,
                githubRepoRecommend: AnyUseCase(GithubRepoRecommendInteractor()),
                githubRepoSearch: AnyUseCase(GithubRepoSearchInteractor())
            )
        )

        viewController.inject(.init(presenter: presenter))

        return viewController
    }

    func assembleGithubRepoDetailModule(githubRepoEntity: GithubRepoEntity) -> UIViewController {

        let viewController = { () -> GithubRepoDetailViewController in
            let storyboard = UIStoryboard(name: "GithubRepoDetail", bundle: bundle)
            return storyboard.instantiateInitialViewController() as! GithubRepoDetailViewController
        }()

        let router = GithubRepoDetailRouter(
            detailViewController: viewController
        )

        let presenter = GithubRepoDetailPresenter(wireframe: router, view: viewController)
        viewController.inject(.init(presenter: presenter, githubRepoEntity: githubRepoEntity))

        return viewController
    }
}
