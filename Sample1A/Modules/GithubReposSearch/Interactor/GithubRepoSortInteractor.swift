//
//  GithubRepoSortInteractor.swift
//  Sample1A
//
//  Created by Yoshinori Imajo on 2019/12/18.
//  Copyright © 2019 Yoshinori Imajo. All rights reserved.
//

import Foundation

struct GithubRepoSortInteractor: UseCase {

    func execute(
        _ parameters: [GithubRepoEntity],
        completion: ((Result<[GithubRepoEntity], Never>) -> ())?)
    {
        let sorted = parameters.sorted {
            $0.stargazersCount ?? 0 > $1.stargazersCount ?? 0
        }
        completion?(.success(sorted))
    }

    func cancel() { }
}
