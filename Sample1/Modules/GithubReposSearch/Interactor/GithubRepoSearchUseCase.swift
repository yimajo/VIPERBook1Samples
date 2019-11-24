//
//  GithubRepoSearchUseCase.swift
//  VIPERSample1
//
//  Created by Yoshinori Imajo on 2019/11/16.
//  Copyright © 2019 Yoshinori Imajo. All rights reserved.
//

import Foundation

protocol GithubRepoSearchUseCase {
    func search(
        from word: String,
        completion: @escaping (Result<[GithubRepoEntity], Error>) -> ()
    )
}

struct GithubRepoSearchInteractor: GithubRepoSearchUseCase {
    func search(
        from word: String,
        completion: @escaping (Result<[GithubRepoEntity], Error>) -> ())
    {
        let request = GithubRepoSearchAPIRequest(word: word)
        request.perform { result in
            switch result {
            case .success(let response):
                completion(.success(response.items))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

struct GithubRepoSearchAPIRequest {
    private let host = URL(string: "https://api.github.com")!
    private let path = "/search/repositories"
    private let urlSession: Foundation.URLSession
    private var params: [String: String] { ["q": word] }

    private let word: String

    init(urlSession: Foundation.URLSession = URLSession.shared, word: String) {
        self.urlSession = urlSession
        self.word = word
    }

    func perform(completion: @escaping (Result<GithubRepoSearchResponse, Error>) -> ()) {
        var components = URLComponents(url: host, resolvingAgainstBaseURL: false)!
        components.path = path
        components.queryItems = params.map { URLQueryItem(name: $0.key, value: $0.value) }

        let request = URLRequest(url: components.url!)
        let task = urlSession.dataTask(with: request) { data, response, error in
            guard error == nil else {
                completion(.failure(error!))
                return
            }

            do {
                let response = try JSONDecoder().decode(GithubRepoSearchResponse.self,
                                                        from: data!)
                completion(.success(response))
            } catch {
                completion(.failure(error))
            }
        }

        task.resume()
    }
}

struct GithubRepoSearchResponse: Decodable {
    let items: [GithubRepoEntity]
}

