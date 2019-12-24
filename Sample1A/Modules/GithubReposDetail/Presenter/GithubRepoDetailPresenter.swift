//
//  GithubRepoDetailPresentor.swift
//  Sample1A
//
//  Created by Yoshinori Imajo on 2019/11/04.
//  Copyright © 2019 Yoshinori Imajo. All rights reserved.
//

import Foundation

// MARK: - Contract

protocol GithubRepoDetailPresentation {
    func createLoadRequest(with url: URL)
}

protocol GithubRepoDetailView: class {
    func requestCreated(_ request: URLRequest)
}

// MARK: - Presenter

class GithubRepoDetailPresenter {
    let wireframe: GithubRepoDetailWireframe
    weak var view: GithubRepoDetailView?

    init(wireframe: GithubRepoDetailWireframe, view: GithubRepoDetailView? = nil) {
        self.wireframe = wireframe
        self.view = view
    }
}

extension GithubRepoDetailPresenter: GithubRepoDetailPresentation {
    func createLoadRequest(with url: URL) {
        let request = URLRequest(url: url)
        view?.requestCreated(request)
    }
}
