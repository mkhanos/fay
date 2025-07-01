//
//  AppointmentsList.swift
//  FayHome
//
//  Created by Momo Khan on 7/1/25.
//

import SwiftUI

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
