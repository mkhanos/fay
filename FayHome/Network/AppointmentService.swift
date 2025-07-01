//
//  AppointmentService.swift
//  FayHome
//
//  Created by Momo Khan on 7/1/25.
//

import Combine
import SwiftUI

final class AppointmentService: ObservableObject {
    func getAppointments() async throws -> [Appointment] {
        guard let token = AuthenticationService.shared.accessToken else {
            return []
        }
        let response: AppointmentResponse = try await NetworkClient.shared.sendRequest(route: FayRoutes.GetAppointments(token: token))
        return response.appointments
    }
}
