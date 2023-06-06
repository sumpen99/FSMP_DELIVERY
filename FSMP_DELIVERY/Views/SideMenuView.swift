//
//  SideMenuView.swift
//  FSMP_DELIVERY
//
//  Created by Philip Andersson on 2023-05-12.
//

import SwiftUI

struct SideMenuView: View {
    @EnvironmentObject var firebaseAuth: FirebaseAuth
    @Binding var closeMenuOnDissapear:Bool
    var releaseFirebaseData: (() -> Void)? = nil
    var body: some View {
        
        NavigationStack {
            
            VStack(alignment: .leading) {
                
                Button(action: {}){
                    NavigationLink(destination:LazyDestination(destination: { OrderHistoryView() })) {
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
                Spacer()

                Button(action: {
                    releaseFirebaseData?()
                    firebaseAuth.signOut()
                    
                }){
                    Text("Sign Out")
                }
                .foregroundColor(.white)
                .padding(8)
                .background(Color.red)
                .cornerRadius(16)
                .fontWeight(.semibold)
                .padding()
                
            }
            .padding(16)
            .background(Color.gray.opacity(0.95))
            .edgesIgnoringSafeArea(.bottom)
            
        }
        .onDisappear{
            closeMenuOnDissapear.toggle()
        }
    }
    
    struct SideMenuView_Previews: PreviewProvider {
        @State static var c:Bool = false
        static var previews: some View {
            SideMenuView(closeMenuOnDissapear:SideMenuView_Previews.$c)
                .environmentObject(FirebaseAuth())
        }
    }
}
