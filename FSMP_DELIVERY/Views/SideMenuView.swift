//
//  SideMenuView.swift
//  FSMP_DELIVERY
//
//  Created by Philip Andersson on 2023-05-12.
//

import SwiftUI

struct SideMenuView: View {
    @EnvironmentObject var firebaseAuth: FirebaseAuth
    var body: some View {
        
        NavigationStack {
            
            VStack(alignment: .leading) {
                Text("Menu")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding()
                
                Spacer()
                
                .buttonStyle(CustomButtonStyle1())
                .padding()
                Button(action: {}){
                    NavigationLink(destination: CustomerView()) {
                        Image(systemName: "list.bullet.clipboard.fill")
                        Text("History")
                    }
                }
                .buttonStyle(CustomButtonStyle1())
                .padding()
                Button(action: {}){
                    NavigationLink(destination: CustomerView()) {
                        Image(systemName: "person.text.rectangle.fill")
                        Text("Customer")
                    }
                }
                .buttonStyle(CustomButtonStyle1())
                .padding()
                
                if firebaseAuth.loggedInAs == .ADMIN {
                    Button(action: {}){
                        NavigationLink(destination: createAccountView()){
                            Image(systemName: "person.crop.circle.fill")
                            Text("Create account")
                        }
                    }
                    .buttonStyle(CustomButtonStyle1())
                    .padding()
                }
                Button(action: {firebaseAuth.signOut()}){
                    Text("Sign Out")
                }
                .foregroundColor(.white)
                .padding(8)
                .background(Color.red)
                .cornerRadius(16)
                .fontWeight(.semibold)
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
                .environmentObject(FirebaseAuth())
        }
    }
}
