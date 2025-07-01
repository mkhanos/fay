//
//  FayHomeApp.swift
//  FayHome
//
//  Created by Momo Khan on 6/30/25.
//

import SwiftUI

@main
struct FayHomeApp: App {
    let networkClient: NetworkClient
    let authenticationService: AuthenticationService
    
    init() {
        self.networkClient = NetworkClient()
        self.authenticationService = AuthenticationService(networkClient: networkClient)
    }

    var body: some Scene {
        WindowGroup {
            EntryView()
        }
        .environmentObject(authenticationService)
    }
}
