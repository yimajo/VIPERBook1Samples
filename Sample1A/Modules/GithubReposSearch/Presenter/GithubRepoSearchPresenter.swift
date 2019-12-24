//
//  GithubReposSearchPresenter.swift
//  Sample1A
//
//  Created by Yoshinori Imajo on 2019/11/04.
//  Copyright © 2019 Yoshinori Imajo. All rights reserved.
//

import Foundation

// MARK: - Contract

protocol GithubRepoSearchPresentation: AnyObject {
    func viewDidLoad()
    func search(_ word: String)
    func select(_ entity: GithubRepoEntity)
}

protocol GithubRepoSearchView: AnyObject {
    func recommended(_ data: [GithubRepoEntity])
    func searched(_ data: [GithubRepoEntity])
}

// MARK: - Presenter

class GithubRepoSearchPresenter {
    struct Dependency {
        let wireframe: GithubReposSearchWireframe
        let githubRepoRecommend: AnyUseCase<Void, [GithubRepoEntity]>
        let githubRepoSearch: AnyUseCase<String, [GithubRepoEntity]>
        let githubRepoSort: AnyUseCase<[GithubRepoEntity], [GithubRepoEntity]>
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
            dependency.githubRepoSort.execute(searchResultEntities) { [weak self] result in
                guard let entities = try? result.get() else {
                    return
                }

                DispatchQueue.main.async {
                    self?.view?.searched(entities)
                }
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

    func select(_ entity: GithubRepoEntity) {
        dependency.wireframe.presentDetail(entity)
    }
}
