//
//  GitHubReposSearchViewController.swift
//  Sample1A
//
//  Created by Yoshinori Imajo on 2019/11/04.
//  Copyright © 2019 Yoshinori Imajo. All rights reserved.
//

import UIKit

class GithubRepoSearchViewController: UIViewController {
    struct Dependency {
        let presenter: GithubRepoSearchPresentation
    }

    private var dependency: Dependency!

    @IBOutlet private var tableView: UITableView!

    private let displayData = DisplayGithubRepoData()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        dependency.presenter.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let indexPathForSelectedRow = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPathForSelectedRow, animated: true)
        }
    }
}

extension GithubRepoSearchViewController: GithubRepoSearchView {
    func recommended(_ data: [GithubRepoEntity]) {
        displayData.recommends = data
        tableView.reloadData()
    }

    func searched(_ data: [GithubRepoEntity]) {
        displayData.searchResultEntities = data
        tableView.reloadData()
    }
}

private extension GithubRepoSearchViewController {
    func setupUI() {
        navigationItem.largeTitleDisplayMode = .never

        navigationItem.hidesSearchBarWhenScrolling = false

        let search = UISearchController(searchResultsController: nil)
        search.searchResultsUpdater = self
        navigationItem.searchController = search
    }
}

extension GithubRepoSearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        // SearchBarに入力したテキストを使って表示データをフィルタリングする。
        let text = searchController.searchBar.text ?? ""

        if !text.isEmpty {
            dependency.presenter.search(text)
        }
    }
}

extension GithubRepoSearchViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        displayData.numberOfSections
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        displayData.title(of: section)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        displayData.numberOfItems(in: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let entity = displayData.item(with: indexPath)!
        cell.textLabel?.text = entity.name
        cell.detailTextLabel?.text = entity.description
        return cell
    }
}

extension GithubRepoSearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let entity = displayData.item(with: indexPath)!
        dependency.presenter.select(entity)
    }
}

extension GithubRepoSearchViewController: DependencyInjectable {
    func inject(_ dependency: Dependency) {
        self.dependency = dependency
    }
}
