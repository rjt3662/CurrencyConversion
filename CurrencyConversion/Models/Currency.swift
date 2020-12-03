//
//  Currency.swift
//  CurrencyConversion
//
//  Created by Rajat Mishra on 03/12/20.
//

import Foundation

struct Currency: Codable {
    
    let name: String
    let code: String
    
    static func getCurrencies(from dictionary: StringString) -> [Currency] {
        return dictionary.map({ Currency(name: $0.value, code: $0.key) })
    }
}
