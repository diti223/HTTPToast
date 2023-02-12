//
//  DummyHTTPClient.swift
//  HTTPToastDemo
//
//  Created by Adrian Bilescu on 11.02.2023.
//

import Foundation
import HTTPToast

struct DummyHTTPClient: HTTPClient {
    func request(
        _ endpoint: String,
        method: HTTPMethod,
        headers: [String: String]?,
        body: Data?,
        completion: @escaping (Result<HTTPResponse, Error>) -> Void
    ) {
        let delay = Double.random(in: 0.5...2)
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            
            let showErrorResponse = Bool.random()
            
            if showErrorResponse {
                let showCustomError = Bool.random()
                if showCustomError {
                    let dummyError = [
                        HTTPClientError.invalidURL,
                        HTTPClientError.invalidURL,
                        HTTPClientError.noData,
                        HTTPClientError.networkError("Network error"),
                        HTTPClientError.invalidURL,
                        HTTPClientError.serverError("Server error"),
                        HTTPClientError.noData,
                    ].randomElement()!
                    completion(.failure(dummyError))
                    return
                }
                
                let statusCode = Int.random(in: 400...599)
                let error = HTTPClientError.statusCode(statusCode)
                completion(.failure(error))
                return
            }
            
            let statusCode = Int.random(in: 200...299)
            let data = "Dummy response".data(using: .utf8)
            let headers = ["Content-Type": "text/plain"]
            let response = HTTPResponse(data: data!, headers: headers, statusCode: statusCode)
            completion(.success(response))
        }
    }
}


extension HTTPResponse: CustomStringConvertible {
    public var description: String {
        
        // if json
        if let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: Any] {
            return "\(statusCode) - \(json)"
        }
        
        //else
        if let data = data, let string = String(data: data, encoding: .utf8) {
            return "\(statusCode) - \(string)"
        }
        
        return "\(statusCode)"
        
    }
}

struct SomeError: Error, CustomStringConvertible {
    var description: String {
        return "Some error"
    }
}

enum HTTPClientError: Error, CustomStringConvertible {
    case statusCode(Int)
    case invalidURL
    case noData
    case serverError(String)
    case networkError(String)
    case unknownError(String)
    
    var description: String {
        switch self {
            case .statusCode(let statusCode):
                return "Status code: \(statusCode)"
            case .invalidURL:
                return "Invalid URL"
            case .noData:
                return "No data"
            case .serverError(let message):
                return "Server error: \(message)"
            case .networkError(let message):
                return "Network error: \(message)"
            case .unknownError(let message):
                return "Unknown error: \(message)"
        }
    }
    
}

