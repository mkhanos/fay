//
//  Appointment.swift
//  FayHome
//
//  Created by Momo Khan on 6/30/25.
//

import Foundation
import SwiftData

struct Appointment: Decodable {
    var appointment_id: String
    var patient_id: String
    var status: AppointmentStatus
    var appointment_type: AppointmentType
    var start: Date
    var end: Date
    var duration_in_minutes: Int
    var recurrence_type: RecurrenceType
}

enum AppointmentStatus: String, Decodable {
    case scheduled = "Scheduled"
    case occurred = "Occurred"
}

enum AppointmentType: String, Decodable {
    case followUp = "Follow-up"
    case initial = "Initial consultation"
}

enum RecurrenceType: String, Decodable {
    case weekly = "Weekly"
    case monthly = "Monthly"
}
