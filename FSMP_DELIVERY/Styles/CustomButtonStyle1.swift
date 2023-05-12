//
//  ButtonStyle.swift
//  FSMP_DELIVERY
//
//  Created by Philip Andersson on 2023-05-11.
//

import Foundation
import SwiftUI
import FirebaseFirestoreSwift

struct CustomButtonStyle1: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(8)
            .foregroundColor(.white)
            .background(Color.accentColor)
            .cornerRadius(16)
            .fontWeight(.semibold)
    }
}
