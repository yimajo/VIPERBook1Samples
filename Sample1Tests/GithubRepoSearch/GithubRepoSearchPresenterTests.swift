//
//  GithubRepoSearchPresenterTests.swift
//  Sample1
//
//  Created by Yoshinori Imajo on 2019/11/04.
//  Copyright © 2019 Yoshinori Imajo. All rights reserved.
//

import XCTest
@testable import Sample1

class GithubRepoSearchPresenterTests: XCTestCase {
    // このテストはPresenterの入力をテストする
    private var presenter: GithubRepoSearchPresenter!
    // viewは何もしない
    private let view = TestDouble.ViewController()
    // Presenterの特定の入力によりrouterは特定のメソッドが実行されることを確認することでPresenterの入力を検証する
    private var router: TestDouble.Router!
    // Interactorは通信せずダミーを返す
    private var interactor: TestDouble.Interactor!

    override func setUp() {
        router = TestDouble.Router(searchViewController: view)
        interactor = TestDouble.Interactor()
        
        presenter = GithubRepoSearchPresenter(
            dependency: .init(wireframe: router, githubRepoSearchUseCase: interactor)
        )
    }

    func testPresenterInput() {
        // searchを呼び出す前
        XCTContext.runActivity(named: "searchを一度も呼び出していない場合") { _ in
            XCTContext.runActivity(named: "Sectionは固定値を返す") { _ in
                XCTAssertEqual(presenter.numberOfListSection, 2)
                XCTAssertEqual(presenter.listDescription(section: 0), "おすすめ")
                XCTAssertEqual(presenter.listDescription(section: 1), "検索結果 0件")
            }

            XCTContext.runActivity(named: "Section: 0は固定値を返す") { _ in
                let section = 0

                XCTAssertEqual(presenter.numberOfListItems(section: section), 3)
                XCTAssertEqual(
                    presenter.listItem(with: IndexPath(item: 0, section: section))?.name,
                    "objcio/issue-13-viper"
                )
                XCTAssertEqual(
                    presenter.listItem(with: IndexPath(item: 1, section: section))?.name,
                    "objcio/issue-13-viper-swift"
                )
                XCTAssertEqual(
                    presenter.listItem(with: IndexPath(item: 2, section: section))?.name,
                    "pedrohperalta/Articles-iOS-VIPER"
                )

                XCTContext.runActivity(named: "Section: 0をタップ") { _ in
                    XCTContext.runActivity(named: "row: 0をタップ") { _ in
                        presenter.selectItem(with: IndexPath(row: 0, section: section))
                        XCTAssertEqual(router.githubRepoEntity?.name, "objcio/issue-13-viper")
                    }

                    XCTContext.runActivity(named: "row: 1をタップ") { _ in
                        presenter.selectItem(with: IndexPath(row: 1, section: section))
                        XCTAssertEqual(router.githubRepoEntity?.name, "objcio/issue-13-viper-swift")
                    }

                    XCTContext.runActivity(named: "row: 2をタップ") { _ in
                        presenter.selectItem(with: IndexPath(row: 2, section: section))
                        XCTAssertEqual(router.githubRepoEntity?.name, "pedrohperalta/Articles-iOS-VIPER")
                    }
                }
            }

            XCTContext.runActivity(named: "Section: 1はデータがない") { _ in
                let section = 1

                XCTAssertEqual(presenter.numberOfListItems(section: section), 0)
                XCTAssertNil(presenter.listItem(with: IndexPath(item: 0, section: section)))
            }
        }

        XCTContext.runActivity(named: "searchを呼び出した後") { _ in
            XCTContext.runActivity(named: "Section: 1は用意した値を返しアクセスできる") { _ in
                let section = 1

                let testData: [GithubRepoEntity] = [
                    .init(name: "name0", htmlUrlString: "", description: "", stargazersCount: nil),
                    .init(name: "name1", htmlUrlString: "", description: "", stargazersCount: nil)
                ]

                interactor.stubData = testData

                let exp = XCTestExpectation()

                presenter.search("") { result in
                    exp.fulfill()

                    XCTContext.runActivity(named: "用意した値を返す") { _ in
                        XCTAssertEqual(self.presenter.numberOfListItems(section: section), 2)
                        XCTAssertEqual(
                            self.presenter.listItem(with: IndexPath(item: 0, section: section))?.name,
                            testData.first?.name
                        )

                        XCTAssertEqual(
                            self.presenter.listItem(with: IndexPath(item: 1, section: section))?.name,
                            testData.last?.name
                        )
                    }

                    XCTContext.runActivity(named: "タップ") { _ in
                        self.presenter.selectItem(with: IndexPath(row: 0, section: section))
                        XCTAssertEqual(self.router.githubRepoEntity?.name, testData.first?.name)
                    }
                }

                wait(for: [exp], timeout: 5)
            }
        }
    }
}

extension GithubRepoSearchPresenterTests {
    enum TestDouble {
        class ViewController: UIViewController {}

        class Router: GithubReposSearchWireframe {
            var searchViewController: UIViewController
            var githubRepoEntity: GithubRepoEntity?

            init(searchViewController: UIViewController) {
                self.searchViewController = searchViewController
            }

            func presentDetail(_ githubRepoEntity: GithubRepoEntity) {
                // メソッドが呼び出されたことを検証するためプロパティにセットする
                self.githubRepoEntity = githubRepoEntity
            }
        }

        class Interactor: GithubRepoSearchUseCase {
            // テスト用に関節入力としてセットし出力するものをスタブとする(Interactorがスタブ）。
            // そのスタブのデータ
            var stubData: [GithubRepoEntity]?

            func search(
                from word: String,
                completion: @escaping (Result<[GithubRepoEntity], Error>) -> ()
            ) {
                DispatchQueue.main.async {
                    completion(.success(self.stubData!))
                }
            }
        }
    }
}
