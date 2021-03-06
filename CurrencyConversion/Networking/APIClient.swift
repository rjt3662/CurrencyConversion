//
//  APIClient.swift
//  CurrencyConversion
//
//  Created by Rajat Mishra on 03/12/20.
//

import Foundation
import Alamofire

struct APIClient {
    
    static func performRequest<T: Decodable>(route: APIRouter, decoder: JSONDecoder = JSONDecoder(), completion: @escaping (Result<T, APIError>) -> Void) {
        print("Request: ")
        debugPrint(route.urlRequest!)
        if let headers = route.urlRequest?.headers {
            print(headers)
        }
        if let body = route.urlRequest?.httpBody {
            print(String(data: body, encoding: .utf8) ?? "")
        }
        
        func handle(response: DataResponse<T, AFError>) {
            switch response.result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(APIError(from: error)))
            }
            if let data = response.data {
                print("Response: ")
                let responseString = String(data: data, encoding: .utf8) ?? ""
                print(responseString)
            }
        }
        
        AF.request(route)
            .responseDecodable (decoder: decoder) { (response: DataResponse<T, AFError>) in
                handle(response: response)
        }
    }
    
    
}
