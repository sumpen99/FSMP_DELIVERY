//
//  SideMenuView.swift
//  FSMP_DELIVERY
//
//  Created by Philip Andersson on 2023-05-12.
//

import SwiftUI

struct SideMenuView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("Menu")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding()
            
            Spacer()
            Button("Manage orders") {
                print("go to manage orders")
            }
            .buttonStyle(CustomButtonStyle1())
            .padding()
            Button("Active Orders") {
                print("go to manage orders")
            }
            .buttonStyle(CustomButtonStyle1())
            .padding()
            Button("History") {
                print("go to manage orders")
            }
            .buttonStyle(CustomButtonStyle1())
            .padding()
            
            Button("Customer") {
                print("go to manage orders")
            }
            .buttonStyle(CustomButtonStyle1())
            .padding()
            Spacer()
        }
        .padding(16)
        .background(Color.gray.opacity(0.95))
        .edgesIgnoringSafeArea(.bottom)
    }
}

struct SideMenuView_Previews: PreviewProvider {
    static var previews: some View {
        SideMenuView()
    }
}
