//
//  GithubRepoRecomendInteractor.swift
//  Sample1A
//
//  Created by Yoshinori Imajo on 2019/11/24.
//  Copyright © 2019 Yoshinori Imajo. All rights reserved.
//

import Foundation

struct GithubRepoRecommendInteractor: UseCase {
    func execute(
        _ parameters: Void = (),
        completion: ((Result<[GithubRepoEntity], Never>) -> ())?)
    {
        let entities = [
            GithubRepoEntity(
                id: 20638417,
                name: "objcio/issue-13-viper",
                htmlURL: URL(string: "https://github.com/objcio/issue-13-viper")!,
                description: "Mutualmobile社のオリジナルなVIPERサンプル",
                stargazersCount: nil
            ),
            GithubRepoEntity(
                id: 20638435,
                name: "objcio/issue-13-viper-swift",
                htmlURL: URL(string: "https://github.com/objcio/issue-13-viper-swift")!,
                description: "オリジナルなVIPERサンプルをSwiftで書き換えたもの",
                stargazersCount: nil
            ),
            GithubRepoEntity(
                id: 54735381,
                name: "pedrohperalta/Articles-iOS-VIPER",
                htmlURL: URL(string: "https://git.io/JeApc")!,
                description: "PedroさんのVIPER実装",
                stargazersCount: nil
            )
        ]

        completion?(.success(entities))
    }

    func cancel() { }
}
