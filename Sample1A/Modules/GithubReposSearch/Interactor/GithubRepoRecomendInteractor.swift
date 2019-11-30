//
//  GithubRepoRecomendInteractor.swift
//  Sample1A
//
//  Created by Yoshinori Imajo on 2019/11/24.
//  Copyright © 2019 Yoshinori Imajo. All rights reserved.
//

import Foundation

struct GithubRepoRecommendInteractor: UseCase {
    func execute(_ parameters: Void = (), completion: ((Result<[GithubRepoEntity], Error>) -> ())?) {
        let entities = [
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

        completion?(.success(entities))
    }

    func cancel() { }
}
