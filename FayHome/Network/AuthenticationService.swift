//
//  AuthenticationService.swift
//  FayHome
//
//  Created by Momo Khan on 6/30/25.
//

import Combine
import Foundation

final class AuthenticationService: ObservableObject {
    @Published private(set) var isAuthenticated = false
    @Published private(set) var accessToken: String?
    
    static let shared = AuthenticationService()
    
    func signin(username: String, password: String) async {
        do {
            let response: AuthResponse? = try await NetworkClient.shared.sendRequest(route: FayRoutes.Signin(loginRequest: .init(username: username, password: password)))
            guard let token = response?.token else {
                return
            }
            accessToken = token
            self.isAuthenticated = true
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    func signout() {
        isAuthenticated = false
        accessToken = nil
    }
}

