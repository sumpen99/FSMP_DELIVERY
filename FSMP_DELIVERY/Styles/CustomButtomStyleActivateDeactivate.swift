//
//  CustomButtomStyleActivateDeactivate.swift
//  FSMP_DELIVERY
//
//  Created by Philip Andersson on 2023-06-05.
//

import SwiftUI

struct CustomButtonStyleActivateDeactivate: ButtonStyle {
    let isActivated: Bool
    
    public func makeBody(configuration: ButtonStyle.Configuration) -> some View {
        ActivateDeactivate(configuration: configuration, isActivated: isActivated)
    }
    
    struct ActivateDeactivate: View {
        let configuration: ButtonStyle.Configuration
        let isActivated: Bool
        
        var body: some View {
            configuration.label
                .padding(8)
                .foregroundColor(Color.white)
                .background(isActivated ? Color.accentColor : Color.red)
                .cornerRadius(16)
                .fontWeight(.semibold)
        }
    }
}
