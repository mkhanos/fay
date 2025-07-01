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
    var body: Data? { nil }
    
    func buildRequest() throws -> URLRequest {
        var components = URLComponents()
        components.scheme = scheme
        components.host = baseURL
        components.path = path
        
        guard let url = components.url else {
            throw NetworkError.badURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        return request
    }
}

struct Signin: Route {
    struct LoginRequest: Encodable {
        let username: String
        let password: String
    }
    
    typealias Response = String
    
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
    typealias Response = [Appointment]
    
    var path: String { "/appointments" }
    
    var method: HTTPMethod { .get }
}
