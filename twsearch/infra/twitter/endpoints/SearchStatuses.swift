//
//  SearchStatuses.swift
//  twsearch
//
//  Created by hrfm mr on 2020/12/01.
//

import Foundation
import Combine

extension TwitterAPI {
    struct SearchStatuses: TwitterAPITargetType {
        typealias Response = TwitterSearchResponse
        static let path = "/search/tweets.json"
        let query: String
        
        init(withQuery q: String) {
            self.query = q
        }
        
        func makeRequest() -> URLRequest {
            var urlcomponents = URLComponents(string: "\(baseURL)\(SearchStatuses.path)")!
            urlcomponents.queryItems = [
                URLQueryItem(name: "q", value: query)
            ]
            return TwitterAPI.makeRequest(for: urlcomponents.url!)
        }
    }
}

extension TwitterAPIClient: StatusRepository {
    func search(withQuery q: String) -> AnyPublisher<SearchResult, StatusRepositoryError> {
        self.request(TwitterAPI.SearchStatuses(withQuery: q))
            .mapError(StatusRepositoryError.fromCommonNetworkRequestError(error:))
            .map { $0.toSearchResult() }
            .eraseToAnyPublisher()
    }
}
