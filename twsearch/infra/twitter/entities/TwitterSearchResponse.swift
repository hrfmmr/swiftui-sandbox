//
//  TwitterSearchResponse.swift
//  twsearch
//
//  Created by hrfm mr on 2020/11/29.
//

import Foundation

public struct TwitterSearchResponse {
    public let statuses: [TwitterStatus]
    public let metadata: TwitterSearchMetaData
    
    private enum CodingKeys: String, CodingKey {
        case statuses = "statuses"
        case metadata = "search_metadata"
    }
}

extension TwitterSearchResponse: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.statuses = try container.decode([TwitterStatus].self, forKey: .statuses)
        self.metadata = try container.decode(TwitterSearchMetaData.self, forKey: .metadata)
    }
}

extension TwitterSearchResponse {
    func toSearchResult() -> SearchResult {
        var nextParams: SearchNextParams?
        if let nextResults = self.metadata.nextResults {
            nextParams = queryStringToDict(nextResults)
        }
        return SearchResult(
            statuses: self.statuses.map({ s -> Status in
                Status(
                    id: s.id,
                    text: s.text,
                    userID: s.user.id,
                    userName: s.user.name,
                    userScreenName: s.user.screenName,
                    userProfileImageURL: URL(string: s.user.profileImageURL)
                )
            }),
            nextParams: nextParams
        )
    }
}

public struct TwitterStatus {
    public let id: Int
    public let text: String
    public let user: TwitterUser
    
    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case text = "text"
        case user = "user"
    }
}

extension TwitterStatus: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.text = try container.decode(String.self, forKey: .text)
        self.user = try container.decode(TwitterUser.self, forKey: .user)
    }
}

public struct TwitterUser {
    public let id: Int
    public let name: String
    public let screenName: String
    public let profileImageURL: String
    
    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case screenName = "screen_name"
        case profileImageURL = "profile_image_url_https"
    }
}

extension TwitterUser: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.screenName = try container.decode(String.self, forKey: .screenName)
        self.profileImageURL = try container.decode(String.self, forKey: .profileImageURL)
    }
}

public struct TwitterSearchMetaData {
    public let nextResults: String?
    
    private enum CodingKeys: String, CodingKey {
        case nextResults = "next_results"
    }
}

extension TwitterSearchMetaData: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.nextResults = try? container.decode(String.self, forKey: .nextResults)
    }
}
