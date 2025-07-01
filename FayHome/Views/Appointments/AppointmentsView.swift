//
//  AppointmentsView.swift
//  FayHome
//
//  Created by Momo Khan on 7/1/25.
//

import Combine
import SwiftUI

struct AppointmentsView: View {
    @StateObject var viewModel = ViewModel()
    @State var selectedAppointments: AppointmentDate = .upcoming
    var body: some View {
        VStack(spacing: 0) { // appointments container
            VStack(spacing: 0) { // top divider toolbar stack
                HStack {
                    Text("Appointments")
                        .font(.manrope(.title))
                        .foregroundColor(.textBase)
                    Spacer()
                    HStack {
                        Image("NewIcon")
                        Text("New")
                            .font(.manrope(.smallBodyBold))
                            .foregroundColor(.textBase)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .roundedBorder(cornerRadius: 8, fill: .white, stroke: .stroke)
                }
                .padding(.horizontal, 24)
                AppointmentPicker(selectedAppointments: $selectedAppointments)
            }
            
            AppointmentsList(selectedAppointments: $selectedAppointments, viewModel: viewModel)
        }
        .onAppear {
            Task {
                await viewModel.getAppointments()
            }
        }
    }
}

extension AppointmentsView {
    class ViewModel: ObservableObject {
        private var appointmentService = AppointmentService()
        @Published var nextAppt: Appointment?
        @Published var upcomingAppts: [Appointment] = []
        @Published var pastAppts: [Appointment] = []
        
        func getAppointments() async  {
            do {
                let appointments = try await appointmentService.getAppointments()
                let formatter = ISO8601DateFormatter()
                for appointment in appointments {
                    guard let date = formatter.date(from: appointment.start) else { continue }
                    if date >= Date.now {
                        upcomingAppts.append(appointment)
                    } else {
                        pastAppts.append(appointment)
                    }
                }
                if upcomingAppts.isEmpty {
                    nextAppt = nil
                } else {
                    nextAppt = upcomingAppts.removeFirst()
                }
            } catch {
                print(error.localizedDescription)
            }
            
        }
    }
}

extension String {
    func extractHour(includeMinutes: Bool = false) -> String {
        let isoFormatter = ISO8601DateFormatter()
        guard let date = isoFormatter.date(from: self) else { return "N/A" }
        
        let hourFormatter = DateFormatter()
        hourFormatter.timeZone = .current
        hourFormatter.dateFormat = includeMinutes ? "h:mm a" : "h a"
        
        return hourFormatter.string(from: date)
    }
    
    func extractMonth() -> String {
        let isoFormatter = ISO8601DateFormatter()
        guard let date = isoFormatter.date(from: self) else { return "N/A" }
        
        let monthFormatter = DateFormatter()
        monthFormatter.timeZone = .current
        monthFormatter.dateFormat = "MMM"
        
        return monthFormatter.string(from: date).uppercased()
    }
    
    func extractDate() -> String {
        let isoFormatter = ISO8601DateFormatter()
        guard let date = isoFormatter.date(from: self) else { return "N/A" }
        
        let dayFormatter = DateFormatter()
        dayFormatter.timeZone = .current
        dayFormatter.dateFormat = "dd"
        
        return dayFormatter.string(from: date)
    }
}
