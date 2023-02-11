//
//  File.swift
//  
//
//  Created by Adrian Bilescu on 11.02.2023.
//

import Foundation

public protocol HTTPClient {
    func request(
        _ endpoint: String,
        method: HTTPMethod,
        headers: [String: String]?,
        body: Data?,
        completion: @escaping (Result<HTTPResponse, Error>) -> Void
    )
}

public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

public struct HTTPResponse {
    public let data: Data
    public let headers: [String: String]
    public let statusCode: Int
    
    public init(data: Data, headers: [String : String], statusCode: Int) {
        self.data = data
        self.headers = headers
        self.statusCode = statusCode
    }
}

