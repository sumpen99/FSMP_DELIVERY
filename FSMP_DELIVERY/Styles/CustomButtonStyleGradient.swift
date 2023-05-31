//
//  CustomButtonStyleGradient.swift
//  FSMP_DELIVERY
//
//  Created by fredrik sundström on 2023-05-29.
//

import SwiftUI

struct CustomButtonStyleGradient: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled: Bool
    private let colors: [Color]
    
    init(mcolors: [Color] = [.mint.opacity(0.6), .mint, .mint.opacity(0.6), .mint]){
        self.colors = mcolors
    }
    
    @ViewBuilder private func backgroundView(configuration: Configuration) -> some View {
        if !isEnabled { disabledBackground }
        else if configuration.isPressed { pressedBackground }
        else { enabledBackground }
    }
    
    private var enabledBackground: some View {
        LinearGradient(
            colors: colors,
            startPoint: .topLeading,
            endPoint: .bottomTrailing)
    }

    private var disabledBackground: some View {
        LinearGradient(
            colors: [.gray],
            startPoint: .topLeading,
            endPoint: .bottomTrailing)
    }

    private var pressedBackground: some View {
        LinearGradient(
            colors: colors,
            startPoint: .topLeading,
            endPoint: .bottomTrailing)
        .opacity(0.4)
    }
    
    func makeBody(configuration: Configuration) -> some View {
          HStack {
            configuration.label
          }
          .font(.body.bold())
          .foregroundColor(isEnabled ? .white : .accentColor)
          .padding()
          .frame(height: 44)
          .background(backgroundView(configuration: configuration))
          .cornerRadius(10)
          .fontWeight(.semibold)
          .disabled(!isEnabled)
    }
  
}

