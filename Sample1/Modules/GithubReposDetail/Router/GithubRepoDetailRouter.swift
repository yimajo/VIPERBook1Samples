//
//  GithubRepoDetailRouter.swift
//  VIPERSample1
//
//  Created by Yoshinori Imajo on 2019/11/04.
//  Copyright © 2019 Yoshinori Imajo. All rights reserved.
//

import UIKit

struct GithubRepoDetailRouter: GithubRepoDetailWireframe {
    // このRouterがあるときには確実にVCは存在しているのと循環参照したくないのでunowed
    unowned let detailViewController: UIViewController
}
