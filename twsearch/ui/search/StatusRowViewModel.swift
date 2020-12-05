//
//  StatusRowViewModel.swift
//  twsearch
//
//  Created by hrfm mr on 2020/12/02.
//

import Foundation

struct StatusRowViewModel: Identifiable {
    var id: Int {
        status.id
    }
    
    var statusText: String {
        status.text
    }
    
    var userName: String {
        status.userName
    }
    
    var userScreenName: String {
        "@\(status.userScreenName)"
    }
    
    var userProfileImageURL: URL? {
        status.userProfileImageURL
    }
    
    private let status: Status
    
    init(status: Status) {
        self.status = status
    }
}

extension StatusRowViewModel: Equatable {
    static func == (lhs: StatusRowViewModel, rhs: StatusRowViewModel) -> Bool {
        lhs.id == rhs.id
    }
}

