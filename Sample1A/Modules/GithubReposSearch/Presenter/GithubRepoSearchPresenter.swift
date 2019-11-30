//
//  GithubReposSearchPresenter.swift
//  Sample1A
//
//  Created by Yoshinori Imajo on 2019/11/04.
//  Copyright © 2019 Yoshinori Imajo. All rights reserved.
//

import Foundation

protocol GithubRepoSearchPresentation: AnyObject {
    func viewDidLoad()
    func search(_ word: String)
    func selectItem(with indexPath: IndexPath)
}

protocol GithubRepoSearchView: AnyObject {
    func recommended(_ data: [GithubRepoEntity])
    func searched(_ data: [GithubRepoEntity])
}

class GithubRepoSearchPresenter {
    struct Dependency {
        let wireframe: GithubReposSearchWireframe
        let githubRepoRecommend: AnyUseCase<Void, [GithubRepoEntity]>
        let githubRepoSearch: AnyUseCase<String, [GithubRepoEntity]>
    }

    private let dependency: Dependency
    weak var view: GithubRepoSearchView?

    private var recommends: [GithubRepoEntity] {
        didSet {
            DispatchQueue.main.async {
                self.view?.recommended(self.recommends)
            }
        }
    }

    private var searchResultEntities: [GithubRepoEntity] = [] {
        didSet {
            DispatchQueue.main.async {
                self.view?.searched(self.searchResultEntities)
            }
        }
    }

    init(view: GithubRepoSearchView?, dependency: Dependency) {
        self.view = view
        self.dependency = dependency
        self.recommends = []
    }
}

extension GithubRepoSearchPresenter: GithubRepoSearchPresentation {
    func viewDidLoad() {
        dependency.githubRepoRecommend.execute(()) { [weak self] result in
            self?.recommends = try! result.get()
        }
    }

    func search(_ word: String) {
        dependency.githubRepoSearch.cancel()
        dependency.githubRepoSearch.execute(word) { [weak self] result in
            guard let self = self else { return }

            DispatchQueue.main.async {
                switch result {
                case .success(let items):
                    self.searchResultEntities = items
                case .failure(let error):
                    if (error as NSError).code != NSURLErrorCancelled {
                        self.dependency.wireframe.presentAlert(error)
                    }
                }
            }
        }
    }

    // MARK: - wireframe

    func selectItem(with indexPath: IndexPath) {
        switch DisplayGithubRepoData.Section(rawValue: indexPath.section)! {
        case .recommend:
            guard (0 ..< recommends.count).contains(indexPath.row) else { return }

            let entity = recommends[indexPath.row]
            dependency.wireframe.presentDetail(entity)
        case .search:
            guard (0 ..< searchResultEntities.count).contains(indexPath.row) else { return }

            let entity = searchResultEntities[indexPath.row]
            dependency.wireframe.presentDetail(entity)
        }
    }
}

// MARK: - 表示用データ

class DisplayGithubRepoData {
    enum Section: Int, CaseIterable {
        case recommend
        case search
    }

    var recommends: [GithubRepoEntity] = []
    var searchResultEntities: [GithubRepoEntity] = []

    var numberOfSections: Int {
        Section.allCases.count
    }

    func title(of section: Int) -> String {
        switch Section(rawValue: section)! {
        case .recommend:
            return "おすすめ"
        case .search:
            return "検索結果 \(searchResultEntities.count)件"
        }
    }

    func numberOfItems(in section: Int) -> Int {
        switch Section(rawValue: section)! {
        case .recommend:
            return recommends.count
        case .search:
            return searchResultEntities.count
        }
    }

    func item(with indexPath: IndexPath) -> GithubRepoEntity? {
        switch Section(rawValue: indexPath.section)! {
        case .recommend:
            guard (0 ..< recommends.count).contains(indexPath.row) else {
                return nil
            }

            return recommends[indexPath.row]
        case .search:
            guard (0 ..< searchResultEntities.count).contains(indexPath.row) else {
                return nil
            }

            return searchResultEntities[indexPath.row]
        }
    }
}
