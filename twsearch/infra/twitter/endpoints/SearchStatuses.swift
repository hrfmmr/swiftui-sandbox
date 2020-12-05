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
        let query: String?
        let params: [String: String]?
        
        init(
            withQuery q: String?,
            otherParams: [String: String]? = nil
        ) {
            self.query = q
            self.params = otherParams
        }
        
        func makeRequest() -> URLRequest {
            var urlcomponents = URLComponents(string: "\(baseURL)\(SearchStatuses.path)")!
            urlcomponents.queryItems = []
            if let q = query {
                urlcomponents.queryItems?.append(URLQueryItem(name: "q", value: q))
            }
            if let params = params {
                for (k, v) in params {
                    urlcomponents.queryItems?.append(URLQueryItem(name: k, value: v))
                }
            }
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
    
    func fetchNext(withParams params: [String: String]) -> AnyPublisher<SearchResult, StatusRepositoryError> {
        self.request(TwitterAPI.SearchStatuses(withQuery: nil, otherParams: params))
            .mapError(StatusRepositoryError.fromCommonNetworkRequestError(error:))
            .map { $0.toSearchResult() }
            .eraseToAnyPublisher()
    }
}
