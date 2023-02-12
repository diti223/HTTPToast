//
//  File.swift
//  
//
//  Created by Adrian Bilescu on 12.02.2023.
//

import Foundation

extension HTTPClient {
    func data(_ endpoint: String, method: HTTPMethod, headers: [String: String]?, body: Data?) async throws -> Result<Data, Error> {
        return try await withCheckedThrowingContinuation { continuation in
            request(endpoint, method: method, headers: headers, body: body) { result in
                switch result {
                    case .success(let response):
                        continuation.resume(returning: .success(response.data ?? Data()))
                    case .failure(let error):
                        continuation.resume(returning: .failure(error))
                }
            }
        }
    }
}
