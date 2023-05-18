//
//  SideMenuView.swift
//  FSMP_DELIVERY
//
//  Created by Philip Andersson on 2023-05-12.
//

import SwiftUI

struct SideMenuView: View {
    
    var body: some View {
        
        NavigationStack {
            
            VStack(alignment: .leading) {
                Text("Menu")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding()
                
                Spacer()
                
                Button(action: {}){
                    NavigationLink(destination: CustomerView()) {
                        Text("Manage Orders")
                    }
                }
                .buttonStyle(CustomButtonStyle1())
                .padding()
                Button(action: {}){
                    NavigationLink(destination: CustomerView()) {
                        Text("Activer Orders")
                    }
                }
                .buttonStyle(CustomButtonStyle1())
                .padding()
                Button(action: {}){
                    NavigationLink(destination: CustomerView()) {
                        Text("History")
                    }
                }
                .buttonStyle(CustomButtonStyle1())
                .padding()
                Button(action: {}){
                    NavigationLink(destination: CustomerView()) {
                        Text("Customer")
                    }
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
}
