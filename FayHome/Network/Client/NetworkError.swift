//
//  NetworkError.swift
//  FayHome
//
//  Created by Momo Khan on 6/30/25.
//

import Foundation

enum NetworkError: Error {
    case badURL
    case decoding(String)
    case unknown(String)
    case badRequest
    case forbidden
    case notFound
    case serverError
    case unknownStatus(Int)
    case invalidResponse
}

extension NetworkError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .badURL: return "Bad URL"
        case .decoding(let message): return message
        case .unknown(let message): return message
        case .badRequest: return "Bad request"
        case .forbidden: return "Forbidden"
        case .notFound: return "Not Found"
        case .serverError: return "Server error"
        case .unknownStatus(let code): return "Server returned status code \(code)"
        case .invalidResponse: return "Invalid response"
        }
    }
}
