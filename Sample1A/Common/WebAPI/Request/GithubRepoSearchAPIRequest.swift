//
//  GithubRepoSearchAPIRequest.swift
//  Sample1A
//
//  Created by Yoshinori Imajo on 2019/12/25.
//  Copyright © 2019 Yoshinori Imajo. All rights reserved.
//

import Foundation

class GithubRepoSearchAPIRequest {
    private let host = URL(string: "https://api.github.com")!
    private let path = "/search/repositories"
    private let urlSession: Foundation.URLSession
    private var params: [String: String] { ["q": word] }

    private var task: URLSessionTask?

    private let word: String

    init(urlSession: Foundation.URLSession = URLSession.shared, word: String) {
        self.urlSession = urlSession
        self.word = word
    }

    private func createRequest() -> URLRequest {
        var components = URLComponents(url: host, resolvingAgainstBaseURL: false)!
        components.path = path
        components.queryItems = params.map { URLQueryItem(name: $0.key, value: $0.value) }

        return URLRequest(url: components.url!)
    }

    func perform(completion: @escaping (Result<GithubRepoSearchResponse, Error>) -> ()) {
        task?.cancel()

        let request = createRequest()

        let task = urlSession.dataTask(with: request) { data, response, error in
            guard error == nil else {
                completion(.failure(error!))
                return
            }

            if let httpStatus = response as? HTTPURLResponse,
                httpStatus.statusCode == 403 {
                completion(.failure(GithubAPIError.lateLimit))
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
        self.task = task
    }

    func cancel() {
        task?.cancel()
    }
}

struct GithubRepoSearchResponse: Decodable {
    let items: [GithubRepoEntity]
}
