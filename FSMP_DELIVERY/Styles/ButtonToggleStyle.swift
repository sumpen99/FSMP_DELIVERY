//
//  ButtonToggleStyle.swift
//  FSMP_DELIVERY
//
//  Created by fredrik sundström on 2023-06-04.
//

import SwiftUI

struct ButtonToogleStyle: ToggleStyle {
    let isShowingText:Text
    let isClosedtext:Text
    func makeBody(configuration: Self.Configuration) -> some View {

        return HStack() {
            Button(action: {configuration.isOn.toggle()}, label: {
                configuration.isOn ? isShowingText : isClosedtext
            })
        }
    }
}
