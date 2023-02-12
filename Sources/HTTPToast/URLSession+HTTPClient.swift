//
//  File.swift
//  
//
//  Created by Adrian Bilescu on 12.02.2023.
//

import Foundation

public struct URLSessionHTTPClient: HTTPClient {
    let session: URLSession

    public func request(_ endpoint: String, method: HTTPMethod, headers: [String : String]?, body: Data?, completion: @escaping (Result<HTTPResponse, Error>) -> Void) {
        guard let url = URL(string: endpoint) else {
            completion(.failure(HTTPClientError.invalidURL))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers
        request.httpBody = body

        session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let response = response as? HTTPURLResponse else {
                completion(.failure(HTTPClientError.invalidResponse))
                return
            }

            let code = response.statusCode
            let headers: [String: String] = response.allHeaderFields.reduce(into: [:]) { result, header in
                guard let key = header.key as? String, let value = header.value as? String else { return }
                result[key] = value
            }
            completion(.success(HTTPResponse(data: data, headers: headers, statusCode: code)))
        }.resume()    
    }
}

public enum HTTPClientError: Error {
    case invalidURL
    case invalidResponse
}
