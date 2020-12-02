//
//  TwitterAPIClient.swift
//  twsearch
//
//  Created by hrfm mr on 2020/11/29.
//

import Foundation
import Combine

protocol TwitterAPITargetType {
    associatedtype Response: Decodable
    func makeRequest() -> URLRequest
}

enum TwitterAPI {
    static let baseURL = "https://api.twitter.com/1.1"
    static let defaultHeaders = [
        "Authorization": "Bearer \(Preferences.twitterOAuthToken)"
    ]
    static func makeRequest(for url: URL) -> URLRequest {
        var req = URLRequest(url: url)
        for (k, v) in defaultHeaders {
            req.setValue(v, forHTTPHeaderField: k)
        }
        return req
    }
}

final class TwitterAPIClient {
    static let shared = TwitterAPIClient()
    
    func request<T>(_ apiTarget: T) -> AnyPublisher<T.Response, CommonNetworkRequestError> where T: TwitterAPITargetType {
        TwitterAPIClient.request(apiTarget.makeRequest())
    }
}

private extension TwitterAPIClient {
    static func decode<T>(data: Data) -> AnyPublisher<T, CommonNetworkRequestError> where T: Decodable {
        return Just(data)
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { error -> CommonNetworkRequestError in
                return .parsing(description: error.localizedDescription)
            }
            .eraseToAnyPublisher()
    }
    
    static func request<T>(_ req: URLRequest) -> AnyPublisher<T, CommonNetworkRequestError> where T: Decodable {
        return URLSession.shared.dataTaskPublisher(for: req)
            .mapError { error -> CommonNetworkRequestError in
                return .network(description: error.localizedDescription)
            }
            .flatMap(maxPublishers: .max(1)) { data, response -> AnyPublisher<T, CommonNetworkRequestError> in
                if let response = response as? HTTPURLResponse,
                   !(200..<300).contains(response.statusCode) {
                    return Fail(error: .statusCode(response)).eraseToAnyPublisher()
                }
                return decode(data: data)
            }
            .eraseToAnyPublisher()
    }
}
