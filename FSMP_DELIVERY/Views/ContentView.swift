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
        ZStack{
            Color(red: 29/256, green: 38/256, blue: 57/256)
                .ignoresSafeArea()
            if !signedIn {
                SignInView(signedIn: $signedIn)
            } else {
                MainView()
            }
        }
    }

    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
           ContentView()
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
        
        VStack{
            Spacer()
            Image ("delivery")
                .resizable()
                .padding(.leading, 20.0)
                .scaledToFit()
            Spacer()
            Button(action: {
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
            }){
                    HStack{
                        Image(systemName: "person.circle")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(Color.white)
                            .padding(.leading)
                        Text("Sign in")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(Color.white)
                            .padding([.top, .bottom, .trailing])
                    }
                    .background(Color(red: 239/256, green: 167/256, blue: 62/256))
                    .cornerRadius(40.0)
            }
            Spacer()
        }
    }
}
