//
//  TwitterAPIClientTests.swift
//  twsearchTests
//
//  Created by hrfm mr on 2020/12/01.
//

import XCTest
import Combine

@testable import twsearch

class TwitterAPIClientIntegrationTests: XCTestCase {
    private var disposables = Set<AnyCancellable>()
    private let api = TwitterAPIClient.shared
    
    func testSearchStatuses() {
        let exp = expectation(description: "search_statuses")
        api.request(TwitterAPI.SearchStatuses(withQuery: "github"))
            .sink { completion in
                switch completion {
                case .finished:
                    exp.fulfill()
                case let .failure(error):
                    fatalError(error.localizedDescription)
                }
            } receiveValue: { response in
                print("============= search result =================")
                print(response)
            }
            .store(in: &disposables)
        wait(for: [exp], timeout: 5.0)
    }
}
