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
    private let searchViewController =
        AppTestDependencies.TestDouble.SearchViewController()

    override func setUp() {
        let navigationController = UINavigationController(
            rootViewController: searchViewController
        )

        let window = UIApplication.shared.windows.first { $0.isKeyWindow }
        window?.rootViewController = navigationController

        router = GithubRepoSearchRouter(
            appDependencies: AppTestDependencies(),
            searchViewController: searchViewController
        )
    }

    func testDetailViewControllerIsPushed() {
        setUp()
        XCTContext.runActivity(named: "Entityを渡されて表示する場合") { _ in
            let entity = GithubRepoEntity(
                id: 1,
                name: "name0",
                htmlURL: URL(string: "html://example.com")!,
                description: "",
                stargazersCount: nil
            )

            router.presentDetail(entity)

            let exp = XCTestExpectation()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                defer {
                    exp.fulfill()
                }

                let navigation = self.searchViewController.navigationController
                let pushedViewController = navigation?.visibleViewController
                XCTAssertTrue(
                    pushedViewController
                        is AppTestDependencies.TestDouble.DetailViewController
                )
            }

            wait(for: [exp], timeout: 5)
        }
    }

    func testPresentErrorAlert() {
        setUp()
        XCTContext.runActivity(named: "Errorを渡されて表示する場合") { _ in
            router.presentAlert(TestDouble.Error())

            let exp = XCTestExpectation()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                defer {
                    exp.fulfill()
                }

                let window = UIApplication.shared.windows.first { $0.isKeyWindow }
                let viewController = window?.rootViewController?.presentedViewController
                let presentedViewController = viewController as? UIAlertController

                XCTAssertEqual(presentedViewController?.message, "エラー文言")
            }

            wait(for: [exp], timeout: 5)
        }
    }
}

extension GithubRepoSearchRouterTests {
    enum TestDouble {
        struct Error: Swift.Error, LocalizedError {
            var errorDescription: String? { "エラー文言" }
        }
    }
}
