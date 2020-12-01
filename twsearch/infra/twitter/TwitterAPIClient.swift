//
//  TwitterAPIClient.swift
//  twsearch
//
//  Created by hrfm mr on 2020/11/29.
//

import Foundation
import Combine

enum TwitterAPIError: Error {
    case network(description: String)
    case statusCode(HTTPURLResponse)
    case parsing(description: String)
}

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
    
    func request<T>(_ apiTarget: T) -> AnyPublisher<T.Response, TwitterAPIError> where T: TwitterAPITargetType {
        TwitterAPIClient.request(apiTarget.makeRequest())
    }
}

private extension TwitterAPIClient {
    static func decode<T>(data: Data) -> AnyPublisher<T, TwitterAPIError> where T: Decodable {
        return Just(data)
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { error -> TwitterAPIError in
                return .parsing(description: error.localizedDescription)
            }
            .eraseToAnyPublisher()
    }
    
    static func request<T>(_ req: URLRequest) -> AnyPublisher<T, TwitterAPIError> where T: Decodable {
        return URLSession.shared.dataTaskPublisher(for: req)
            .mapError { error -> TwitterAPIError in
                return .network(description: error.localizedDescription)
            }
            .flatMap(maxPublishers: .max(1)) { data, response -> AnyPublisher<T, TwitterAPIError> in
                if let response = response as? HTTPURLResponse,
                   !(200..<300).contains(response.statusCode) {
                    return Fail(error: .statusCode(response)).eraseToAnyPublisher()
                }
                return decode(data: data)
            }
            .eraseToAnyPublisher()
    }
}
