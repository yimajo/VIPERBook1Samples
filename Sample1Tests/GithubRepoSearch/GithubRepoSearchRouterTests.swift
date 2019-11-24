//
//  GithubRepoSearchRouterTests.swift
//  Sample1
//
//  Created by Yoshinori Imajo on 2019/11/16.
//  Copyright © 2019 Yoshinori Imajo. All rights reserved.
//

import XCTest
@testable import Sample1

class GithubRepoSearchRouterTests: XCTestCase {
    private var router: GithubRepoSearchRouter!
    // テストの範囲内で本物と同じように動作するTest DoubleはFake Object。
    // 実際のGithubRepoSearchViewControllerを使うとライフサイクルが動作してしまうので同じ動作をすればいいのでFake。
    private let searchViewController = UIViewController()

    override func setUp() {
        let navigationController = UINavigationController(rootViewController: searchViewController)
        UIApplication.shared.windows.first { $0.isKeyWindow }?.rootViewController = navigationController

        router = GithubRepoSearchRouter(
            appDependencies: AppTestDependencies(),
            searchViewController: searchViewController
        )
    }

    func testDetailViewControllerIsPushed() {

        let entity = GithubRepoEntity(
            name: "name0",
            htmlUrlString: "",
            description: "",
            stargazersCount: nil
        )

        router.presentDetail(entity)

        let exp = XCTestExpectation()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            exp.fulfill()

            let pushedViewController = self.searchViewController.navigationController?.visibleViewController
            XCTAssertTrue(pushedViewController is AppTestDependencies.TestDouble.ViewController)
        }

        wait(for: [exp], timeout: 5)
    }
}
