//
//  GithubRepoDetailRouter.swift
//  Sample1A
//
//  Created by Yoshinori Imajo on 2019/11/04.
//  Copyright © 2019 Yoshinori Imajo. All rights reserved.
//

import UIKit

protocol GithubRepoDetailWireframe {
    var detailViewController: UIViewController { get }
}

struct GithubRepoDetailRouter: GithubRepoDetailWireframe {
    // このRouterがあるときには確実にVCは存在しているのと循環参照したくないのでunowed
    unowned let detailViewController: UIViewController
}
