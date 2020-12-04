//
//  ExchangeRate.swift
//  CurrencyConversion
//
//  Created by Rajat Mishra on 04/12/20.
//

import Foundation

struct ExchangeRate: Codable {
    
    var code: String
    var rate: Double
    
    static func getCurrencies(from dictionary: StringDouble) -> [ExchangeRate] {
        let dollar = CurrencyCode.dollar.rawValue
        return dictionary.map({ ExchangeRate(code: $0.key == "USDUSD" ? dollar : $0.key.replacingOccurrences(of: dollar, with: ""), rate: $0.value) })
    }
}
