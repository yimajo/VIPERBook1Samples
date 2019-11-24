//
//  MainViewController.swift
//  VIPERBook1Sample
//
//  Created by Yoshinori Imajo on 2019/11/18.
//  Copyright © 2019 Yoshinori Imajo. All rights reserved.
//

import UIKit
import Sample1
import Sample1A

class MainViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let viewController = Sample1.AppDefaultDependencies().rootViewController()
            navigationController?.pushViewController(viewController, animated: true)
        case 1:
            let viewController = Sample1A.AppDefaultDependencies().rootViewController()
            navigationController?.pushViewController(viewController, animated: true)
        default:
            break
        }
    }
}
