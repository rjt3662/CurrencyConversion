//
//  ConversionResponse.swift
//  CurrencyConversion
//
//  Created by Rajat Mishra on 04/12/20.
//

import Foundation

struct ConversionResponse : Codable {
    let success : Bool?
    let terms : String?
    let privacy : String?
    let timestamp : Int?
    let source : String?
    let exchangeRates : [ExchangeRate]?
    let error: APIError?
    
    enum CodingKeys: String, CodingKey {

        case success = "success"
        case terms = "terms"
        case privacy = "privacy"
        case timestamp = "timestamp"
        case source = "source"
        case exchangeRates = "quotes"
        case error = "error"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        success = try values.decodeIfPresent(Bool.self, forKey: .success)
        terms = try values.decodeIfPresent(String.self, forKey: .terms)
        privacy = try values.decodeIfPresent(String.self, forKey: .privacy)
        timestamp = try values.decodeIfPresent(Int.self, forKey: .timestamp)
        source = try values.decodeIfPresent(String.self, forKey: .source)
        if let quoteDict = try values.decodeIfPresent(StringDouble.self, forKey: .exchangeRates) {
            exchangeRates = ExchangeRate.getCurrencies(from: quoteDict)
        } else {
            exchangeRates = nil
        }
        error = try values.decodeIfPresent(APIError.self, forKey: .error)
    }

}
