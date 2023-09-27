//
//  NetworkClient.swift
//  ForeFlight-Exercise
//
//  Created by Michael Mendoza on 9/20/23.
//

import Foundation

enum APIError: Error, LocalizedError {
    case invalidURL
    case requestFailed(reason: String)
    case response(statusCode: Int)
    case decodingFailed
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The URL request contains an invalid URL."
        case .requestFailed(let reason):
            return "The URL request failed due to the following reason: \(reason)"
        case .response(let statusCode):
            return "The URL request received a response with the following status code: \(statusCode)."
        case .decodingFailed:
            return "The URL request received a response but we could not decode the response properly."
        }
    }
}

struct NetworkClient {
    // MARK: - Properties
    private let urlSession = URLSession.shared
    private var jsonDecoder: JSONDecoder
    
    public init() {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        self.jsonDecoder = decoder
    }
    
    // MARK: - Public Methods
    func requestData<Response: Codable>(from urlRequest: URLRequest) async throws -> Response {
        let (data, response) = try await urlSession.data(for: urlRequest)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.requestFailed(reason: "Invalid response.")
        }
        
        guard httpResponse.statusCode == 200 else {
            throw APIError.response(statusCode: httpResponse.statusCode)
        }
        
        do {
            return try jsonDecoder.decode(Response.self, from: data)
        } catch {
            throw APIError.decodingFailed
        }
    }
}
