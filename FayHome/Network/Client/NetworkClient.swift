//
//  NetworkClient.swift
//  FayHome
//
//  Created by Momo Khan on 6/30/25.
//

import Foundation

protocol NetworkClientProtocol {
    func sendRequest<T: Decodable>(endpoint: any Route) async throws -> T
}

final class NetworkClient: NetworkClientProtocol {
    private var session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    public func sendRequest<T: Decodable>(endpoint: any Route) async throws -> T {
        do {
            let request = try endpoint.buildRequest() // handle network error.badurl
            let (data, response) = try await session.data(for: request) // check response code here and throw if not 2-300
            try handleResponse(response: response)
            let decodedObject = try JSONDecoder().decode(T.self, from: data) // throw on decoding
            return decodedObject
        } catch let error as DecodingError {
            switch error {
            case .typeMismatch(let type, let context):
                throw NetworkError.decoding("Expected type \(type.self) - \(context.debugDescription)")
            case .valueNotFound(let value, let context):
                throw NetworkError.decoding("Expected value \(value.self) - \(context.debugDescription)")
            case .keyNotFound(let key, let context):
                throw NetworkError.decoding("Missing key: \(key.stringValue) – \(context.debugDescription)")
            case .dataCorrupted(let context):
                throw NetworkError.decoding("Attempted to decode corrupt data - \(context.debugDescription)")
            @unknown default:
                throw NetworkError.unknown("Unknown error - \(error.localizedDescription)")
            }
        }
    }
    
    private func handleResponse(response: URLResponse?) throws {
        guard let response = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        switch response.statusCode {
        case 200...299:
            return
        case 400:
            throw NetworkError.badRequest
        case 403:
            throw NetworkError.forbidden
        case 404:
            throw NetworkError.notFound
        case 500...599:
            throw NetworkError.serverError
        default:
            throw NetworkError.unknownStatus(response.statusCode)
        }
    }
}
