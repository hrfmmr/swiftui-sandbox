//
//  StatusRepository.swift
//  twsearch
//
//  Created by hrfm mr on 2020/12/02.
//

import Foundation
import Combine

enum StatusRepositoryError: Error {
    case networkRequest(CommonNetworkRequestError)
    
    static func fromCommonNetworkRequestError(error: CommonNetworkRequestError) -> StatusRepositoryError {
        .networkRequest(error)
    }
}

protocol StatusRepository {
    func search(withQuery q: String) -> AnyPublisher<SearchResult, StatusRepositoryError>
    func fetchNext(withParams params: [String: String]) -> AnyPublisher<SearchResult, StatusRepositoryError>
}
