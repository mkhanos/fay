//
//  AppointmentsView.swift
//  FayHome
//
//  Created by Momo Khan on 7/1/25.
//

import Combine
import SwiftUI

enum AppointmentDate: String, CaseIterable {
    case upcoming = "Upcoming"
    case past = "Past"
}

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

struct AppointmentPicker: View {
    @Binding var selectedAppointments: AppointmentDate
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(AppointmentDate.allCases, id: \.self) { date in
                VStack(spacing: 0) {
                    Spacer()
                    Text(date.rawValue)
                        .frame(maxWidth: .infinity)
                        .foregroundColor(selectedAppointments == date ? .fayPrimary : .textSubtitle)
                        .font(.manrope(.smallBodyBold))
                    Spacer()
                    Rectangle()
                        .fill(selectedAppointments == date ? .fayPrimary : .textSubtitle)
                        .frame(height: 1)
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    withAnimation {
                        selectedAppointments = date
                    }
                }
            }
        }
        .frame(maxHeight: 45)
    }
 
}

struct AppointmentsList: View {
    @Binding var selectedAppointments: AppointmentDate
    @ObservedObject var viewModel: AppointmentsView.ViewModel
    
    var body: some View {
        ScrollView(.vertical) { // appointment list
            LazyVStack(alignment: .center, spacing: 16) {
                if selectedAppointments == .upcoming {
                    if let nextAppt = viewModel.nextAppt {
                        AppointmentCard(appt: nextAppt,appointmentDate: .upcoming, isNext: true)
                    }
                    ForEach(viewModel.upcomingAppts, id: \.appointment_id) { appt in
                        AppointmentCard(appt: appt, appointmentDate: .upcoming)
                    }
                } else {
                    ForEach(viewModel.pastAppts, id: \.appointment_id) { appt in
                        AppointmentCard(appt: appt, appointmentDate: .past)
                    }
                }
                
            }
            .scrollTargetLayout()
        }
        .contentMargins(24)
        .scrollTargetBehavior(.viewAligned)
        .scrollIndicators(.hidden)
    }
}

struct AppointmentCard: View {
    let appt: Appointment
    var appointmentDate: AppointmentDate
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
                            .foregroundColor(appointmentDate == .upcoming ? .fayPrimary : .textBase)
                            .background(appointmentDate == .upcoming ? Color.calendarUpcomingHeader : Color.calendarPastHeader)
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
                    appointmentDate: .upcoming,
                    isNext: true)
    .padding()
    .background(Color.gray)
}

#Preview {
    @Previewable @State var selectedAppointments: AppointmentDate = .upcoming
    AppointmentPicker(selectedAppointments: $selectedAppointments)
}

