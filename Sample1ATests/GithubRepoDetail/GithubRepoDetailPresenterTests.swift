//
//  GithubRepoDetailPresenterTests.swift
//  Sample1
//
//  Created by Yoshinori Imajo on 2019/11/04.
//  Copyright © 2019 Yoshinori Imajo. All rights reserved.
//

import XCTest
@testable import Sample1A

class GithubRepoDetailPresenterTests: XCTestCase {
    private var presenter: GithubRepoDetailPresenter!
    private let view = TestDouble.ViewController()

    override func setUp() {
        let router = TestDouble.DetailRouter(detailViewController: view)
        presenter = GithubRepoDetailPresenter(
            wireframe: router,
            view: view
        )
    }

    func testCreqteLoadRequest() {
        XCTContext.runActivity(named: "createLoadRequest前") { _ in
            XCTContext.runActivity(named: "request作成していない") { _ in
                XCTAssertNil(view.request)
            }
        }

        XCTContext.runActivity(named: "createLoadRequest後") { _ in
            presenter.createLoadRequest(with: URL(string:"https://google.com")!)
            XCTContext.runActivity(named: "request作成した") { _ in
                XCTAssertEqual(view.request?.url, URL(string: "https://google.com"))
            }
        }
    }
}

extension GithubRepoDetailPresenterTests {
    enum TestDouble {
        struct DetailRouter: GithubRepoDetailWireframe {
            unowned let detailViewController: UIViewController
        }

        class ViewController: UIViewController, GithubRepoDetailView {
            var request: URLRequest?

            func requestCreated(_ request: URLRequest) {
                self.request = request
            }
        }
    }
}
