//
//  GithubRepoEntity.swift
//  VIPERSample1
//
//  Created by Yoshinori Imajo on 2019/11/04.
//  Copyright © 2019 Yoshinori Imajo. All rights reserved.
//

import Foundation

struct GithubRepoEntity: Decodable, Equatable {
    let name: String
    let htmlURL: URL
    let description: String?
    let stargazersCount: Int?

    enum CodingKeys: String, CodingKey {
        case name
        case htmlURL = "html_url"
        case description
        case stargazersCount = "stargazers_count"
    }

    // 同じものかどうかを比較できるようにしておきます。
    // 主にテストコードで利用します。
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.htmlURL == rhs.htmlURL
    }
}
