//
//  DeviceShakeModifier.swift
//  FSMP_DELIVERY
//
//  Created by fredrik sundström on 2023-05-17.
//

import SwiftUI

struct DeviceShakeViewModifier: ViewModifier {
    let action: () -> Void

    func body(content: Content) -> some View {
        content
            .onAppear()
            .onReceive(NotificationCenter.default.publisher(for: UIDevice.deviceDidShakeNotification)) { _ in
                action()
            }
    }
}
