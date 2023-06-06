//
//  FillFormModifier.swift
//  FSMP_DELIVERY
//
//  Created by fredrik sundström on 2023-06-04.
//

import SwiftUI
struct FillFormModifier: ViewModifier{
    func body(content: Content) -> some View{
        content
            .listRowBackground(Color.clear)
            .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
    }
}
