//
//  GithubRepoSearchRouterTests.swift
//  Sample1
//
//  Created by Yoshinori Imajo on 2019/11/16.
//  Copyright © 2019 Yoshinori Imajo. All rights reserved.
//

import XCTest
@testable import Sample1A

class GithubRepoSearchRouterTests: XCTestCase {
    private var router: GithubRepoSearchRouter!
    // テストの範囲内で本物と同じように動作するTest DoubleはFake Object。
    // 実際のGithubRepoSearchViewControllerを使うとライフサイクルが動作してしまうので同じ動作をすればいいのでFake。
    private let searchViewController = AppTestDependencies.TestDouble.SearchViewController()

    override func setUp() {
        let navigationController = UINavigationController(rootViewController: searchViewController)
        UIApplication.shared.windows.first { $0.isKeyWindow }?.rootViewController = navigationController

        router = GithubRepoSearchRouter(
            appDependencies: AppTestDependencies(),
            searchViewController: searchViewController
        )
    }

    func testDetailViewControllerIsPushed() {
        setUp()
        let entity = GithubRepoEntity(
            name: "name0",
            htmlUrlString: "",
            description: "",
            stargazersCount: nil
        )

        router.presentDetail(entity)

        let exp = XCTestExpectation()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            defer {
                exp.fulfill()
            }

            let pushedViewController = self.searchViewController.navigationController?.visibleViewController
            XCTAssertTrue(pushedViewController is AppTestDependencies.TestDouble.DetailViewController)
        }

        wait(for: [exp], timeout: 5)
    }

    func testPresentErrorAlert() {
        setUp()
        router.presentAlert(TestDouble.Error())

        let exp = XCTestExpectation()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            defer {
                exp.fulfill()
            }

            let presentedViewController = UIApplication.shared.windows.first { $0.isKeyWindow }?.rootViewController?.presentedViewController as? UIAlertController

            XCTAssertNotNil(presentedViewController)
            XCTAssertEqual(presentedViewController?.message, "それっぽいエラー文言")
        }

        wait(for: [exp], timeout: 5)
    }
}

extension GithubRepoSearchRouterTests {
    enum TestDouble {
        struct Error: Swift.Error, LocalizedError {
            var errorDescription: String? { "それっぽいエラー文言" }
        }
    }
}
