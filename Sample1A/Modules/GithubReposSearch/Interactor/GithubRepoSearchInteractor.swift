//
//  GithubRepoSearchInteractor.swift
//  Sample1A
//
//  Created by Yoshinori Imajo on 2019/11/16.
//  Copyright © 2019 Yoshinori Imajo. All rights reserved.
//

import Foundation

class GithubRepoSearchInteractor: UseCase {

    var request: GithubRepoSearchAPIRequest?

    func execute(_ parameters: String,
                 completion: ((Result<[GithubRepoEntity], Error>) -> ())?) {
        let request = GithubRepoSearchAPIRequest(word: parameters)
        request.perform { result in
            switch result {
            case .success(let response):
                completion?(.success(response.items))
            case .failure(let error):
                completion?(.failure(error))
            }
        }

        self.request = request
    }

    func cancel() {
        request?.cancel()
    }
}
