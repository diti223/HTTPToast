//
//  File.swift
//  
//
//  Created by Adrian Bilescu on 11.02.2023.
//

import Foundation
import Combine

public extension HTTPClient {
    func requestPublisher(endpoint: String, method: HTTPMethod, headers: [String: String]?, body: Data?) -> AnyPublisher<HTTPResponse, Error> {
        Future { promise in
            self.request(endpoint, method: method, headers: headers, body: body) { result in
                switch result {
                    case .success(let response):
                        promise(.success(response))
                    case .failure(let error):
                        promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
