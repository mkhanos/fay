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
                if let nextAppt = viewModel.nextAppt {
                    AppointmentCard(appt: nextAppt, isNext: true)
                }
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
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Text("Appointments")
                    .font(.manrope(.title))
                    .foregroundColor(.textBase)
            }
            ToolbarItem(placement: .topBarTrailing) {
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
            
        }
        
    }
}

struct AppointmentCard: View {
    let appt: Appointment
    var isNext: Bool = false
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
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
            if isNext {
                Button(action: {
                    print("Won't do!")
                }) {
                    HStack {
                        Image("Videocamera")
                        Text("Join Appointment")
                    }
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .font(.manrope(.smallBodyBold))
                    .fayPrimaryButton()
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .roundedBorder(cornerRadius: 16, fill: .white, stroke: isNext ? .neutral50 : .stroke)
        .shadow(color: isNext ? Color.black.opacity(0.1) : .clear, radius: 12, x: 0, y: 4)
        
        
        
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
        guard let date = isoFormatter.date(from: self) else { return "No time found" }
        
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

#Preview {
    AppointmentCard(appt: Appointment(appointment_id: "mzdqmf1786",
                                      patient_id: "1",
                                      status: .scheduled,
                                      appointment_type: .followUp,
                                      start: "2025-01-27T17:45:00Z",
                                      end: "2025-01-27T18:30:00Z",
                                      duration_in_minutes: 45,
                                      recurrence_type: .weekly),
                    isNext: true)
    .padding()
    .background(Color.gray)
}
