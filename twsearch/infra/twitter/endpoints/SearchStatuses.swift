//
//  SearchStatuses.swift
//  twsearch
//
//  Created by hrfm mr on 2020/12/01.
//

import Foundation

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
