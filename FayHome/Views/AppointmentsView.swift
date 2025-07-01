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
    var body: some View {
        ScrollView(.vertical) {
            LazyVStack(alignment: .center, spacing: 16) {
                ForEach(viewModel.upcomingAppts, id: \.appointment_id) { appt in
                    AppointmentCard(appt: appt)
                }
            }
            .scrollTargetLayout()
        }
        .contentMargins(.horizontal, 24)
        .scrollTargetBehavior(.viewAligned)
        .scrollIndicators(.hidden)
        .onAppear {
            Task {
                await viewModel.getAppointments()
            }
        }
    }
}

struct AppointmentCard: View {
    let appt: Appointment
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            ZStack(alignment: .topLeading) {
                Color.neutral50
                VStack(alignment: .center, spacing: 0) {
                    Text("\(appt.start.extractMonth())")
                        .font(.manrope(.semibold, size: 14))
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal, 8)
                        .foregroundColor(.fayPrimary)
                        .background(Color.calendarHeader)
                        .padding(.vertical, 1)
                    Text("\(appt.start.extractDate())")
                        .font(.manrope(.semibold, size: 20))
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.textBase)
                        .background(Color.neutral50)
                        .padding(.vertical, 2)
                        
                }
            }
            .frame(width: 48, height: 48)
            .cornerRadius(3.6)
            
            
            VStack(alignment: .leading) {
                Text("\(appt.start.extractHour())")
                    .font(.manrope(.smallBodyBold))
                    .foregroundColor(.textBase)
                Text("\(appt.appointment_type.rawValue)")
                    .font(.manrope(.captionMedium))
                    .foregroundColor(.textSubtitle)
            }
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .padding()
        .fayAppointmentStroke()
        
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
                self.upcomingAppts = appointments
            } catch {
                print(error.localizedDescription)
            }
            
        }
    }
}

extension String {
    func extractHour(includeMinutes: Bool = false) -> String {
        let isoFormatter = ISO8601DateFormatter()
        guard let date = isoFormatter.date(from: self) else { return "No time found" }
        
        let hourFormatter = DateFormatter()
        hourFormatter.dateFormat = includeMinutes ? "h:mm a" : "h a"
        
        return hourFormatter.string(from: date)
    }
    
    func extractMonth() -> String {
        let isoFormatter = ISO8601DateFormatter()
        guard let date = isoFormatter.date(from: self) else { return "N/A" }
        
        let monthFormatter = DateFormatter()
        monthFormatter.dateFormat = "MMM"
        
        return monthFormatter.string(from: date).uppercased()
    }
    
    func extractDate() -> String {
        let isoFormatter = ISO8601DateFormatter()
        guard let date = isoFormatter.date(from: self) else { return "N/A" }
        
        let monthFormatter = DateFormatter()
        monthFormatter.dateFormat = "dd"
        
        return monthFormatter.string(from: date)
    }
}

#Preview {
    AppointmentCard(appt: Appointment(appointment_id: "mzdqmf1786",
                                      patient_id: "1",
                                      status: .scheduled,
                                      appointment_type: .followUp,
                                      start: "2025-01-27T17:45:00Z",
                                      end: "2025-01-27T18:30:00Z",
                                      duration_in_minutes: 45,
                                      recurrence_type: .weekly))
}


