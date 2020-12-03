//
//  APIRouter.swift
//  CurrencyConversion
//
//  Created by Rajat Mishra on 03/12/20.
//

import Alamofire
import UIKit

enum APIRouter: URLRequestConvertible {
    
    case currencyList
    
    
    // MARK: - HTTPMethod
    private var method: HTTPMethod {
        switch self {
        case .currencyList:
            return .get
        }
    }
    
    // MARK: - Path
    private var path: String {
        switch self {
        case .currencyList:
            return "list"
        }
    }
    
    // MARK: - Query Params
    private var queryParams: Parameters? {
        switch self {
        default:
            return nil
        }
    }
    
    // MARK: - Parameters
    var parameters: Parameters? {
        switch self {
        case .currencyList:
            return [ParameterKey.access_key: Environment.apiAccessKey]
        }
    }
    
    // MARK: - Headers
    private var headers: HTTPHeaders {
        let defaultHeaders = HTTPHeaders([:])
        switch self {
        default:
            break
        }
        return defaultHeaders
    }
    
    // MARK: - URLRequestConvertible
    func asURLRequest() throws -> URLRequest {
        var url = Environment.rootURL.appendingPathComponent(path)
        if let queryParameters = queryParams, var urlComponent = URLComponents(url: url, resolvingAgainstBaseURL: false) {
            let queryItems = queryParameters.map { (key, value) -> URLQueryItem in
                var item = URLQueryItem(name: key, value: nil)
                if let stringVal = value as? String {
                    item.value = stringVal
                } else if let intVal = value as? Int {
                    item.value = "\(intVal)"
                } else if let doubleVal = value as? Double {
                    item.value = "\(doubleVal)"
                }
                return item
            }
            urlComponent.queryItems = queryItems
            do {
                url = try urlComponent.asURL()
            } catch {
                fatalError("Error creating url")
            }
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        urlRequest.headers = headers
        
        do {
            if method == .get {
                urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
            } else {
                urlRequest = try JSONEncoding.default.encode(urlRequest, with: parameters)
            }
            
        } catch {
            throw AFError.parameterEncodingFailed(reason: .jsonEncodingFailed(error: error))
        }
        return urlRequest
    }
}
