//
//  CustomButtonStyle2.swift
//  FSMP_DELIVERY
//
//  Created by Philip Andersson on 2023-05-11.
//

import Foundation
import SwiftUI


struct CustomButtonStyle2: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(8)
            .foregroundColor(Color.accentColor)
            .background(Color.gray.opacity(0.2))
            .cornerRadius(16)
            .fontWeight(.semibold)
    }
}
