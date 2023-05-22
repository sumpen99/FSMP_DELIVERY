//
//  AdminView.swift
//  FSMP_DELIVERY
//
//  Created by fredrik sundström on 2023-05-22.
//

import SwiftUI
struct AdminPage: View{
    @EnvironmentObject var firebaseAuth: FirebaseAuth
    var body: some View{
        ZStack{
            Button(action: { firebaseAuth.signOut() }) {
                Text("Logga ut").font(.largeTitle)
            }
        }
    }
}
