//
//  NetworkingSetup.swift
//  CurrencyConversion
//
//  Created by Rajat Mishra on 03/12/20.
//

import Foundation

typealias ParameterKey = NetworkingSetup.APIParameterKey
typealias HTTPHeaderField = NetworkingSetup.HTTPHeaderField
typealias ContentType = NetworkingSetup.ContentType

struct NetworkingSetup {
    
    struct APIParameterKey {
    }
    
    struct HTTPHeaderField {
    }
    
    struct ContentType {
        static let json = "application/json"
    }
    
}
