//
//  GithubRepoSortInteractorTests.swift
//  Sample1ATests
//
//  Created by Yoshinori Imajo on 2019/12/18.
//  Copyright © 2019 Yoshinori Imajo. All rights reserved.
//

import XCTest
@testable import Sample1A

class GithubRepoSortInteractorTests: XCTestCase {

    func testSortDescendingOrderByStar() {
        let interactor = AnyUseCase(GithubRepoSortInteractor())
        XCTContext.runActivity(named: "スター数が0以上の場合") { _ in
            let stubData: [GithubRepoEntity] = [
                .init(
                    id: 1,
                    name: "name0",
                    htmlURL: URL(string: "http://example.com/0")!,
                    description: "",
                    stargazersCount: 0
                ),
                .init(
                    id: 2,
                    name: "name1",
                    htmlURL: URL(string: "http://example.com/1")!,
                    description: "",
                    stargazersCount: 1
                ),
                .init(
                    id: 3,
                    name: "name2",
                    htmlURL: URL(string: "http://example.com/2")!,
                    description: "",
                    stargazersCount: 2
                )
            ]

            XCTContext.runActivity(named: "スター数降順で表示される") { _ in
                let exp = XCTestExpectation()
                interactor.execute(stubData) { result in
                    switch result {
                    case .success(let value):
                        exp.fulfill()
                        XCTAssertEqual(
                            value,
                            [
                                stubData[2],
                                stubData[1],
                                stubData[0]
                            ]
                        )
                    case .failure:
                        XCTFail()
                    }
                }

                wait(for: [exp], timeout: 0.1)
            }
        }

        XCTContext.runActivity(named: "スター数がnilの場合") { _ in
            let stubData: [GithubRepoEntity] = [
                .init(
                    id: 1,
                    name: "name0",
                    htmlURL: URL(string: "http://example.com/0")!,
                    description: "",
                    stargazersCount: 0
                ),
                .init(
                    id: 2,
                    name: "name1",
                    htmlURL: URL(string: "http://example.com/1")!,
                    description: "",
                    stargazersCount: 1
                ),
                .init(
                    id: 3,
                    name: "name2",
                    htmlURL: URL(string: "http://example.com/2")!,
                    description: "",
                    stargazersCount: nil
                )
            ]

            XCTContext.runActivity(named: "nilはスター数0より低く表示される") { _ in
                let exp = XCTestExpectation()

                interactor.execute(stubData) { result in
                    switch result {
                    case .success(let value):
                        exp.fulfill()
                        //
                        XCTAssertEqual(
                            value,
                            [
                                stubData[1],
                                stubData[0],
                                stubData[2]
                            ]
                        )
                    case .failure:
                        XCTFail()
                    }
                }

                wait(for: [exp], timeout: 0.1)
            }
        }
    }
}
