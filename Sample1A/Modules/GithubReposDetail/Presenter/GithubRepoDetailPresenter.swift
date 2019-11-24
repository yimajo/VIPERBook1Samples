//
//  GithubRepoDetailPresentor.swift
//  Sample1A
//
//  Created by Yoshinori Imajo on 2019/11/04.
//  Copyright © 2019 Yoshinori Imajo. All rights reserved.
//

import Foundation

class GithubRepoDetailPresenter {
    let wireframe: GithubRepoDetailWireframe
    weak var view: GithubRepoDetailView?

    init(wireframe: GithubRepoDetailWireframe, view: GithubRepoDetailView? = nil) {
        self.wireframe = wireframe
        self.view = view
    }
}

extension GithubRepoDetailPresenter: GithubRepoDetailPresentation {
    func createLoadRequest(with urlString: String) {
        let request = URLRequest(url: URL(string: urlString)!)
        view?.requestCreated(request)
    }
}
