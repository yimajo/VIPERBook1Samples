//
//  GithubAPIError.swift
//  Sample1A
//
//  Created by Yoshinori Imajo on 2019/12/25.
//  Copyright © 2019 Yoshinori Imajo. All rights reserved.
//

import Foundation

enum GithubAPIError: Error, LocalizedError {
    case lateLimit

    var errorDescription: String? {
        switch self {
        case .lateLimit:
            return "API rate limit exceeded."
        }
    }
}
