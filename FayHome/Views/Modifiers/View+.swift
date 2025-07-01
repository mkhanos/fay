//
//  View+.swift
//  FayHome
//
//  Created by Momo Khan on 7/1/25.
//

import SwiftUI

struct RoundedBorderModifier: ViewModifier {
    var cornerRadius: CGFloat
    var fill: Color
    var stroke: Color
    
    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(fill)
                    .overlay(
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .stroke(stroke)
                    )
            )
    }
}

extension View {
    func roundedBorder(cornerRadius: CGFloat, fill: Color, stroke: Color) -> some View {
        self.modifier(RoundedBorderModifier(cornerRadius: cornerRadius, fill: fill, stroke: stroke))
    }
    
    func fayLoginStroke() -> some View {
        self.roundedBorder(cornerRadius: 8, fill: .clear, stroke: .stroke)
    }
    
    func fayAppointmentStroke() -> some View {
        self.roundedBorder(cornerRadius: 16, fill: .clear, stroke: .stroke)
    }
    
    func fayPrimaryButton() -> some View {
        self.roundedBorder(cornerRadius: 8, fill: .fayPrimary, stroke: .fayPrimary)
    }
}
