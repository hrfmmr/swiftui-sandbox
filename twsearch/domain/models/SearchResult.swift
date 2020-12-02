//
//  SearchResult.swift
//  twsearch
//
//  Created by hrfm mr on 2020/12/02.
//

import Foundation

public typealias SearchNextParams = [String: String]

public struct SearchResult {
    public let statuses: [Status]
    public let nextParams: SearchNextParams?
}
