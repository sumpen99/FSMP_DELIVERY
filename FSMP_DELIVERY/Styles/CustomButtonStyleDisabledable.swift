//
//  CustomButtonStyleDisabledable.swift
//  FSMP_DELIVERY
//
//  Created by fredrik sundström on 2023-05-17.
//

import SwiftUI

struct CustomButtonStyleDisabledable: ButtonStyle {

    public func makeBody(configuration: ButtonStyle.Configuration) -> some View {
        Disabledable(configuration: configuration)
    }

    struct Disabledable: View {

        let configuration: ButtonStyle.Configuration

        @Environment(\.isEnabled) private var isEnabled: Bool

        var body: some View {
            configuration.label
                .padding(8)
                .foregroundColor(isEnabled ? (configuration.isPressed ? Color.white.opacity(0.5) : Color.white) : Color.accentColor)
                .background(isEnabled ? Color.accentColor : Color.gray.opacity(0.2))
                .cornerRadius(16)
                .fontWeight(.semibold)
                .disabled(!isEnabled)
        }
    }
}
