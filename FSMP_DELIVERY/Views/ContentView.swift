//
//  ContentView.swift
//  FSMP_DELIVERY
//
//  Created by fredrik sundström on 2023-05-08.
//

import SwiftUI
import FirebaseCore
import Firebase

struct ContentView: View {
    
    @EnvironmentObject var firebaseAuth: FirebaseAuth
    @EnvironmentObject var firestoreViewModel: FirestoreViewModel
    
    @State var signedIn : Bool = false
    
    var body: some View {
        if !signedIn {
            SignInView(signedIn: $signedIn)
        } else {
            MainView()
        }
    }

    
//    var body: some View {
//        if firebaseAuth.isLoggedIn{
//            Button("Logout"){
//                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//                    firebaseAuth.signOut()
//
//                }
//            }
//        }
//        else{
//            Button("Login"){
//                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//                    firebaseAuth.loginWithEmail("fredrik1@fredrik.se", password: "fredrik1"){_,_ in
//                    }
//                }
//
//            }
//
//        }
//    }
    
}

struct SignInView : View {
    
    @EnvironmentObject var firebaseAuth: FirebaseAuth
    @EnvironmentObject var firestoreViewModel: FirestoreViewModel
    
    @Binding var signedIn : Bool
    
    var auth = Auth.auth()
    
    var body: some View {
        Button("Login"){
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                firebaseAuth.loginWithEmail("fredrik1@fredrik.se", password: "fredrik1"){ result, error in
                    if let _ = error {
                        print("error signing in")
                    } else {
                        print("signed in")
                        signedIn = true
                    }
                }
            }
            
        }
    }
}
