//
//  Environment.swift
//  CurrencyConversion
//
//  Created by Rajat Mishra on 03/12/20.
//

import Foundation

public enum Environment {
    
    // MARK: - Keys
    enum Keys {
        enum Plist {
            static let rootURL = "ROOT_URL"
            static let apiAccessKey = "API_ACCESS_KEY"
        }
    }
    
    // MARK: - Plist
    private static let infoDictionary: [String: Any] = {
        guard let dict = Bundle.main.infoDictionary else {
            fatalError("Plist file not found")
        }
        return dict
    }()
    
    // MARK: - Plist values
    static let rootURL: URL = {
        guard var rootURLstring = Environment.infoDictionary[Keys.Plist.rootURL] as? String else {
            fatalError("ROOT_URL not set in plist for this environment")
        }
        rootURLstring = rootURLstring.replacingOccurrences(of: "{}", with: "")
        guard let url = URL(string: rootURLstring) else {
            fatalError("ROOT_URL is invalid")
        }
        return url
    }()
    
    static let apiAccessKey: String = {
        guard let apiAccessKeystring = Environment.infoDictionary[Keys.Plist.apiAccessKey] as? String else {
            fatalError("API_ACCESS_KEY not set in plist for this environment")
        }
        return apiAccessKeystring
    }()
    
}
