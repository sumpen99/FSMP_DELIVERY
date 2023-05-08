//
//  ContentView.swift
//  FSMP_DELIVERY
//
//  Created by fredrik sundström on 2023-05-08.
//

import SwiftUI
import FirebaseCore
struct ContentView: View {
    @EnvironmentObject var firebaseAuth: FirebaseAuth
    @EnvironmentObject var firestoreViewModel: FirestoreViewModel
    var body: some View {
        if firebaseAuth.isLoggedIn{
            Button("Logout"){
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    firebaseAuth.signOut()
                    
                }
            }
        }
        else{
            Button("Login"){
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    firebaseAuth.loginWithEmail("fredrik1@fredrik.se", password: "fredrik1"){_,_ in
                    }
                }
                
            }
            
        }
    }
    
}
