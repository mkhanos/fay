//
//  EntryView.swift
//  FayHome
//
//  Created by Momo Khan on 6/30/25.
//

import SwiftUI

struct EntryView: View {
    @ObservedObject private var authService = AuthenticationService.shared
    @State private var selection: TabValue = .appointments
    var body: some View {
        if authService.isAuthenticated {
            TabView(selection: $selection) {
                Tab("Appointments", image: selection == .appointments ? "Calendar" : "Calendar-1", value: TabValue.appointments) {
                    AppointmentsView()
                }
                Tab("Chat", image: "Chats", value: TabValue.chat) {
                    
                }
                Tab("Journal", image: "Notebook text", value: TabValue.journal) {
                }
                Tab("Profile", image: "User", value: TabValue.profile) {

                }
            }
            .tint(.fayPrimary)
        } else {
            LoginView(viewModel: .init())
        }
    }
}

enum TabValue: String {
    case appointments, chat, journal, profile
}
