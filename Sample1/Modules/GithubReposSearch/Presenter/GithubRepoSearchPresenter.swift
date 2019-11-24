//
//  GithubReposSearchPresenter.swift
//  VIPERSample1
//
//  Created by Yoshinori Imajo on 2019/11/04.
//  Copyright © 2019 Yoshinori Imajo. All rights reserved.
//

import Foundation

protocol GithubRepoSearchPresentation {
    func search(_ word: String, completion: @escaping (Result<(), Error>) -> ())

    var numberOfListSection: Int { get }
    func listDescription(section: Int) -> String
    func numberOfListItems(section: Int) -> Int
    func listItem(with indexPath: IndexPath) -> GithubRepoEntity?
    func selectItem(with indexPath: IndexPath)
}

class GithubRepoSearchPresenter {
    struct Dependency {
        let wireframe: GithubReposSearchWireframe
        let githubRepoSearchUseCase: GithubRepoSearchUseCase
    }

    private let dependency: Dependency

    private enum Section: Int, CaseIterable {
        case recommend
        case search
    }

    private let recommendGitHubRepoEntities: [GithubRepoEntity] = [
        GithubRepoEntity(
            name: "objcio/issue-13-viper",
            htmlUrlString: "https://github.com/objcio/issue-13-viper",
            description: "Mutualmobile社の人がobjc.ioに寄稿したオリジナルなVIPERサンプル",
            stargazersCount: nil
        ),
        GithubRepoEntity(
            name: "objcio/issue-13-viper-swift",
            htmlUrlString: "https://github.com/objcio/issue-13-viper-swift",
            description: "オリジナルなVIPERサンプルをSwiftで書き換えたもの",
            stargazersCount: nil
        ),
        GithubRepoEntity(
            name: "pedrohperalta/Articles-iOS-VIPER",
            htmlUrlString: "https://github.com/pedrohperalta/Articles-iOS-VIPER",
            description: "PedroさんのVIPER実装",
            stargazersCount: nil
        )
    ]

    private var searchResultGithubRepoEntities: [GithubRepoEntity] = []

    init(dependency: Dependency) {
        self.dependency = dependency
    }
}

extension GithubRepoSearchPresenter: GithubRepoSearchPresentation {
    func search(_ word: String, completion: @escaping (Result<(), Error>) -> ()) {
        dependency.githubRepoSearchUseCase.search(from: word) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let items):
                    self?.searchResultGithubRepoEntities = items
                    completion(.success(()))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }

    // MARK: - list

    var numberOfListSection: Int {
        Section.allCases.count
    }

    func listDescription(section: Int) -> String {
        switch Section(rawValue: section)! {
        case .recommend:
            return "おすすめ"
        case .search:
            return "検索結果 \(searchResultGithubRepoEntities.count)件"
        }
    }

    func numberOfListItems(section: Int) -> Int {
        switch Section(rawValue: section)! {
        case .recommend:
            return recommendGitHubRepoEntities.count
        case .search:
            return searchResultGithubRepoEntities.count
        }
    }

    func listItem(with indexPath: IndexPath) -> GithubRepoEntity? {
        switch Section(rawValue: indexPath.section)! {
        case .recommend:
            guard (0 ..< recommendGitHubRepoEntities.count).contains(indexPath.row) else {
                return nil
            }

            return recommendGitHubRepoEntities[indexPath.row]
        case .search:
            guard (0 ..< searchResultGithubRepoEntities.count).contains(indexPath.row) else {
                return nil
            }

            return searchResultGithubRepoEntities[indexPath.row]
        }
    }

    // MARK: - wireframe

    func selectItem(with indexPath: IndexPath) {
        let entity: GithubRepoEntity
        switch Section(rawValue: indexPath.section)! {
        case .recommend:
            guard (0 ..< recommendGitHubRepoEntities.count).contains(indexPath.row) else {
                return
            }

            entity = recommendGitHubRepoEntities[indexPath.row]
        case .search:
            guard (0 ..< searchResultGithubRepoEntities.count).contains(indexPath.row) else {
                return
            }

            entity = searchResultGithubRepoEntities[indexPath.row]
        }

        dependency.wireframe.presentDetail(entity)
    }
}
