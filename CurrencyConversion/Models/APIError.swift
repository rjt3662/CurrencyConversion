//
//  APIError.swift
//  CurrencyConversion
//
//  Created by Rajat Mishra on 03/12/20.
//

import Foundation
import Alamofire

struct APIError: Codable, Error {
    let code: Int
    let type: String
    let info: String
    
    init(code: Int, type: String, info: String) {
        self.code = code
        self.type = type
        self.info = info
    }
    
    init(from error: AFError) {
        if let nsError = error.underlyingError as NSError? {
            code = nsError.code
            type = nsError.domain
            info = nsError.localizedDescription
        } else {
            code = error.responseCode ?? 0
            type = error.responseContentType ?? ""
            info = error.errorDescription ?? ""
        }
    }
}
