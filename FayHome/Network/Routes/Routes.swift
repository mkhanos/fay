//
//  Route.swift
//  FayHome
//
//  Created by Momo Khan on 6/30/25.
//

import Foundation

protocol Route {
    associatedtype Response: Decodable
    
    var baseURL: String { get }
    var scheme: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String] { get }
    var queryItems: [URLQueryItem]? { get }
    var body: Data? { get }
}

extension Route {
    var baseURL: String {
        return "node-api-for-candidates.onrender.com"
    }
    
    var scheme: String {
        return "https"
    }
    
    var headers: [String: String] { [:] }
    var queryItems: [URLQueryItem]? { nil }
    
    func buildRequest() throws -> URLRequest {
        var components = URLComponents()
        components.scheme = scheme
        components.host = baseURL
        components.path = path
        components.queryItems = queryItems
        
        guard let url = components.url else {
            throw NetworkError.badURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.httpBody = body
        
        for (key, value) in headers {
            request.addValue(value, forHTTPHeaderField: key)
        }

        return request
    }
}

enum FayRoutes {
    struct Signin: Route {
        struct LoginRequest: Encodable {
            let username: String
            let password: String
        }
        
        typealias Response = AuthResponse
        
        var path: String { "/signin" }
        
        var method: HTTPMethod { .post }
        
        var headers: [String: String] {
            ["Content-Type": "application/json"]
        }
        
        let loginRequest: LoginRequest
        
        var body: Data? {
            try? JSONEncoder().encode(loginRequest)
        }
    }

    struct GetAppointments: Route {
        let token: String
        
        var body: Data? { nil }
        
        typealias Response = [Appointment]
        
        var path: String { "/appointments" }
        
        var method: HTTPMethod { .get }
        
        var headers: [String : String] {
            [
                "Authorization": "Bearer \(token)"
            ]
        }
    }
}

