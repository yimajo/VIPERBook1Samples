//
//  GithubRepoSearchPresenterTests.swift
//  Sample1A
//
//  Created by Yoshinori Imajo on 2019/11/04.
//  Copyright © 2019 Yoshinori Imajo. All rights reserved.
//

import XCTest
@testable import Sample1A

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
            view: view,
            dependency: .init(
                wireframe: router,
                githubRepoRecommend: AnyUseCase(GithubRepoRecommendInteractor()),
                githubRepoSearch: AnyUseCase(interactor)
            )
        )
        presenter.viewDidLoad()
    }

    func testPresenterInput() {
        // searchを呼び出す前
        XCTContext.runActivity(named: "searchを一度も呼び出していない場合") { _ in
            XCTContext.runActivity(named: "Sectionは固定値を返す") { _ in
                XCTAssertEqual(view.displayGithubRepoData.numberOfSections, 2)
                XCTAssertEqual(view.displayGithubRepoData.title(of: 0), "おすすめ")
                XCTAssertEqual(view.displayGithubRepoData.title(of: 1), "検索結果 0件")
            }

            XCTContext.runActivity(named: "Section: 0は固定値を返す") { _ in
                let section = 0

                XCTContext.runActivity(named: "Section: 0") { _ in
                    let exp = XCTestExpectation()

                    view.recomendedHandler = { data in
                        defer {
                            exp.fulfill()
                        }

                        XCTAssertEqual(data.numberOfItems(in: section), 3)

                        XCTAssertEqual(
                            data.item(with: IndexPath(item: 0, section: section))?.name,
                            "objcio/issue-13-viper"
                        )

                        XCTAssertEqual(
                            data.item(with: IndexPath(item: 1, section: section))?.name,
                            "objcio/issue-13-viper-swift"
                        )
                        XCTAssertEqual(
                            data.item(with: IndexPath(item: 2, section: section))?.name,
                            "pedrohperalta/Articles-iOS-VIPER"
                        )
                    }

                    wait(for: [exp], timeout: 5)
                }

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
                XCTAssertEqual(view.displayGithubRepoData.numberOfItems(in: section), 0)
            }
        }

        XCTContext.runActivity(named: "searchを呼び出した後") { _ in
            interactor.stubData = [
                .init(name: "name0", htmlUrlString: "", description: "", stargazersCount: nil),
                .init(name: "name1", htmlUrlString: "", description: "", stargazersCount: nil)
            ]

            presenter.search("")

            XCTContext.runActivity(named: "Section: 1は用意した値を返しアクセスできる") { _ in
                let section = 1

                let exp = XCTestExpectation()

                view.searchedHandler = { data in
                    defer {
                        exp.fulfill()
                    }

                    XCTContext.runActivity(named: "用意した値を返す") { _ in
                        XCTAssertEqual(data.numberOfSections, 2)
                        XCTAssertEqual(data.numberOfItems(in: section), 2)

                        XCTAssertEqual(data.item(with: IndexPath(item: 0, section: section))?.name, "name0")
                        XCTAssertEqual(data.item(with: IndexPath(item: 1, section: section))?.name, "name1")
                    }

                    XCTContext.runActivity(named: "タップ") { _ in
                        self.presenter.selectItem(with: IndexPath(row: 0, section: section))
                        XCTAssertEqual(self.router.githubRepoEntity?.name, "name0")
                    }
                }

                wait(for: [exp], timeout: 5)
            }
        }
    }
}

extension GithubRepoSearchPresenterTests {
    enum TestDouble {
        class ViewController: UIViewController, GithubRepoSearchView {
            let displayGithubRepoData = DisplayGithubRepoData()
            var recomendedHandler: ((DisplayGithubRepoData) -> ())?
            var searchedHandler: ((DisplayGithubRepoData) -> ())?

            func recommended(_ data: [GithubRepoEntity]) {
                displayGithubRepoData.recommends = data
                recomendedHandler?(displayGithubRepoData)
            }

            func searched(_ data: [GithubRepoEntity]) {
                displayGithubRepoData.searchResultEntities = data
                searchedHandler?(displayGithubRepoData)
            }
        }

        class Router: GithubReposSearchWireframe {
            var searchViewController: UIViewController
            var githubRepoEntity: GithubRepoEntity?
            var error: Error?

            init(searchViewController: UIViewController) {
                self.searchViewController = searchViewController
            }

            func presentDetail(_ githubRepoEntity: GithubRepoEntity) {
                // メソッドが呼び出されたことを検証するためプロパティにセットする
                self.githubRepoEntity = githubRepoEntity
            }

            func presentAlert(_ error: Error) {
                // ここでErrorのテストやるべきか考え中...
            }
        }

        class Interactor: UseCase {
            // テスト用入力としてセットし出力するスタブ
            var stubData: [GithubRepoEntity]?

            func execute(_ parameters: String, completion: ((Result<[GithubRepoEntity], Error>) -> ())?) {
                completion?(.success(self.stubData!))
            }

            func cancel() {}
        }
    }
}
