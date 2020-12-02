//
//  Errors.swift
//  twsearch
//
//  Created by hrfm mr on 2020/12/02.
//

import Foundation

enum CommonNetworkRequestError: Error {
    case network(description: String)
    case statusCode(HTTPURLResponse)
    case parsing(description: String)
}
