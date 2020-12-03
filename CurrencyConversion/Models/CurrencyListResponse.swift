//
//  CurrencyListResponse.swift
//  CurrencyConversion
//
//  Created by Rajat Mishra on 03/12/20.
//

import Foundation

struct CurrencyListResponse : Codable {
    let success : Bool?
    let terms : String?
    let privacy : String?
    let currencies : [Currency]?
    let error: APIError?

    enum CodingKeys: String, CodingKey {

        case success = "success"
        case terms = "terms"
        case privacy = "privacy"
        case currencies = "currencies"
        case error = "error"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        success = try values.decodeIfPresent(Bool.self, forKey: .success)
        terms = try values.decodeIfPresent(String.self, forKey: .terms)
        privacy = try values.decodeIfPresent(String.self, forKey: .privacy)
        if let currencyDict = try values.decodeIfPresent([String: String].self, forKey: .currencies) {
            currencies = Currency.getCurrencies(from: currencyDict)
        } else {
            currencies = nil
        }
        error = try values.decodeIfPresent(APIError.self, forKey: .error)
    }

}
