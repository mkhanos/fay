//
//  AppointmentCard.swift
//  FayHome
//
//  Created by Momo Khan on 7/1/25.
//

import SwiftUI

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
                    Text(isNext ?  "\(appt.start.extractHour(includeMinutes: true)) - \(appt.end.extractHour(includeMinutes: true)) " : "\(appt.start.extractHour())")
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
