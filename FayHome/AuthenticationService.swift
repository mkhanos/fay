//
//  AuthenticationService.swift
//  FayHome
//
//  Created by Momo Khan on 6/30/25.
//

import Foundation
import Combine

final class AuthenticationService: ObservableObject {
    @Published private(set) var isAuthenticated = false
    @Published private(set) var accessToken: String?
    
    private var networkClient: NetworkClientProtocol
    
    init(networkClient: NetworkClientProtocol) {
        self.networkClient = networkClient
    }
    
    func signin(username: String, password: String) async throws {
        let response: AuthResponse? = try await networkClient.sendRequest(route: Signin(loginRequest: .init(username: username, password: password)))
        guard let token = response?.token else {
            return
        }
        accessToken = token
        self.isAuthenticated = true
    }
    
    func signout() {
        isAuthenticated = false
        accessToken = nil
    }
}

