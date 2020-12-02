//
//  utils.swift
//  twsearch
//
//  Created by hrfm mr on 2020/12/02.
//

import Foundation

func queryStringToDict(_ qs: String) -> [String: String]? {
    guard let components = URLComponents(string: "http://examples.com/foo\(qs)") else {
        return nil
    }
    guard let queryItems = components.queryItems else {
        return nil
    }
    var d = [String: String]()
    for item in queryItems {
        d[item.name] = item.value
    }
    return d
}
