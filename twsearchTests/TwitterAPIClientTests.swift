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
        exp.expectedFulfillmentCount = 2
        api.search(withQuery: "github")
            .print()
            .sink { completion in
                switch completion {
                case .finished:
                    exp.fulfill()
                case let .failure(error):
                    fatalError(error.localizedDescription)
                }
            } receiveValue: { searchResult in
                print("=============================================================")
                print("first search result")
                print("=============================================================")
                print(searchResult)
                if let nextParams = searchResult.nextParams {
                    self.api.fetchNext(withParams: nextParams)
                        .sink {  completion in
                            switch completion {
                            case .finished:
                                exp.fulfill()
                            case let .failure(error):
                                fatalError(error.localizedDescription)
                            }
                        } receiveValue: { searchResult in
                            print("=============================================================")
                            print("next page's search result")
                            print("=============================================================")
                            print(searchResult)
                        }
                        .store(in: &self.disposables)
                } else {
                    exp.fulfill()
                }
            }
            .store(in: &disposables)

        wait(for: [exp], timeout: 5.0)
    }
}
