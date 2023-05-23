//
//  AdminView.swift
//  FSMP_DELIVERY
//
//  Created by fredrik sundström on 2023-05-22.
//

import SwiftUI
struct AdminView: View{
    @EnvironmentObject var firebaseAuth: FirebaseAuth
    var body: some View{
        ZStack{
            Color(red: 255/256, green: 255/256, blue: 255/256)
                .ignoresSafeArea()
            VStack{
                createAccountView()
                Button(action: { firebaseAuth.signOut() }) {
                    Text("Logga ut")
                        .font(.title2)
                        .bold ()
                        .foregroundColor(.black)
                        .padding()
                        .background(Color(red: 239/256, green: 167/256, blue: 62/256))
                        .cornerRadius(40.0)
                }
            }
        }
    }
}
struct AdminView_Previews: PreviewProvider {
    static var previews: some View {
        AdminView()
    }
}

