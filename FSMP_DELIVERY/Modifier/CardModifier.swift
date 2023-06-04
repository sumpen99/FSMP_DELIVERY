//
//  CardModifier.swift
//  FSMP_DELIVERY
//
//  Created by fredrik sundström on 2023-06-04.
//

import SwiftUI

struct CardModifier: ViewModifier{
    let size:CGFloat
    func body(content: Content) -> some View {
        content
            .frame(height: size)
            .clipShape(RoundedRectangle(cornerRadius: 15))
            .fillSection()
    }
}
