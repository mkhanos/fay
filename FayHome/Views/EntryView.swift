//
//  EntryView.swift
//  FayHome
//
//  Created by Momo Khan on 6/30/25.
//

import SwiftUI

struct EntryView: View {
    @ObservedObject var authService = AuthenticationService.shared
    var body: some View {
        if authService.isAuthenticated {
            AppointmentsView()
        } else {
            LoginView(viewModel: .init())
        }
    }
}
