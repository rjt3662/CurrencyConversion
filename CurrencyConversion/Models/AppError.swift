//
//  AppError.swift
//  CurrencyConversion
//
//  Created by Rajat Mishra on 03/12/20.
//

import Foundation

struct AppError: Error {
    
    let success : Bool?
    let message : String?
    let error: APIError?
    var underlyingError: Error?
    
}

struct APIError: Codable, Error {
    let code: Int
    let type: String
    let info: String
    
    init(code: Int, type: String, info: String) {
        self.code = code
        self.type = type
        self.info = info
    }
}
