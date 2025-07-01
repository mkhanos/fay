//
//  AppointmentPicker.swift
//  FayHome
//
//  Created by Momo Khan on 7/1/25.
//

import SwiftUI

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

#Preview {
    @Previewable @State var selectedAppointments: AppointmentDate = .upcoming
    AppointmentPicker(selectedAppointments: $selectedAppointments)
}
