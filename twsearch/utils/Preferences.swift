//
//  Preferences.swift
//  twsearch
//
//  Created by hrfm mr on 2020/12/01.
//

import Foundation

public enum Preferences {
    private static var fpath: String {
        Bundle.main.path(forResource: "prefs", ofType: "plist")!
    }
    
    private static var dict: [String: Any] {
        NSDictionary(contentsOfFile: fpath)! as! Dictionary<String, Any>
    }
    
    static var twitterOAuthToken: String {
        dict["twitter_oauth_token"] as! String
    }
}
