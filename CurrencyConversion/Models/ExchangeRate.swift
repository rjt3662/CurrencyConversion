//
//  ExchangeRate.swift
//  CurrencyConversion
//
//  Created by Rajat Mishra on 04/12/20.
//

import Foundation

struct ExchangeRate: Codable {
    
    let code: String
    let rate: Double
    
    static func getCurrencies(from dictionary: StringDouble) -> [ExchangeRate] {
        return dictionary.map({ ExchangeRate(code: $0.key.replacingOccurrences(of: "USD", with: ""), rate: $0.value) })
    }
}
